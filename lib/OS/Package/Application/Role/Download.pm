use v5.14.0;
use warnings;

package OS::Package::Application::Role::Download;

use Carp qw(croak);
use HTTP::Tiny;
use Path::Tiny;
use Role::Tiny;
use FileHandle;
use File::Path qw( make_path );
use OS::Package::Log;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

sub download {

    my $self = shift;

    if ( !$self->url ) {
        croak 'did not define url';
    }

    if ( !-d $self->repository ) {
        make_path $self->repository;
        $LOGGER->info( sprintf 'creating repository directory: %s',
            $self->repository );
    }

    $LOGGER->info( sprintf 'downloading %s', $self->distfile );

    my $response = HTTP::Tiny->new->get( $self->url );

    my $save_file = path( $self->artifact );

    $save_file->spew( $response->{content} );

    return;
}

1;

=method download
