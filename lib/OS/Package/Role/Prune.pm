use v5.14.0;
use warnings;

package OS::Package::Role::Prune;

# ABSTRACT: Provides prune method for OS::Package object.
# VERSION

use OS::Package::Log;
use Path::Tiny;
use Try::Tiny;
use Role::Tiny;

sub prune {

    my $self = shift;

    if ( !defined $self->fakeroot ) {
        $LOGGER->warn('fakeroot is not defined');
        return;
    }

    if ( !-d $self->fakeroot ) {
        $LOGGER->warn('fakeroot does not exist');
        return 1;
    }

    if ( defined $self->prune_files ) {

        $LOGGER->info( sprintf 'prune files: %s', $self->name );

        foreach my $file ( @{ $self->prune_files } ) {

            my $pfile =
                sprintf( '%s/%s/%s', $self->fakeroot, $self->prefix, $file );
            $LOGGER->debug( sprintf 'removing file: %s', $pfile );

            unlink path($pfile)->stringify;
        }
    }

    if ( defined $self->prune_dirs ) {

        $LOGGER->info( sprintf 'prune directories: %s', $self->name );

        foreach my $dir ( @{ $self->prune_dirs } ) {

            my $pdir =
                sprintf( '%s/%s/%s', $self->fakeroot, $self->prefix, $dir );
            $LOGGER->debug( sprintf 'removing directory: %s', $pdir );

            path($pdir)->remove_tree( { safe => 0 } );
        }
    }

    return 1;
}

1;

=method prune

Deletes files and directories from the fakeroot.
