package Message::Command::dump_schema;
use Mojo::Base qw/Mojolicious::Command/;

use Mojo::Home;
use Message::Schema;
use SQL::Translator;

has description => 'Dump database schema';
has usage => sub { shift->extract_usage };

sub run {
    my ($self, @args) = @_;

    my $home = Mojo::Home->new;
    $home->detect;

    my $translator;

    $translator = SQL::Translator->new(
        from => 'DBI',
        parser_args => {
            dsn => $self->app->config->{db}->{dsn},
            db_user => $self->app->config->{db}->{user},
            db_password => $self->app->config->{db}->{pass},
        },
        to => 'Diagram',
        producer_args => {
            out_file => $home->new(qw/.. db current_schema.png/),
            add_color => 1,
        },
    );
    $translator->filters(
        sub {
            my $schema = shift;
            $schema->drop_table('dbix_class_schema_versions');
        },
    );
    $translator->translate or die $translator->error;
    my $output = $translator->translate(to => 'MySQL') or die $translator->error;

    my $handle = $home->new(qw/.. db current_schema.sql/)->open('>:encoding(UTF-8)');
    print $handle $output;
    $handle->close;
}

1;

=head1 SYNOPSIS

    Usage: APPLICATION dump_schema

=cut
