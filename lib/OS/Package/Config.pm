use v5.14.0;
use warnings;

package OS::Package::Config;

# ABSTRACT: Load OS::Package configuration object.
# VERSION

use base qw(Exporter);
use Env qw( $HOME );
use File::ShareDir qw(dist_file);
use Hash::AsObject;
use Path::Tiny;
use YAML::Any qw( LoadFile );

our @EXPORT = qw( $OSPKG_CONFIG );

local $YAML::UseCode  = 0 if !defined $YAML::UseCode;
local $YAML::LoadCode = 0 if !defined $YAML::LoadCode;

our $OSPKG_CONFIG = Hash::AsObject->new(
    LoadFile( dist_file( 'OS-Package', 'config.yml' ) ) );

if ( path( $OSPKG_CONFIG->user_config )->exists ) {

    my $user_config = LoadFile( path( $OSPKG_CONFIG->user_config ) );

    if ( defined $user_config->{config_dir} ) {
        $OSPKG_CONFIG->dir->configs($user_config->{config_dir});
    }

    if ( defined $user_config->{pkg_dir} ) {
        $OSPKG_CONFIG->dir->packages($user_config->{pkg_dir});
    }

}

1;
