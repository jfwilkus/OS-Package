use v5.14.0;
use warnings;

package OS::Package::Plugin::Solaris::SVR4;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Cwd;
use Moo;
use Env qw( $HOME );
use Time::Piece;
use Types::Standard qw( Str );
use Template;
use Path::Tiny;
use File::ShareDir qw(dist_file);
use File::Basename qw( basename dirname );
use File::Path qw( remove_tree );
use OS::Package::Config;
use OS::Package::Log;
use IPC::Cmd qw( can_run run );

extends 'OS::Package';

has pkgfile_suffix =>
    ( is => 'ro', isa => Str, required => 1, default => sub {'pkg'} );

has user => (
    is       => 'rw',
    isa      => Str,
    required => 1,
    default  => sub { $OSPKG_CONFIG->{package}{user} }
);

has group => (
    is       => 'rw',
    isa      => Str,
    required => 1,
    default  => sub { $OSPKG_CONFIG->{package}{group} }
);

has category => (
    is       => 'rw',
    isa      => Str,
    required => 1,
    default  => sub { $OSPKG_CONFIG->{package}{category} }
);

has pstamp => (
    is      => 'rw',
    isa     => Str,
    default => sub { my $t = localtime; return $t->datetime; }
);

has pkgfile => (
    is       => 'rw',
    isa      => Str,
    required => 1,
    default  => sub {
        my $self   = shift;
        my $system = OS::Package::System->new;
        return sprintf '%s-%s-%s-%s.pkg', $self->name,
            $self->application->version,
            $system->os, $system->type, $self->pkgfile_suffix;
    }
);

sub _generate_pkginfo {
    my $self = shift;

    $LOGGER->info('generating: pkginfo');

    my $template =
        dist_file( 'OS-Package', 'plugin/Solaris/SVR4/pkginfo.tt2' );

    my $ttcfg = { INCLUDE_PATH => dirname($template) };

    my $tt = Template->new($ttcfg);

    my $pkginfo = sprintf '%s/%s/pkginfo', $self->fakeroot, $self->prefix;

    $tt->process(
        basename($template),
        {   pkgname     => $self->name,
            name        => $self->application->name,
            description => $self->description,
            arch        => $self->system->type,
            version     => $self->application->version,
            category    => $self->category,
            vendor      => $self->maintainer->company,
            pstamp      => $self->pstamp,
            basedir     => $self->prefix,
        },
        $pkginfo
    ) or $LOGGER->logdie( $tt->error );

    return 1;
}

sub _generate_prototype {
    my $self = shift;

    $LOGGER->info('generating: prototype');

    my $pkg_path = sprintf '%s/%s', $self->fakeroot, $self->prefix;

    chdir $pkg_path;

    my $command = [ can_run('pkgproto'), '.' ];

    my ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf ) =
        run( command => $command );

    foreach ( @{$full_buf} ) {
        $LOGGER->debug($_);
    }

    if ( !$success ) {
        $LOGGER->error( sprintf "pkgproto failed: %s\n", $error_message );

        return 2;
    }

    my @prototype = ("i pkginfo\n");

    my @lines = split "\n", join( q{}, @{$stdout_buf} );

    foreach my $line (@lines) {
        my ( $file_type, $class, $pathname, $mode, $owner, $group ) =
            split q{ }, $line;

        next if ( $pathname =~ qr{pkginfo|prototype}xms );

        if ( defined $mode ) {
            push @prototype,
                sprintf( "%s %s %s %s %s %s\n",
                $file_type, $class, $pathname, $mode, $self->user,
                $self->group );
        }
        else {
            push @prototype,
                sprintf( "%s %s %s\n", $file_type, $class, $pathname );
        }
    }

    path( sprintf( '%s/prototype', $pkg_path ) )->spew( \@prototype );

    chdir $HOME;

    return 1;
}

sub _generate_package {
    my $self = shift;

    $LOGGER->info( sprintf 'generating package: %s', $self->name );

    my $pkg_path = sprintf '%s/%s', $self->fakeroot, $self->prefix;

    chdir $pkg_path;

    if ( -d sprintf( '/var/spool/pkg/%s', $self->name ) ) {
        $LOGGER->debug('removing existing package spool directory');
        remove_tree sprintf( '/var/spool/pkg/%s', $self->name );
    }

    if ( -f sprintf( '/var/spool/pkg/%s', $self->pkgfile ) ) {
        $LOGGER->debug('removing existing package file from spool directory');
        unlink sprintf( '/var/spool/pkg/%s', $self->pkgfile );
    }

    my $command =
        [ can_run('pkgmk'), '-o', '-r', cwd, '-d', '/var/spool/pkg' ];

    my ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf ) =
        run( command => $command );

    foreach ( @{$full_buf} ) {
        $LOGGER->debug($_);
    }

    if ( !$success ) {
        $LOGGER->error( sprintf "pkgproto failed: %s\n", $error_message );

        return 2;
    }

    $command = [
        can_run('pkgtrans'), '-s',
        '/var/spool/pkg',    $self->pkgfile,
        $self->name
    ];

    ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf ) =
        run( command => $command );

    foreach ( @{$full_buf} ) {
        $LOGGER->debug($_);
    }

    if ( !$success ) {
        $LOGGER->error( sprintf "pkgtrans failed: %s\n", $error_message );

        return 2;
    }

    if ( -d sprintf( '/var/spool/pkg/%s', $self->name ) ) {
        $LOGGER->debug('removing existing package spool directory');
        remove_tree sprintf( '/var/spool/pkg/%s', $self->name );
    }

    chdir $HOME;

    $LOGGER->info( sprintf 'created package: /var/spool/pkg/%s',
        $self->pkgfile );

    return 1;
}

sub create {
    my $self = shift;

    $LOGGER->info('generating: Solaris SVR4 package');

    $self->_generate_pkginfo;

    $self->_generate_prototype;

    $self->_generate_package;

    return 1;
}

1;
