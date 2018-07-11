package Message::Schema::Result::Label;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('label');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_nullable => 0,
        is_auto_increment => 1,
    },
    name => {
        data_type => 'varchar',
        size => 256,
        is_nullable => 0,
    },
    parent_id => {
        data_type => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many('messages', 'Message::Schema::Result::Message', 'label_id');
__PACKAGE__->has_many('childrens', 'Message::Schema::Result::Label', 'parent_id');
__PACKAGE__->belongs_to('parent', 'Message::Schema::Result::Label', 'parent_id');

1;
