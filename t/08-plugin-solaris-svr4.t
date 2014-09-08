
use DateTime::Format::DateManip;
use Test::More;

use_ok('OS::Package::Plugin::Solaris::SVR4');
use_ok('OS::Package::Maintainer');

my $name     = 'Test User';
my $nickname = 'tuser';
my $email    = 'tuser@testco.com';
my $phone    = '555-333-2222';
my $company  = 'Test Co.';

my $maintainer = OS::Package::Maintainer->new(
    name     => $name,
    nickname => $nickname,
    email    => $email,
    phone    => $phone,
    company  => $company
);

my $app = OS::Package::Application->new(
    name    => 'test package',
    version => '1.0.0'
);

my $cfg = {
    name        => 'testpackage',
    user        => 'root',
    group       => 'root',
    arch        => 'i386',
    prefix      => '/opt/sf',
    category    => 'application',
    vendor      => 'test co.',
    description => 'test application',
    version     => '1.0',
    maintainer  => $maintainer,
    application => $app
};

my $pkg = OS::Package::Plugin::Solaris::SVR4->new($cfg);

foreach my $key ( keys %{$cfg} ) {
    is( $pkg->$key, $cfg->{$key} );
}

isa_ok( $pkg, 'OS::Package' );

ok( DateTime::Format::DateManip->parse_datetime( $pkg->pstamp ),
    'pstamp is a valid date' );

can_ok( $pkg, 'create' );

done_testing;
