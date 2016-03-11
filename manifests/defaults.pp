# Default parameters
class rhsm_only::defaults {
  include stdlib

  # this stage comes from stdlib
  $run_stage = 'setup'

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
