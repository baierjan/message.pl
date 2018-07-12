package Message::Schema::Result::Author;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('author');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_nullable => 0,
        is_auto_increment => 1,
    },
    nick => {
        data_type => 'varchar',
        size => 64,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many('messages', 'Message::Schema::Result::Message', 'author_id');
__PACKAGE__->has_many('bookmarks', 'Message::Schema::Result::Bookmark', 'author_id');

1;
