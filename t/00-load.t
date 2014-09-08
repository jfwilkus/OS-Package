use Test::More;

my @PM = qw(
  OS::Package
  OS::Package::CLI
  OS::Package::Application::Factory
  OS::Package::Application::Role::Build
  OS::Package::Role::Clean
  OS::Package::Application::Role::Prune
  OS::Package::Application
  OS::Package::Artifact::Role::Clean
  OS::Package::Artifact::Role::Download
  OS::Package::Artifact::Role::Extract
  OS::Package::Artifact::Role::Validate
  OS::Package::Artifact
  OS::Package::Config
  OS::Package::Log
  OS::Package::Maintainer
  OS::Package::Plugin::Linux::deb
  OS::Package::Plugin::Linux::RPM
  OS::Package::Plugin::Solaris::IPS
  OS::Package::Plugin::Solaris::SVR4
  OS::Package::System
);

foreach my $pm (@PM) {
    use_ok($pm);
}

can_ok(OS::Package::CLI, 'run');
done_testing;
