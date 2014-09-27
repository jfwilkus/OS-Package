use v5.14.0;
use warnings;

package OS::Package::Init;

# ABSTRACT: Initializes ospkg
# VERSION

use base qw(Exporter);
use OS::Package::Config qw($OSPKG_CONFIG);
use OS::Package::Log qw($LOGGER);

our @EXPORT = qw( init_ospkg );

sub init_ospkg {
    my ($opts) = @_;

    $LOGGER->info($OSPKG_CONFIG->dir->configs);

    return 1;
}

1;
