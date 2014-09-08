use v5.14.0;
use warnings;

package OS::Package::Application;

# ABSTRACT: OS::Package::Application object.
# VERSION

use Moo;
use Types::Standard qw( Str InstanceOf );

has [qw/name version/] => ( is => 'rw', isa => Str, required => 1 );

1;

=method name

The name of the application.

=method version

The version of the application.

=method fakeroot

The location on the local file system where build is staged prior to packaging.
