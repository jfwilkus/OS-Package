use v5.14.0;
use warnings;

package OS::Package::Role::Clean;

# ABSTRACT: Provides the clean method.
# VERSION

use Path::Tiny;
use OS::Package::Log;
use Role::Tiny;

sub clean {
    my $self = shift;

    if ( defined $self->workdir && -d $self->workdir ) {
        $LOGGER->info( sprintf 'cleaning work directory: %s',
            $self->workdir );

        path($self->workdir)->remove_tree;
    }

    if ( defined $self->fakeroot && -d $self->fakeroot ) {
        $LOGGER->info( sprintf 'cleaning fakeroot directory: %s',
            $self->fakeroot );

        path($self->fakeroot)->remove_tree;
    }

    return 1;
}

1;

=method clean

Provides method to clean the fakeroot directory.
