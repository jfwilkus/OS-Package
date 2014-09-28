use v5.14.0;
use warnings;

package OS::Package::Maintainer;

# ABSTRACT: OS::Package::Maintainer object.
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

    if ( defined $self->phone ) {
        $by_line .= sprintf ' %s', $self->phone;
    }

    return $by_line;

}

1;

=method author

Name of the maintainer (required).

=method nickname

Nickname of the maintainer.

=method email

The email address of the maintainer.

=method phone

Phone number of the maintainer.

=method company

The company of the maintainer.

=method by_line

Returns string "Author (nickname) <email> phone".
