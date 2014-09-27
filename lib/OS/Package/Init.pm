use v5.14.0;
use warnings;

package OS::Package::Init;

# ABSTRACT: Initializes ospkg
# VERSION

use base qw(Exporter);
use Path::Tiny;
use OS::Package::Config qw($OSPKG_CONFIG);
use OS::Package::Log qw($LOGGER);

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

    return 1;
}

1;

=method init_ospkg

Initializes ospkg.
