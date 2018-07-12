package Message::Command::create_migration;
use Mojo::Base qw/Mojolicious::Command/;

use Mojo::Home;
use Message::Schema;

has description => 'Create database migrations';
has usage => sub { shift->extract_usage };

sub run {
    my ($self, @args) = @_;
    my $prev = shift @args;

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
    my $current_version = $schema->schema_version;
    $schema->create_ddl_dir('MySQL', $current_version, $home->path(qw/db migrations/), $prev);
}

1;

=head1 SYNOPSIS

    Usage: APPLICATION create_migration

=cut
