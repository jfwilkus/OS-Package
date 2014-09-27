use v5.14.0;
use warnings;

package OS::Package::Log;

use File::ShareDir qw(dist_file);
use base qw(Exporter);
use Log::Log4perl;

# ABSTRACT: Load OS::Package LOGGER object.
# VERSION

our @EXPORT = qw( $LOGGER );

Log::Log4perl::init_once( dist_file( 'OS-Package', 'log.conf' ) );

our $LOGGER = Log::Log4perl->get_logger('ospkg');

1;
