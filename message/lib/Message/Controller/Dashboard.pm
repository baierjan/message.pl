package Message::Controller::Dashboard;
use Mojo::Base qw/Mojolicious::Controller/;

sub login {
    my $self = shift;

    my $form = $self->validation;
    return $self->render unless $form->has_data;

    $form->required('email');
    $form->required('password');
    return $self->render if $form->has_error;

    $self->authenticate($form->param('email'), $form->param('password')) or do {
        $self->stash(error => 'Špatný e-mail nebo heslo');
        return $self->render;
    };

    return $self->redirect_to('index');
}

1;
