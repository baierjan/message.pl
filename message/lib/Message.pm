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

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer') if $config->{perldoc};

    $self->commands->namespaces([qw/Message::Command/]);

    $self->app->secrets($config->{secrets});

    # Router
    my $r = $self->routes;
    $r = $r->namespaces([qw/Message::Controller/]);

    # Normal route to controller
    $r->get('/')->to('topic#show', id => 1);
    $r->get('/topic/:id')->to('topic#show');
    $r->route('/topic/:id/comment')->to('message#create')->name('add_message');
    $r->route('/message/:id/edit')->to('message#edit')->name('edit_message');
}

1;
