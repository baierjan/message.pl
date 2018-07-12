package Message::Controller::Message;
use Mojo::Base qw/Mojolicious::Controller/;

sub create {
    my $self = shift;

    my $topic_id = $self->param('id');
    return $self->render(text => "No such topic id", status => 404) unless $topic_id;

    my $topic = $self->app->db->resultset('Topic')->find($topic_id);
    return $self->render(text => "No such topic", status => 404) unless $topic;

    my $form = $self->validation;
    return $self->render(topic => $topic, message => undef) unless $form->has_data;

    $form->required('text', 'trim');
    return $self->render(topic => $topic, message => undef) if $form->has_error;

    return $self->render(text => "Bad CSRF token", status => 403)
        if $form->csrf_protect->has_error('csrf_token');

    my $message = $self->app->db->resultset('Message')->new({
            topic_id => $topic_id,
            author_id => 1,
            text => $form->param('text'),
        });
    $message->insert;
    return $self->redirect_to('topicid', id => $topic_id);
}

sub edit {
    my $self = shift;

    my $message_id = $self->param('id');
    return $self->render(text => "No such message id", status => 404) unless $message_id;

    my $message = $self->app->db->resultset('Message')->find($message_id);
    return $self->render(text => "No such message", status => 404) unless $message;

    my $topic = $message->topic;

    my $form = $self->validation;
    return $self->render(topic => $topic, message => $message) unless $form->has_data;

    $form->required('text', 'trim');
    return $self->render(topic => $topic, message => $message) if $form->has_error;

    return $self->render(text => "Bad CSRF token", status => 403)
        if $form->csrf_protect->has_error('csrf_token');

    $message->update({
            text => $form->param('text'),
        });

    use Data::Dumper;
    print Dumper($topic);

    return $self->redirect_to('topicid', id => $topic->id);
}

1;
