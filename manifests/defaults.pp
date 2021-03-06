# Default parameters
class rhsm_only::defaults {
  $before_packages = true

  case $::operatingsystem {
    'RedHat', 'CentOS', 'Scientific', 'Fedora': {
      $repodir           = '/etc/yum.repos.d'
      $rhsm_repofile     = 'redhat.repo'
      $repodir_immutable = false
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $manage_release_rpm = true
  $manage_yum_rpm     = true

  if versioncmp($::operatingsystemmajrelease, '8') < 0 {
    $yum_rpm = 'yum'
  } else {
    $yum_rpm = 'dnf'
  }

  $release_rpm = $::operatingsystem ? {
    /RedHat/     => 'redhat-release-server',
    /CentOS/     => 'centos-release',
    /Scientific/ => $::lsbdistid ? {
                        /ScientificFermi/ => 'slf-release',
                        /Scientific/      => 'sl-release',
                        default           => 'sl-release',
                      },
    /Fedora/     => 'fedora-release',
  }

  $certs_dir   = '/etc/pki/entitlement'
  $certs_mode  = '0640'
  $certs_owner = 'root'
  $certs_group = 'wheel'

  $repo_mode   = '0644'
  $repo_owner  = 'root'
  $repo_group  = 'root'

}
