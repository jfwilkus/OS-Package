use v5.14.0;
use warnings;

package OS::Package::Role::Build;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use OS::Package::Log;
use File::Basename qw( basename dirname );
use File::Path qw( make_path );
use IPC::Cmd qw( can_run run );
use Env qw( $CC $HOME );
use File::Temp;
use Try::Tiny;
use Role::Tiny;
use Path::Tiny;
use Template;

sub build {
    my $self = shift;

    my $template = Path::Tiny->tempfile;

    my $temp_sh = sprintf '%s/install.sh', $self->artifact->workdir;

    my $vars = {
        FAKEROOT => $self->application->fakeroot,
        WORKDIR  => $self->artifact->workdir,
        PREFIX   => $self->prefix
    };

    if ( defined $self->install ) {
        $template->spew( $self->install );
    }
    else {
        return 1;
    }

    if ( ! -d $self->application->fakeroot ) {
        make_path $self->application->fakeroot;
    }

    my $tt = Template->new( { INCLUDE_PATH => dirname($template) } );

    $tt->process( basename( $template->absolute ), $vars, $temp_sh );

    my $command = [ can_run('bash'), '-e', $temp_sh ];

    $LOGGER->info( sprintf 'building: %s', $self->name );

    if ( defined $self->artifact ) {
        chdir $self->artifact->archive->extract_path;
    }

    my ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf ) =
        run( command => $command );

    if ( !$success ) {
        $LOGGER->error( sprintf "install script failed: %s\n",
            $error_message );

        foreach ( @{$full_buf} ) {
            $LOGGER->error($_);
        }
        return 2;
    }

    chdir $HOME;

    return 1;
}

=method build

Provides method to build the application.
