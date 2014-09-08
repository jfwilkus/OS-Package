use v5.14.0;
use warnings;

package OS::Package::Factory;

# ABSTRACT: Initialize an OS::Package object.
# VERSION

use Config;
use Env qw( $HOME );
use File::Basename;
use Module::Load;
use OS::Package;
use OS::Package::Application;
use OS::Package::Artifact;
use OS::Package::Config qw( $OSPKG_CONFIG );
use OS::Package::Log qw( $LOGGER );
use OS::Package::Maintainer;
use OS::Package::System;
use YAML::Any qw( LoadFile );

use base qw(Exporter);

our @EXPORT = qw( vivify );

local $YAML::UseCode  = 0 if !defined $YAML::UseCode;
local $YAML::LoadCode = 0 if !defined $YAML::LoadCode;

sub vivify {

    my $name = shift;

    my $cfg_file = sprintf '%s/%s/%s.yml', $HOME, $OSPKG_CONFIG->dir->configs,
        lc($name);

    if ( !-f $cfg_file ) {
        $LOGGER->logcroak( sprintf 'cannot find configuration file %s for %s',
            $cfg_file, $name );
    }

    my $config = LoadFile($cfg_file);

    my $system = OS::Package::System->new;

    my $pkg;

    if ( defined $OSPKG_CONFIG->{plugin}{ $system->os }{ $system->version } )
    {
        my $plugin =
            $OSPKG_CONFIG->{plugin}{ $system->os }{ $system->version };

        load $plugin;

        my $app = OS::Package::Application->new(
            name    => $config->{name},
            version => $config->{version}
        );

        my $maintainer =
            OS::Package::Maintainer->new(
            author => $config->{maintainer}{author} );

        foreach my $method (qw( nickname email phone company )) {
            if ( defined $config->{maintainer}{$method} ) {
                $maintainer->$method( $config->{maintainer}{$method} );
            }
        }

        $pkg = $plugin->new(
            name        => $config->{name},
            version     => $config->{version},
            prefix      => $config->{prefix},
            description => $config->{description},
            maintainer  => $maintainer,
            application => $app
        );

    }
    else {
        $LOGGER->logcroak(
            sprintf 'cannot find plugin for %s %s',
            ucfirst( $system->os ),
            $system->version
        );
        return;
    }

    my $repository =
        sprintf( '%s/%s', $HOME, $OSPKG_CONFIG->dir->repository );

    if ( defined $config->{build} ) {
        $pkg->install( $config->{build} );
    }

    if ( defined $config->{prune}{directories} ) {
        $pkg->prune_dirs( $config->{prune}{directories} );
    }

    if ( defined $config->{prune}{files} ) {
        $pkg->prune_files( $config->{prune}{files} );
    }

    if ( !defined $config->{url} ) {
        return $pkg;
    }

    my $artifact = OS::Package::Artifact->new(
        distfile   => basename( $config->{url} ),
        url        => $config->{url},
        repository => $repository,
    );

    if ( defined $config->{md5} ) {
        $artifact->md5( $config->{md5} );
    }

    if ( defined $config->{sha1} ) {
        $artifact->sha1( $config->{sha1} );
    }

    $artifact->savefile(
        sprintf( '%s/%s', $repository, basename( $config->{url} ) ) );

    $pkg->artifact($artifact);

    return $pkg;
}

1;

=method vivify

Attempts to find the application configuration file and returns an OS::Package::Application object.
