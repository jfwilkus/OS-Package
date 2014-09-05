use v5.14.0;
use warnings;

package OS::Package::Plugin::Role::Package;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo::Role;
use Types::Standard qw( Str );

has 'name' => ( is => 'rw', isa => Str, required => 1 );

1;
