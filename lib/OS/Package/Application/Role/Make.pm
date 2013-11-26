use v5.14.0;
use warnings;

package OS::Package::Application::Role::Make;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use OS::Package::Log;
use IPC::Cmd qw( can_run run );
use Env qw( CC );
use File::Path qw( remove_tree );
use Try::Tiny;
use Role::Tiny;

sub make {

    my $self = shift;

    if ( !defined $self->workdir ) {
        $LOGGER->warn('cannot find workdir');
        return;
    }

    if ( -d $self->artifact->archive->extract_path ) {

        $LOGGER->info( sprintf 'make application: %s', $self->name );

        chdir $self->artifact->archive->extract_path;

        my $cmd = can_run('make');

        my @command = ($cmd);

        my ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf )
            = run( command => \@command );

        if ( !$success ) {

            $LOGGER->fatal( sprintf 'make failed: %s: %s',
                $error_message, join "\n", @{$stderr_buf} );
            return;

        }

        map { $LOGGER->debug($_) } @{$full_buf};

    }

    return;
}

sub make_install {

    my $self = shift;

    if ( !defined $self->workdir ) {
        $LOGGER->warn('cannot find workdir');
        return;
    }

    if ( -d $self->fakeroot ) {
        remove_tree $self->fakeroot;
    }


    if ( -d $self->artifact->archive->extract_path ) {

        $LOGGER->info( sprintf 'make install application: %s', $self->name );

        chdir $self->artifact->archive->extract_path;

        my $cmd = can_run('make');

        my @command =
            ( $cmd, 'install', sprintf( 'DESTDIR=%s', $self->fakeroot ) );

        my ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf )
            = run( command => \@command );

        if ( !$success ) {

            $LOGGER->fatal( sprintf 'make install failed: %s: %s',
                $error_message, join "\n", @{$stderr_buf} );
            return;

        }

        map { $LOGGER->debug($_) } @{$full_buf};

    }

    return;
}

1;
