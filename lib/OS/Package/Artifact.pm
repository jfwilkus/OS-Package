use v5.14.0;
use warnings;

package OS::Package::Artifact;

# ABSTRACT: OS::Package::Artifact object.
# VERSION

use Moo;
use Types::Standard qw( Str InstanceOf );
use Path::Tiny;

with qw(
    OS::Package::Artifact::Role::Download
    OS::Package::Artifact::Role::Extract
    OS::Package::Artifact::Role::Validate
);

my @string_methods = qw( distfile savefile repository url md5 sha1 );

has [@string_methods] => ( is => 'rw', isa => Str );

has archive => ( is => 'rw', isa => InstanceOf ['Archive::Extract'] );

has workdir => (
    is       => 'rw',
    isa      => InstanceOf ['Path::Tiny'],
    required => 1,
    default  => sub { return Path::Tiny->tempdir }
);

1;

=method url

The URL to download the application.

=method distfile

The name of the distribution file.

=method savefile

The location of the distribution file on local filesystem.

=method repository

Base directory to store artifacts.

=method archive

The Archive::Extract object of the extracted distfile.

=method workdir

Temporary directory to extract and stage artifact.

