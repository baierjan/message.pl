package Message::Helper;
use Mojo::Base qw/Mojolicious::Plugin/;

use Mojo::ByteStream;

sub register {
    my ($self, $app) = @_;

    $app->helper(render_topic_tree => sub {
            my ($self, $root) = @_;
            my $tree = parse_tree($self, $root);
            return ($tree ?
                $self->tag('div', class => 'card border-dark', Mojo::ByteStream->new(
                        #$self->tag('h5', class => 'card-header', Mojo::ByteStream->new('Téma: '.$root->name)).
                        $self->tag('div', class => 'card-body', Mojo::ByteStream->new(
                                $self->tag('h6', 'Podtémata:').
                                $tree)))) : "");
        });

    $app->helper(render_parents => sub {
            my ($self, $root) = @_;

            my $stream = Mojo::ByteStream->new;
            my $node = $root;
            while ($root->id != 1 && ($node = $node->parent)) {
                $$stream = $self->tag('li', class => 'breadcrumb-item', $self->link_to(
                        $node->name,
                        $self->url_for('topicid', id => $node->id)
                    )).$$stream;
                last if $node->id == 1;
            }
            $$stream .= $self->tag('li', class => 'breadcrumb-item active', 'aria-current' => 'page', $root->name);
            return $self->tag('ol', class => 'breadcrumb flex-grow-1 rounded-left', style => 'border-radius: 0px', $stream);
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
        next if $child->id == 1;
        my $value = Mojo::ByteStream->new($self->tag('a', href => $self->url_for('topicid', id => $child->id), $child->name));
        $$value .= parse_tree($self, $child);
        $$stream .= $self->tag('li', $value);
        $render = 1;
    }
    if ($render) {
        return Mojo::ByteStream->new(
            $self->tag('ul', class => 'mb-0', $stream)
        );
    }
    else {
        return "";
    }
}


1;
