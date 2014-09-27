use v5.14.0;
use warnings;

package OS::Package::CLI;

# ABSTRACT: OS::Package application initialization.
# VERSION

use English qw(-no_match_vars);
use Env qw( $HOME );
use File::Basename;
use Getopt::Long;
use OS::Package::Application;
use OS::Package::Config qw($OSPKG_CONFIG);
use OS::Package::Factory;
use OS::Package::Init;
use OS::Package::Log;
use Path::Tiny;
use Pod::Usage;
use Try::Tiny;

sub run {

    my ( $COMMAND, $APP, %OPT );

    GetOptions( \%OPT, 'build_id|b=s', 'config_dir|c=s', 'pkg_dir|p=s' );

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

    if ( defined $OPT{config_dir} ) {
        $OSPKG_CONFIG->dir->configs( $OPT{config_dir} );
    }

    if ( defined $OPT{pkg_dir} ) {
        $OSPKG_CONFIG->dir->packages( $OPT{pkg_dir} );
    }

    if ( $COMMAND eq 'init' ) {
        init_ospkg;
        exit;
    }

    if ( !path( $OSPKG_CONFIG->dir->base )->exists ) {
        $LOGGER->fatal('has ospkg been initialized?');
        exit 2;
    }

    if ( !defined $APP ) {
        $LOGGER->warn('missing app');
        exit;
    }

    my $app = { name => $APP };

    $LOGGER = Log::Log4perl->get_logger( $app->{name} );

    if ( defined $OPT{build_id} ) {
        $app->{build_id} = $OPT{build_id};
    }

    my $pkg = vivify($app);

    $LOGGER->info( sprintf 'processing: %s %s', $pkg->name, $pkg->version );

    if ( $COMMAND eq 'download' ) {
        $pkg->artifact->download;

    }
    elsif ( $COMMAND eq 'extract' ) {
        $pkg->artifact->extract;
    }
    elsif ( $COMMAND eq 'build' ) {

        if ( defined $pkg->artifact ) {

            $pkg->artifact->download
                || ( $LOGGER->fatal('download failed') && die );

            $pkg->artifact->extract
                || ( $LOGGER->fatal('extract failed') && die );
        }

        $pkg->build || ( $LOGGER->fatal('build failed') && die );

        $pkg->prune || ( $LOGGER->fatal('prune failed') && die );

        $pkg->create || ( $LOGGER->fatal('create failed') && die );
    }
    elsif ( $COMMAND eq 'prune' ) {

        $pkg->application->prune;

    }
    elsif ( $COMMAND eq 'clean' ) {

        $pkg->clean;

    }

}

1;

=method run

Processes command line arguments and runs the application.
