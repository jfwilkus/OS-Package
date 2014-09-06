use v5.14.0;
use warnings;

package OS::Package;

# ABSTRACT: OS::Package Object
# VERSION

use Moo;
use Types::Standard qw( Str );

has [qw( name description )] => ( is => 'rw', isa => Str, required => 1 );

1;
