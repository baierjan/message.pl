package Message::Schema::Result::Topic;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('topic');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_nullable => 0,
        is_auto_increment => 1,
    },
    name => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0,
    },
    parent_id => {
        data_type => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many('messages', 'Message::Schema::Result::Message', 'topic_id');
__PACKAGE__->has_many('children', 'Message::Schema::Result::Topic', 'parent_id');
__PACKAGE__->belongs_to('parent', 'Message::Schema::Result::Topic', 'parent_id');

1;
