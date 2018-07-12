package Message::Helper;
use Mojo::Base qw/Mojolicious::Plugin/;

use Mojo::ByteStream;

sub register {
    my ($self, $app) = @_;

    $app->helper(render_topic_tree => sub {
            my ($self, $root) = @_;
            return parse_tree($self, $root);
        });

    $app->helper(markdown => sub {
            my ($self, $text) = @_;
            use Text::Markdown;
            my $md = Text::Markdown->new;
            return Mojo::ByteStream->new($md->markdown($text));
        });
}

sub parse_tree {
    my ($self, $root) = @_;

    my $stream = Mojo::ByteStream->new;
    my $children = $root->search_related_rs('children', {}, { order_by => 'name' });
    my $render = 0;
    while (my $child = $children->next) {
        next if $child->id eq 1;
        my $value = Mojo::ByteStream->new($self->tag('a', href => $self->url_for('topicid', id => $child->id), $child->name));
        $$value .= parse_tree($self, $child);
        $$stream .= $self->tag('li', $value);
        $render = 1;
    }
    return $render ? $self->tag('ul', $stream) : "";
}


1;
