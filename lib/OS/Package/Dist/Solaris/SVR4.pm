use v5.14.0;
use warnings;

package OS::Package::Dist::Solaris::SVR4;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Moo;

with qw(
	OS::Package::Dist::Role::Package
);

sub _generate_pkginfo {
	return 1;
}

sub _generate_prototype {
	return 1;
}

sub _generate_package {

}

sub create {
	return 1;
}

1;
