package Message::Schema::Result::Message;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('message');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_nullable => 0,
        is_auto_increment => 1,
    },
    label_id => {
        data_type => 'integer',
        is_nullable => 0,
    },
    author_id => {
        data_type => 'integer',
        is_nullable => 0,
    },
    text => {
        data_type => 'text',
        is_nullable => 0,
    },
    datetime => {
        data_type => 'datetime',
        timezone => 'Europe/Prague',
        locale => 'cs_CZ.UTF-8',
        is_nullable => 0,
        default_value => \'now()',
    },
    useragent => {
        data_type => 'varchar',
        size => 256,
        is_nullable => 0,
    },
    client_ip => {
        data_type => 'varchar',
        size => 64,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('author', 'Message::Schema::Result::Author', 'author_id');
__PACKAGE__->belongs_to('label', 'Message::Schema::Result::Label', 'label_id');

1;
