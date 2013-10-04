use v5.14.0;
use warnings;

package OS::Package::Application::Factory;

# ABSTRACT: Initialize a OS::Package::Application object.
# VERSION

use Env qw( $HOME );
use File::Basename;
use OS::Package::Application;
use OS::Package::Artifact;
use OS::Package::Config;
use OS::Package::Log;
use YAML::Any qw( LoadFile );

use base qw(Exporter);

our @EXPORT = qw( vivify );

local $YAML::UseCode  = 0 if !defined $YAML::UseCode;
local $YAML::LoadCode = 0 if !defined $YAML::LoadCode;

sub vivify {

    my $name = shift;

    my $cfg_file = sprintf '%s/%s/%s.yml', $HOME, $CONFIG->dir->configs,
        lc($name);

    if ( !-f $cfg_file ) {
        $LOGGER->logcroak( sprintf 'cannot file configuration file %s for %s',
            $cfg_file, $name );
    }

    my $config = LoadFile($cfg_file);

    my $app = OS::Package::Application->new( name => $name, version => $config->{version} );

    my $repository = sprintf( '%s/%s', $HOME, $CONFIG->dir->repository );

    $app->workdir( sprintf '%s/%s', $HOME, $CONFIG->dir->work );

    my $artifact = OS::Package::Artifact->new(
        distfile   => basename( $config->{url} ),
        url        => $config->{url},
        repository => $repository,
        workdir    => $app->workdir,
    );

    if ( defined $config->{md5} ) {
        $artifact->md5( $config->{md5} );
    }

    if ( defined $config->{sha1} ) {
        $artifact->sha1( $config->{sha1} );
    }

    $artifact->savefile(
        sprintf( '%s/%s', $repository, basename( $config->{url} ) ) );

    $app->artifact($artifact);

    return $app;
}

1;

=method vivify

Attempts to find the application configuration file and returns an OS::Package::Application object.
