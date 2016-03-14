# Default parameters
class rhsm_only::defaults {
  $run_stage = 'main'

  case $::osfamily {
    'RedHat', 'CentOS', 'Scientific', 'Fedora': {
      $repodir = '/etc/yum.repos.d'
      $rhsm_repofile = 'redhat.repo'
      $repodir_immutable = false
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
