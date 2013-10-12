use v5.14.0;
use warnings;

package OS::Package;

# ABSTRACT: OS::Package application initialization.
# VERSION

use English qw(-no_match_vars);
use Env qw( $HOME );
use File::Basename;
use OS::Package::Application;
use OS::Package::Config;
use OS::Package::Application::Factory;
use OS::Package::Log;
use Pod::Usage;
use Try::Tiny;

sub run {

    my ( $COMMAND, $APP );

    $COMMAND = shift @ARGV;
    $APP     = shift @ARGV;

    if ( !defined $COMMAND ) {
        $LOGGER->warn('please tell me what to do');
        exit;
    }

    if ( $COMMAND =~ m{^(help|--help|-h)$} ) {
        pod2usage(
            -exitstatus => '1',
            -message    => 'See --man for full documentation'
        );
    }
    elsif ( $COMMAND =~ m{^(man|--man|-m)$} ) {
        pod2usage( -exitstatus => '0', -verbose => 2 );
    }
    elsif ( $COMMAND =~ m{^(version|--version|-v)$} ) {
        printf "%s %s\n", basename($PROGRAM_NAME), $VERSION;
        exit;
    }

    if ( !defined $APP ) {
        $LOGGER->warn('missing app');
        exit;
    }

    my $app = vivify($APP);

    $LOGGER->info( sprintf 'processing: %s %s', $app->name, $app->version );

    if ( $COMMAND eq 'download' ) {
        $app->artifact->download;

    }
    elsif ( $COMMAND eq 'extract' ) {
        $app->artifact->extract;
    }
    elsif ( $COMMAND eq 'build' ) {
        $app->artifact->download;
        $app->artifact->extract;
        $app->configure;
        $app->make;
        $app->make_install;
        $app->prune;
    }
    elsif ( $COMMAND eq 'clean' ) {
        $app->artifact->clean;
    }

}

1;

=method run

Processes command line arguments and runs the application.
