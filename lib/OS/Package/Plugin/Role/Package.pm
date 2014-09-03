use v5.14.0;
use warnings;

package OS::Package::Plugin::Role::Package;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo::Role;
use Types::Standard qw( Str Int );

has 'name' => ( is => 'rw', isa => Str, required => 1 );
has 'architecture' => ( is => 'rw', isa => Str, required => 1 );
has 'bitness' => ( is => 'rw', isa => Int, required => 1 );

1;
