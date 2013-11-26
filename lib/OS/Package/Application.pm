use v5.14.0;
use warnings;

package OS::Package::Application;

# ABSTRACT: OS::Package::Application object.
# VERSION

use Moo;
use Types::Standard qw( Str InstanceOf ArrayRef );
use OS::Package::Config;

with qw(
    OS::Package::Application::Role::Configure
    OS::Package::Application::Role::Make
    OS::Package::Application::Role::Prune
    OS::Package::Application::Role::Clean
);

has config   => ( is => 'rw', isa => Str );
has name     => ( is => 'rw', isa => Str, required => 1 );
has version  => ( is => 'rw', isa => Str, required => 1 );
has workdir  => ( is => 'rw', isa => Str );
has fakeroot => ( is => 'rw', isa => Str );
has artifact => ( is => 'rw', isa => InstanceOf ['OS::Package::Artifact'] );
has configure_args => ( is => 'rw', isa => ArrayRef );
has prune_dirs     => ( is => 'rw', isa => ArrayRef );
has prune_files     => ( is => 'rw', isa => ArrayRef );

1;

=method name

The name of the application.

