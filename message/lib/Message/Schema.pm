package Message::Schema;
use base qw/DBIx::Class::Schema/;

use Mojo::Home;

our $VERSION = 0.001;

__PACKAGE__->load_namespaces;
__PACKAGE__->load_components(qw/Schema::Versioned/);

my $home = Mojo::Home->new;
$home->detect;

__PACKAGE__->upgrade_directory($home->path(qw/.. db migrations/));

1;
