package Message;
use Mojo::Base 'Mojolicious';

use Message::Schema;

# This method will run once at server start
sub startup {
    my $self = shift;

    # Load configuration from hash returned by "my_app.conf"
    my $config = $self->plugin('Config');

    (ref $self)->attr(
        db => sub {
            Message::Schema->connect(
                $config->{db}->{dsn},
                $config->{db}->{user},
                $config->{db}->{pass},
                {
                    sqlite_unicode => 1,
                    mysql_enable_utf8mb4 => 1,
                    mysql_auto_reconnect => 1,
                    RaiseError => 1,
                    AutoCommit => 1
                });
    });

    $self->plugin('Human', {
            datetime    => '%d.%m.%Y %H:%M:%S',
            time        => '%H:%M:%S',
            date        => '%d.%m.%Y',
        });

    $DateTimeX::Format::Ago::__{CZE} = {
        future => "v budoucnosti",
        recent => "právě teď",
        minutes => ["před %d minutami", "před minutou"],
        hours => ["před %d hodinami", "před hodinou"],
        days => ["před %d dny", "včera"],
        weeks => ["před %d týdny", "před týdnem"],
        months => ["před %d měsíci", "před měsícem"],
        years => ["před %d lety", "před rokem"],
    };

    $self->plugin('TimeAgo', {
            default => 'cze',
        });

    $self->plugin('Message::Helper');

    $self->plugin('authentication', {
            autoload_user => 1,
            session_key => 'message-pl',
            load_user => sub {
                my ($c, $id) = @_;
                return $c->app->db->resultset('Author')->find($id);
            },
            validate_user => sub {
                my ($c, $username, $password, $extra) = @_;
                my $author = $c->app->db->resultset('Author')->find({
                        id => 1,
                    });
                use Data::Dumper;
                return $author->id if defined $author;
                return undef;
            },
        });


    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer') if $config->{perldoc};

    $self->commands->namespaces([qw/Message::Command/]);

    $self->app->secrets($config->{secrets});

    # Router
    my $r = $self->routes;
    $r = $r->namespaces([qw/Message::Controller/]);

    # Normal route to controller
    $r->get('/')->over(authenticated => 1)->to('dashboard#index')->name('index');

    $r->get('/')->over(authenticated => 0)->to(cb => sub { return shift->redirect_to('login'); });
    $r->route('/login')->to('dashboard#login')->name('login');
    $r->route('/logout')->to(cb => sub {
        my $self = shift;
        $self->logout;
        $self->redirect_to('/');
        })->name('logout');

    $r = $r->under('/', authenticated => 1);
    $r->get('/topic/:id')->to('topic#show')->name('topicid');
    $r->route('/topic/:id/comment')->to('message#create')->name('add_message');
    $r->route('/message/:id/edit')->to('message#edit')->name('edit_message');
}

1;
