use v5.14.0;
use warnings;

package OS::Package::Application::Role::Configure;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use OS::Package::Log;
use IPC::Cmd qw( can_run run );
use Env qw( CC );
use Try::Tiny;
use Role::Tiny;

sub configure {

    my $self = shift;

    if ( !defined $self->workdir ) {
        $LOGGER->warn('cannot find workdir');
        return;
    }

    if ( -d $self->artifact->archive->extract_path ) {

        chdir $self->artifact->archive->extract_path;

        my $configure = sprintf '%s/configure',
            $self->artifact->archive->extract_path;

        if ( -x $configure ) {

            $LOGGER->info( sprintf 'configuring application: %s',
                $self->name );

            my $cmd = can_run($configure);

            my @command = ($cmd);

            if ( $self->configure_args ) {

                $LOGGER->debug( sprintf 'configure_args: %s',
                    join( ', ', @{ $self->configure_args } ) );

                push @command, @{ $self->configure_args };
            }

            my ($success,    $error_message, $full_buf,
                $stdout_buf, $stderr_buf
            ) = run( command => \@command );

            if ( !$success ) {

                $LOGGER->fatal( sprintf 'configure failed: %s: %s',
                    $error_message, join "\n", @{$stderr_buf} );
                return;

            }

            map { $LOGGER->debug($_) } @{$full_buf};

        }
        else {
            $LOGGER->warn( sprintf 'cannot execute %s script', $configure );
        }

    }

    return 1;
}

1;

=method configure

Provides method to clean the work directory.
