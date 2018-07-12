package Message::Controller::Topic;
use Mojo::Base qw/Mojolicious::Controller/;

sub show {
    my $self = shift;

    my $id = $self->param('id');
    my $topic = $self->app->db->resultset('Topic')->find($id);
    return $self->render(text => "No such topic", status => 404) unless $topic;

    my $messages = $topic->search_related_rs('messages', {}, { order_by => 'created_at desc' });
    $self->render(topic => $topic, messages => $messages);
}

1;
