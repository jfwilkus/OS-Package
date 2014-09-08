use v5.14.0;
use warnings;

package OS::Package::Role::Prune;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use OS::Package::Log;
use File::Path qw( make_path remove_tree );
use Try::Tiny;
use Role::Tiny;

sub prune {

    my $self = shift;

    if ( !defined $self->application->fakeroot ) {
        $LOGGER->warn('fakeroot is not defined');
        return;
    }

    if ( !-d $self->application->fakeroot ) {
        $LOGGER->warn('fakeroot does not exist');
        return 1;
    }

    if ( defined $self->prune_files ) {

        $LOGGER->info( sprintf 'prune files: %s', $self->name );

        foreach my $file ( @{ $self->prune_files } ) {

            my $pfile =
                sprintf( '%s/%s/%s', $self->application->fakeroot, $self->prefix, $file );
            $LOGGER->debug( sprintf 'removing file: %s', $pfile );

            unlink $pfile;
        }
    }

    if ( defined $self->prune_dirs ) {

        $LOGGER->info( sprintf 'prune directories: %s', $self->name );

        foreach my $dir ( @{ $self->prune_dirs } ) {

            my $pdir =
                sprintf( '%s/%s/%s', $self->application->fakeroot, $self->prefix, $dir );
            $LOGGER->debug( sprintf 'removing directory: %s', $pdir );

            remove_tree $pdir;
        }
    }

    return 1;
}

1;
