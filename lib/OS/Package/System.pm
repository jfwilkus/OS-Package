use v5.14.0;
use warnings;

package OS::Package::System;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo;
use Types::Standard qw( Str Enum );

has [qw/os type/] => ( is => 'rw', isa => Str, required => 1 );

has 'bits' => ( is => 'rw', isa => Enum[qw[ 32 64]], required => 1 );

1;

=method os

=method type

=method bits
