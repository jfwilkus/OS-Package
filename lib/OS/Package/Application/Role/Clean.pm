use v5.14.0;
use warnings;

package OS::Package::Application::Role::Clean;

# ABSTRACT: Provides the clean method for Application role.
# VERSION

use File::Path qw( remove_tree );
use OS::Package::Log;
use Role::Tiny;

sub clean {
    my $self = shift;

    if ( !defined $self->fakeroot ) {
        return;
    }

    if ( -d $self->fakeroot ) {
        $LOGGER->info( sprintf 'cleaning fakeroot directory: %s',
            $self->fakeroot );

        remove_tree $self->fakeroot;
    }

    return 1;
}

1;

=method clean

Provides method to clean the fakeroot directory.
