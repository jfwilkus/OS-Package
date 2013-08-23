use v5.14.0;
use warnings;

package OS::Package::Application;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo;
use Types::Standard qw( Str Object );
use OS::Package::Config;

with qw(
    OS::Package::Application::Role::Download
    OS::Package::Application::Role::Extract
);

has name => ( is => 'rw', isa => Str, required => 1 );

has url => ( is => 'rw', isa => Str );

has distfile => ( is => 'rw', isa => Str );

has artifact => ( is => 'rw', isa => Str );

has repository => ( is => 'rw', isa => Str );

has archive => ( is => 'rw', isa => Object );

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

The Archive::Tar::Wrapper object of the extracted distfile.
