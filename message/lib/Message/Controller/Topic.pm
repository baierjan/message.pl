package Message::Controller::Topic;
use Mojo::Base qw/Mojolicious::Controller/;

sub show {
    my $self = shift;

    my $id = $self->param('id');
    my $topic = $self->app->db->resultset('Topic')->find($id);
    return $self->render(text => "No such topic", status => 404) unless $topic;

    my $messages = $topic->search_related_rs('messages', {}, { order_by => 'created_at desc' });
    return $self->render(topic => $topic, messages => $messages);
}

sub bookmarks {
    my $self = shift;

    my $bookmarks = $self->current_user->bookmarks;
    return $self->render(bookmarks => $bookmarks);
}

1;
