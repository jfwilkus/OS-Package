use v5.14.0;
use warnings;

package OS::Package::Application;

# ABSTRACT: OS::Package::Application object.
# VERSION

use Moo;
use Types::Standard qw( Str InstanceOf );
use OS::Package::Config;

with qw( OS::Package::Application::Role::Configure );

has config  => ( is => 'rw', isa => Str );
has name    => ( is => 'rw', isa => Str, required => 1 );
has version => ( is => 'rw', isa => Str, required => 1 );
has workdir => ( is => 'rw', isa => Str );
has artifact => ( is => 'rw', isa => InstanceOf ['OS::Package::Artifact'] );

1;

=method name

The name of the application.

