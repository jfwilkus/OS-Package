use v5.14.0;
use warnings;

package OS::Package;

# ABSTRACT: OS::Package Object
# VERSION

use Moo;
use OS::Package::System;
use Types::Standard qw( Str ArrayRef InstanceOf );

with qw(
    OS::Package::Role::Clean
    OS::Package::Role::Build
    OS::Package::Role::Prune
);

has [qw/name description prefix version/] =>
    ( is => 'rw', isa => Str, required => 1 );

has [qw/config install/] => ( is => 'rw', isa => Str );

has [qw/prune_dirs prune_files/] => ( is => 'rw', isa => ArrayRef );

has artifact => ( is => 'rw', isa => InstanceOf ['OS::Package::Artifact'] );

has application => (
    is       => 'rw',
    isa      => InstanceOf ['OS::Package::Application'],
    required => 1
);

has system => (
    is       => 'rw',
    isa      => InstanceOf ['OS::Package::System'],
    default  => sub { return OS::Package::System->new; },
    required => 1
);

has maintainer => (
    is       => 'rw',
    isa      => InstanceOf ['OS::Package::Maintainer'],
    required => 1
);

1;
