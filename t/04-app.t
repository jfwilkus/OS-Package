use Test::More;

use OS::Package::Application;

my $name    = 'demoApp';
my $version = '1.1.1';
my $prefix  = '/usr/local';

my $app = OS::Package::Application->new(
    name    => $name,
    version => $version,
    prefix  => $prefix
);

isa_ok( $app, 'OS::Package::Application' );

is( $app->name, $name );

done_testing;
