use v5.14.0;
use warnings;

package OS::Package::Artifact::Role::Clean;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use File::Path qw( remove_tree );
use OS::Package::Log;
use Role::Tiny;

sub clean {
    my $self = shift;

    if ( !defined $self->workdir ) {
        return;
    }

    if ( -d $self->workdir ) {
        $LOGGER->info( sprintf 'removing work directory: %s',
            $self->workdir );

        remove_tree $self->workdir;
    }

    return 1;
}

1;
