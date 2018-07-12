package Message::Command::seed_db;
use Mojo::Base qw/Mojolicious::Command/;

use Mojo::Home;
use DateTime;
use Message::Schema;
use SQL::Translator;

has description => 'Seed database';
has usage => sub { shift->extract_usage };

sub run {
    my ($self, @args) = @_;

    my $schema = $self->app->db;
    $schema->resultset('Topic')->delete_all;
    $schema->resultset('Topic')->create({
            id => 1,
            name => 'Root',
            parent_id => 1,
        });
    $schema->resultset('Topic')->create({
            id => 2,
            name => '9. ročník',
            parent_id => 1,
        });
    $schema->resultset('Topic')->create({
            id => 3,
            name => 'Offtopic',
            parent_id => 2,
        });
    $schema->resultset('Topic')->create({
            id => 4,
            name => 'Tábor',
            parent_id => 2,
        });
    $schema->resultset('Topic')->create({
            id => 5,
            name => '8. ročník',
            parent_id => 1,
        });
    $schema->resultset('Author')->delete_all;
    $schema->resultset('Author')->create({
            id => 1,
            nick => 'user',
        });
    $schema->resultset('Message')->delete_all;
    $schema->resultset('Message')->create({
            topic_id => 3,
            author_id => 1,
            text => 'Lorem *ipsum* dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut **enim ad minim** veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            created_at => DateTime->now->subtract(days => 10),
        });
    $schema->resultset('Message')->create({
            topic_id => 3,
            author_id => 1,
            text => 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?',
        });
    $schema->resultset('Message')->create({
            topic_id => 5,
            author_id => 1,
            text => 'Lorem',
        });
    $schema->resultset('Message')->create({
            topic_id => 2,
            author_id => 1,
            text => 'Lorem ipsum',
        });
}

1;

=head1 SYNOPSIS

    Usage: APPLICATION seed_db

=cut
