use v5.14.0;
use warnings;

package OS::Package::Artifact::Role::Download;

use File::Path qw( make_path );
use FileHandle;
use HTTP::Tiny;
use OS::Package::Log;
use Path::Tiny;
use Role::Tiny;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

sub download {

    my $self = shift;

    if ( !$self->url ) {
        $LOGGER->logcroak('did not define url');
    }

    if ( -f $self->savefile ) {
        $LOGGER->info( sprintf 'distfile exists: %s', $self->savefile );
        $self->validate;
        return;
    }

    if ( !-d $self->repository ) {
        make_path $self->repository;
        $LOGGER->info( sprintf 'creating repository directory: %s',
            $self->repository );
    }

    $LOGGER->info( sprintf 'downloading %s', $self->distfile );

    my $response = HTTP::Tiny->new->get( $self->url );

    my $save_file = path( $self->savefile );

    $save_file->spew( $response->{content} );

    $self->validate;

    return;
}

1;

=method download
