use Test::More;

use OS::Package;
use OS::Package::Application;
use OS::Package::Maintainer;
use Config;

my $name        = 'demoApp';
my $version     = '1.1.1';
my $prefix      = '/usr/local';
my $description = 'A demo application';

my $username = 'Test User';
my $nickname = 'tuser';
my $email    = 'tuser@testco.com';
my $phone    = '555-333-2222';
my $company  = 'Test Co.';

my $maintainer = OS::Package::Maintainer->new(
    name     => $username,
    nickname => $nickname,
    email    => $email,
    phone    => $phone,
    company  => $company
);

my $app = OS::Package::Application->new(
    name    => 'test package',
    version => '1.0.0'
);

my $pkg = OS::Package->new(
    name        => $name,
    version     => $version,
    prefix      => $prefix,
    maintainer  => $maintainer,
    description => $description,
    application => $app
);

isa_ok( $pkg, 'OS::Package' );

is( $pkg->name, $name );

is( $pkg->maintainer->name, $username, 'maintainer is properly defined' );
is( $pkg->system->os, $Config{osname}, 'os is properly defined' );

done_testing;
