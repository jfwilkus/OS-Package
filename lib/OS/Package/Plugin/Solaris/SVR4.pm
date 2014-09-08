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
use OS::Package::Config;
use OS::Package::Log;

extends 'OS::Package';

has user => (
    is       => 'rw',
    isa      => Str,
    required => 1,
    default  => sub { return $OSPKG_CONFIG->{package}{user} }
);

has group => (
    is       => 'rw',
    isa      => Str,
    required => 1,
    default  => sub { return $OSPKG_CONFIG->{package}{group} }
);

has category => (
    is       => 'rw',
    isa      => Str,
    required => 1,
    default  => sub { return $OSPKG_CONFIG->{package}{category} }
);


has pstamp => (
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
        {   PKG      => $self->name,
            NAME     => $self->application->name,
            DESC     => $self->description,
            ARCH     => $self->system->type,
            VERSION  => $self->application->version,
            CATEGORY => $self->category,
            VENDOR   => $self->maintainer->company,
            PSTAMP   => $self->pstamp,
            BASEDIR  => $self->prefix,
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
