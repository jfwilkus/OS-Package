use v5.14.0;
use warnings;

package OS::Package::Plugin::Solaris::SVR4;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo;
use Time::Piece;
use Types::Standard qw( Str );
use Template;
use File::ShareDir qw(dist_file);
use OS::Package::Log;

extends 'OS::Package';

has [qw( user group arch basedir category version vendor )] =>
    ( is => 'rw', isa => Str, required => 1 );

has 'pstamp' => (
    is      => 'rw',
    isa     => Str,
    default => sub { my $t = localtime; return $t->datetime; }
);

sub _generate_pkginfo {
    my $self = shift;

    $LOGGER->info('generating: pkginfo');

    my $template =
        dist_file( 'OS::Package', 'plugin/Solaris/SVR4/pkginfo.tt2' );

    my $ttcfg = { INCLUDE_PATH => dirname($template) };

    my $tt = Template->new($ttcfg);

    my $pkginfo = sprintf '%s/%s/pkginfo', $self->fakeroot, $self->prefix;

    $tt->process(
        basename($template),
        {   PKG      => $self->pkgname,
            NAME     => $self->name,
            DESC     => $self->description,
            ARCH     => $self->architecture,
            VERSION  => $self->version,
            CATEGORY => $self->category,
            VENDOR   => $self->vendor,
            PSTAMP   => $self->pstamp,
            BASEDIR  => $self->basedir,
        },
        $pkginfo
    ) or $LOGGER->logdie( $tt->error );

    return 1;
}

sub _generate_prototype {
    return;
}

sub _generate_package {
    return;
}

sub create {
    my $self = shift;

    $LOGGER->info('generating: Solaris SVR4 package');

    $self->_generate_pkginfo;

    return 1;
}

1;
