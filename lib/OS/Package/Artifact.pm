use v5.14.0;
use warnings;

package OS::Package::Artifact;

# ABSTRACT: OS::Package::Artifact object.
# VERSION

use Moo;
use Types::Standard qw( Str InstanceOf );
use OS::Package::Config;

with qw(
    OS::Package::Artifact::Role::Download
    OS::Package::Artifact::Role::Extract
    OS::Package::Artifact::Role::Clean
    OS::Package::Artifact::Role::Validate
);

has distfile   => ( is => 'rw', isa => Str );
has savefile   => ( is => 'rw', isa => Str );
has repository => ( is => 'rw', isa => Str );
has url        => ( is => 'rw', isa => Str );
has md5        => ( is => 'rw', isa => Str );
has sha1       => ( is => 'rw', isa => Str );
has archive    => ( is => 'rw', isa => InstanceOf ['Archive::Extract'] );
has workdir    => ( is => 'rw', isa => Str );

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
