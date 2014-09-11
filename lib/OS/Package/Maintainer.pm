use v5.14.0;
use warnings;

package OS::Package::Maintainer;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo;
use Types::Standard qw( Str Enum );

has author => ( is => 'rw', isa => Str, required => 1 );

has company => (
    is      => 'rw',
    isa     => Str,
    default => sub { my $self = shift; return $self->author }
);

has [qw/nickname email phone/] => ( is => 'rw', isa => Str );

sub by_line {
    my $self = shift;

    my $by_line = $self->author;

    if ( defined $self->nickname ) {
        $by_line .= sprintf ' (%s)', $self->nickname;
    }

    if ( defined $self->email ) {
        $by_line .= sprintf ' <%s>', $self->email;
    }

    return $by_line;

}

1;

=method by_line

Returns string "Author (nickname) <email>".
