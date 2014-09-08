use v5.14.0;
use warnings;

package OS::Package::System;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo;
use Types::Standard qw( Str Enum );
use Config;
use POSIX qw( uname );

has 'os' => (
    is       => 'rw',
    isa      => Str,
    default  => sub { return $Config{osname} },
    required => 1
);

has 'version' => (
    is       => 'rw',
    isa      => Str,
    default  => sub { my @uname = uname(); return $uname[2] },
    required => 1
);

has 'type' => (
    is       => 'rw',
    isa      => Str,
    default  => sub { my @uname = uname(); return $uname[4] },
    required => 1
);

#has 'bits' => ( is => 'rw', isa => Enum[qw[ 32 64 ]], required => 1 );

1;

=method os

Host operating system

=method type

=method bits
