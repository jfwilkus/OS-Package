use v5.14.0;
use warnings;

package OS::Package::Artifact::Role::Extract;

use Archive::Extract;
use File::Copy;
use File::Path qw( make_path remove_tree );
use Path::Tiny;
use OS::Package::Config;
use OS::Package::Log;
use Role::Tiny;

# ABSTRACT: Provides the extract method for Artifact role.
# VERSION

local $Archive::Extract::PREFER_BIN = 1;

sub extract {

    my $self = shift;

    if ( ! path($self->workdir)->exists ) {
        path($self->workdir)->mkpath;
    }

    my $archive;

    if ( ! defined $self->distfile ) {
        return 1;
    }

    if ( $self->distfile =~ /\.(tar|tgz|gz|Z|zip|bz2|tbz|lzma|xz|tx)$/ ) {

        $archive = Archive::Extract->new( archive => $self->savefile );
        $LOGGER->info( sprintf 'extracting archive: %s', $self->distfile );

        $archive->extract( to => $self->workdir );

        $self->archive($archive);

        $LOGGER->info( sprintf 'extracted archive: %s',
            $self->archive->extract_path );
    }
    else {

        $LOGGER->info( sprintf 'staging distfile to workdir: %s',
            $self->distfile );

        copy( $self->savefile,
            sprintf( '%s/%s', $self->workdir, $self->distfile ) );
    }

    return 1;

}

1;

=method extract
