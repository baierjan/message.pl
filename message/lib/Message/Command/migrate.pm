package Message::Command::migrate;
use Mojo::Base qw/Mojolicious::Command/;

use Message::Schema;

has description => 'Run database migrations';
has usage => sub { shift->extract_usage };

sub run {
    my ($self, @args) = @_;

    my $schema = Message::Schema->connect(
        $self->app->config->{db}->{dsn},
        $self->app->config->{db}->{user},
        $self->app->config->{db}->{pass},
        {
            ignore_version => 1,
        },
    );

    my $home = Mojo::Home->new;
    $home->detect;
    $schema->upgrade_directory($home->path(qw/db migrations/));
    $schema->deploy unless ($schema->get_db_version());
    $schema->upgrade;
}

1;

=head1 SYNOPSIS

    Usage: APPLICATION migrate

=cut
