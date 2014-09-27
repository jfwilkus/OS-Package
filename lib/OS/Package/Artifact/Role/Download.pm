use v5.14.0;
use warnings;

package OS::Package::Artifact::Role::Download;

use FileHandle;
use HTTP::Tiny;
use OS::Package::Log;
use Path::Tiny;
use Role::Tiny;

# ABSTRACT: Provides the download method for Artifact role.
# VERSION

sub download {

    my $self = shift;

    if ( !$self->url ) {
        $LOGGER->debug('did not define url');
        return 1;
    }

    if ( path( $self->savefile )->exists ) {

        $LOGGER->info( sprintf 'distfile exists: %s', $self->savefile );

        if ( $self->validate ) {
            return 1;
        }
        else {
            $LOGGER->warn( sprintf 'removing bad distfile: %s',
                $self->savefile );
            path( $self->savefile )->remove;
        }
    }

    $LOGGER->info( sprintf 'downloading: %s', $self->distfile );
    $LOGGER->debug( sprintf 'saving to: %s', $self->savefile );

    my $response = HTTP::Tiny->new->get( $self->url );

    my $save_file = path( $self->savefile )->realpath;

    $save_file->spew( $response->{content} );

    if ( !$self->validate ) {
        $LOGGER->logcroak( sprintf 'cannot download: %s', $self->url );
    }

    return 1;
}

1;

=method download
