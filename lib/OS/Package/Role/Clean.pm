use v5.14.0;
use warnings;

package OS::Package::Role::Clean;

# ABSTRACT: Provides the clean method for Application role.
# VERSION

use File::Path qw( remove_tree );
use OS::Package::Log;
use Role::Tiny;

sub clean {
    my $self = shift;

    if ( defined $self->workdir && -d $self->workdir ) {
        $LOGGER->info( sprintf 'cleaning work directory: %s',
            $self->workdir );

        remove_tree $self->workdir;
    }

    if ( defined $self->fakeroot && -d $self->fakeroot ) {
        $LOGGER->info( sprintf 'cleaning fakeroot directory: %s',
            $self->fakeroot );

        remove_tree $self->fakeroot;
    }

    return 1;
}

1;

=method clean

Provides method to clean the fakeroot directory.
