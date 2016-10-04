# Default parameters
class rhsm_only::defaults {
  $before_packages = true

  case $::osfamily {
    'RedHat', 'CentOS', 'Scientific', 'Fedora': {
      $repodir           = '/etc/yum.repos.d'
      $rhsm_repofile     = 'redhat.repo'
      $repodir_immutable = false
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $certs_dir   = '/etc/pki/entitlement'
  $certs_mode  = '0640'
  $certs_owner = 'root'
  $certs_group = 'wheel'

}
