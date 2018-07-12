package Message::Schema::Result::Bookmark;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('bookmark');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_nullable => 0,
        is_auto_increment => 1,
    },
    author_id => {
        data_type => 'integer',
        is_nullable => 0,
    },
    message_id => {
        data_type => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('author', 'Message::Schema::Result::Author', 'author_id');
__PACKAGE__->belongs_to('message', 'Message::Schema::Result::Message', 'message_id');

1;
