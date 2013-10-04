use Test::More;

use OS::Package::Application;

my $name    = 'demoApp';
my $version = '1.1.1';

my $app = OS::Package::Application->new( name => $name, version => $version );

isa_ok( $app, 'OS::Package::Application' );

is( $app->name, $name );

done_testing;
