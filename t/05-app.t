use Test::More;

use_ok('OS::Package');

my $pkg = OS::Package->new(
    name        => 'test package',
    description => 'test package role'
);

is( $pkg->name,        'test package' );
is( $pkg->description, 'test package role' );

done_testing;
