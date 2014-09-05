use v5.14.0;
use warnings;

package OS::Package::Application;

# ABSTRACT: OS::Package::Application object.
# VERSION

use Moo;
use Types::Standard qw( Str InstanceOf ArrayRef Object );
use OS::Package::Config;

with qw(
    OS::Package::Application::Role::Build
    OS::Package::Application::Role::Prune
    OS::Package::Application::Role::Clean
);

has [qw/name version prefix/]     => ( is => 'rw', isa => Str, required => 1 );
has [qw/config install workdir fakeroot/] => ( is => 'rw', isa => Str );

has artifact => ( is => 'rw', isa => InstanceOf ['OS::Package::Artifact'] );

has package => ( is => 'rw', isa => Object );

has [qw/prune_dirs prune_files/]  => ( is => 'rw', isa => ArrayRef );

1;

=method name

The name of the application.

