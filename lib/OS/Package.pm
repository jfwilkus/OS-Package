use v5.14.0;
use warnings;

package OS::Package;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Env qw( $HOME );
use File::Basename;
use OS::Package::Application;
use OS::Package::Config;
use OS::Package::Application::Factory;
use OS::Package::Log;
use Try::Tiny;

sub run {

    my ( $COMMAND, $APP );

    $COMMAND = shift @ARGV;
    $APP     = shift @ARGV;

    if ( !defined $COMMAND ) {
        $LOGGER->warn('please tell me what to do');
        exit;
    }

    if ( !defined $APP ) {
        $LOGGER->warn('missing app');
        exit;
    }

    my $app = vivify($APP);

    if ( $COMMAND eq 'download' ) {
        $app->download;

    }
    elsif ( $COMMAND eq 'extract' ) {
        $app->extract;
    }
    elsif ( $COMMAND eq 'build' ) {
        $app->download;
        $app->extract;
    }
    elsif ( $COMMAND eq 'clean' ) {
        $app->clean;
    }

}

1;
