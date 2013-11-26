use v5.14.0;
use warnings;

package OS::Package::Application::Role::Prune;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use OS::Package::Log;
use File::Path qw( make_path remove_tree );
use Try::Tiny;
use Role::Tiny;

sub prune {

    my $self = shift;

    if ( !defined $self->fakeroot ) {
        $LOGGER->warn('fakeroot is not defined');
        return;
    }

    if ( -d $self->fakeroot ) {

        $LOGGER->info( sprintf 'prune directories: %s', $self->name );

        foreach my $dir ( @{ $self->prune_dirs } ) {

            my $pdir = sprintf( '%s/%s', $self->fakeroot, $dir );
            $LOGGER->debug( sprintf 'removing directory: %s', $pdir );

            remove_tree $pdir;
        }

        $LOGGER->info( sprintf 'prune files: %s', $self->name );

        foreach my $file ( @{ $self->prune_files } ) {

            my $pfile = sprintf( '%s/%s', $self->fakeroot, $file );
            $LOGGER->debug( sprintf 'removing file: %s', $pfile );

            unlink $pfile;
        }

    }

    return;
}

1;
