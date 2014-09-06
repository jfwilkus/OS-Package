use OS::Package::Plugin::Solaris::SVR4;
use DateTime::Format::DateManip;
use Test::More;

use_ok('OS::Package::Plugin::Solaris::SVR4');

my $cfg = {
    name        => 'testpackage',
    user        => 'root',
    group       => 'root',
    arch        => 'i386',
    basedir     => '/opt/sf',
    category    => 'application',
    vendor      => 'test co.',
    description => 'test application',
    version     => '1.0'
};

my $pkg = OS::Package::Plugin::Solaris::SVR4->new($cfg);

foreach my $key ( keys %{$cfg} ) {
    is( $pkg->$key, $cfg->{$key} );
}

isa_ok($pkg, 'OS::Package');

ok( DateTime::Format::DateManip->parse_datetime( $pkg->pstamp ),
    'pstamp is a valid date' );

can_ok( $pkg, 'create' );

done_testing;
