use Test::More;

use OS::Package::Application;

my $name = 'demoApp';

my $app = OS::Package::Application->new( name => $name );

isa_ok( $app, 'OS::Package::Application' );

is( $app->name, $name );

done_testing;
