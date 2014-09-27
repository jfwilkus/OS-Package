use v5.14.0;
use warnings;

package OS::Package::Init;

# ABSTRACT: Initializes ospkg
# VERSION

use base qw(Exporter);
use Path::Tiny;
use OS::Package::Config qw($OSPKG_CONFIG);
use OS::Package::Log qw($LOGGER);
use YAML::Any qw( DumpFile );

our @EXPORT = qw( init_ospkg );

sub init_ospkg {
    my ($opts) = @_;

    my @dirs = (
        $OSPKG_CONFIG->dir->base,    $OSPKG_CONFIG->dir->repository,
        $OSPKG_CONFIG->dir->configs, $OSPKG_CONFIG->dir->packages
    );

    foreach my $dir (@dirs) {

        if ( !path($dir)->exists ) {
            $LOGGER->info( sprintf 'creating directory: %s', $dir );
            path($dir)->mkpath;
        }
    }

    my $user_config = {
        config_dir => path($OSPKG_CONFIG->dir->configs)->stringify,
        pkg_dir    => path($OSPKG_CONFIG->dir->packages)->stringify,
    };

    DumpFile( path( $OSPKG_CONFIG->user_config ), $user_config );

    return 1;
}

1;

=method init_ospkg

Initializes ospkg.
