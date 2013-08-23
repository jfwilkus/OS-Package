use Test::More;

my @PM = qw(
	OS::Package
	OS::Package::Log
	OS::Package::Config
	OS::Package::Application
    OS::Package::Application::Role::Download
    OS::Package::Application::Role::Extract
    OS::Package::Application::Factory
    OS::Package::Build::Configure
);

foreach my $pm (@PM) {
    use_ok($pm);
}

done_testing;
