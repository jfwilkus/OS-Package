use Test::More;

my @PM = qw(
	OS::Package
	OS::Package::Log
	OS::Package::Config
	OS::Package::Application
	OS::Package::Artifact
	OS::Package::Artifact::Role::Clean
    OS::Package::Artifact::Role::Download
    OS::Package::Artifact::Role::Extract
    OS::Package::Application::Factory
);

foreach my $pm (@PM) {
    use_ok($pm);
}

done_testing;
