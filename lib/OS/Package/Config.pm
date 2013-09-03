use v5.14.0;
use warnings;

package OS::Package::Config;

# ABSTRACT: Load OS::Package configuration object.
# VERSION

use YAML::Any qw( LoadFile );
use File::ShareDir qw(dist_file);
use Hash::AsObject;
use base qw(Exporter);

our @EXPORT = qw( $CONFIG );

local $YAML::UseCode  = 0 if !defined $YAML::UseCode;
local $YAML::LoadCode = 0 if !defined $YAML::LoadCode;

our $CONFIG = Hash::AsObject->new(
    LoadFile( dist_file( 'OS-Package', 'config.yml' ) ) );

1;
