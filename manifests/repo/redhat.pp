# Configure a yum repo for RedHat-based systems
#
# === Parameters
#
# [*yum_repo*]
#   Class name of the repo under ::yum::repo
#

class php::repo::redhat {
  # Get the version of php to install from global values
  $version_real = $::php::globals::php_version

  # Convert the point version in to non point.  aka 5.6 -> 56
  $version_short = regsubst($version_real, '\.', '', 'G')

  # Get os release name
  $releasever = $facts['os']['name'] ? {
    /(?i:Amazon)/ => '6',
    default       => '$releasever',  # Yum var
  }

  yumrepo { "remi-php${version_short}":
    ensure     => 'present',
    descr      => "Remi\'s PHP ${version_real} RPM repository for Enterprise Linux \$releasever - \$basearch",
    mirrorlist => "http://cdn.remirepo.net/enterprise/${releasever}/php${version_short}/mirror",
    enabled    => '1',
    gpgcheck   => '1',
    gpgkey     => 'https://rpms.remirepo.net/RPM-GPG-KEY-remi',
    priority   => 1,
  }

  yumrepo { 'remi-safe':
    descr      => 'Safe Remi\'s RPM repository for Enterprise Linux $releasever - $basearch',
    mirrorlist => "http://cdn.remirepo.net/enterprise/${releasever}/safe/mirror",
    enabled    => 1,
    gpgcheck   => 1,
    gpgkey     => 'https://rpms.remirepo.net/RPM-GPG-KEY-remi',
    priority   => 1,
  }
}
