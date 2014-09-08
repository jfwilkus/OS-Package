use v5.14.0;
use warnings;

package OS::Package::Application;

# ABSTRACT: OS::Package::Application object.
# VERSION

use Moo;
use Types::Standard qw( Str InstanceOf );
use Path::Tiny;

has [qw/name version/] => ( is => 'rw', isa => Str, required => 1 );

has fakeroot => (
    is       => 'rw',
    isa      => InstanceOf ['Path::Tiny'],
    required => 1,
    default  => sub { return Path::Tiny->tempdir }
);

1;

=method name

The name of the application.

=method version

The version of the application.

=method fakeroot

The location on the local file system where build is staged prior to packaging.
