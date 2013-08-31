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
has savefile   => ( is => 'rw', isa => Str );
has repository => ( is => 'rw', isa => Str );
has url        => ( is => 'rw', isa => Str );
has md5        => ( is => 'rw', isa => Str );
has sha1       => ( is => 'rw', isa => Str );
has archive    => ( is => 'rw', isa => InstanceOf ['Archive::Extract'] );

1;
