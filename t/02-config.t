use Test::More;

use OS::Package::Config;

isa_ok($CONFIG, 'Hash::AsObject');

done_testing;