use v5.14.0;
use warnings;

package OS::Package;

# ABSTRACT: OS::Package application initialization.
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
        $app->artifact->download;

    }
    elsif ( $COMMAND eq 'extract' ) {
        $app->artifact->extract;
    }
    elsif ( $COMMAND eq 'build' ) {
        $app->artifact->download;
        $app->artifact->extract;
    }
    elsif ( $COMMAND eq 'clean' ) {
        $app->artifact->clean;
    }

}

1;

=method run

Processes command line arguments and runs the application.
