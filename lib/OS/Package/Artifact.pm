use v5.14.0;
use warnings;

package OS::Package::Artifact;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo;
use Types::Standard qw( Str InstanceOf );
use OS::Package::Config;

with qw(
    OS::Package::Artifact::Role::Download
    OS::Package::Artifact::Role::Extract
    OS::Package::Artifact::Role::Clean
);

has distfile   => ( is => 'rw', isa => Str );
has url        => ( is => 'rw', isa => Str );

1;
