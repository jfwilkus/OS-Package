use Test::More;

use OS::Package::Dist::Solaris::SVR4;

my $name    = 'demoApp';
my $version = '1.1.1';

my $app = OS::Package::Dist::Solaris::SVR4->new(
    name         => $name,
    version      => $version,
    architecture => 'sparc',
    bitness      => '64'
);

isa_ok( $app, 'OS::Package::Dist::Solaris::SVR4' );

is( $app->name, $name );

done_testing;
