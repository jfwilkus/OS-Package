use v5.14.0;
use warnings;

package OS::Package::Application;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo;
use Types::Standard qw( Str InstanceOf );
use OS::Package::Config;

has archive => ( is => 'rw', isa => InstanceOf ['Archive::Extract'] );
has artifact   => ( is => 'rw', isa => InstanceOf ['OS::Package::Artifact'] );
has config     => ( is => 'rw', isa => Str );
has name       => ( is => 'rw', isa => Str, required => 1 );
has repository => ( is => 'rw', isa => Str );
has workdir    => ( is => 'rw', isa => Str );

1;

=method name

The name of the application.

=method url

The URL to download the application.

=method distfile

The name of the distribution file.

=method artifact

The location of the distribution file on local filesystem.

=method repository

Base directory to store artifacts.

=method archive

The Archive::Extract object of the extracted distfile.
