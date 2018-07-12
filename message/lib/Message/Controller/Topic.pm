package Message::Controller::Topic;
use Mojo::Base qw/Mojolicious::Controller/;

sub show {
    my $self = shift;

    my $id = $self->param('id');
    my $root = $self->app->db->resultset('Topic')->find($id);
    return $self->render(text => "No such topic", status => 404) unless $root;

    $self->render(topic => $root);
}

1;
