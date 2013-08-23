use v5.14.0;
use warnings;

package OS::Package::Application::Role::Extract;

use Archive::Tar::Wrapper;
use File::Path qw( make_path );
use OS::Package::Config;
use OS::Package::Log;
use Role::Tiny;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

sub extract {

    my $self = shift;

    my $workdir = sprintf '%s/%s', $self->repository, $CONFIG->dir->work;

    if ( !-d $workdir ) {
        make_path $workdir;
    }

    my $archive = Archive::Tar::Wrapper->new( tmpdir => $workdir );

    $LOGGER->info( sprintf 'extracting archive: %s', $self->distfile );

    $archive->read( sprintf '%s/%s', $self->repository, $self->distfile );

    $self->archive($archive);

    return;

}

1;

=method extract
