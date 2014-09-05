use Test::More;
use OS::Package::System;

my $system =
    OS::Package::System->new( os => 'solaris', bits => 32, type => 'i386' );

isa_ok( $system, 'OS::Package::System' );
is( $system->os,   'solaris' );
is( $system->type, 'i386' );
is( $system->bits, 32 );

done_testing;
