# == Class: rhsm_only
#
# A puppet module that removes all non-redhat.repo repos
#
# === Parameters
#
#  [*repodir*]
#    /etc/yum.repos.d/
#  [*rhsm_repofile*]
#    redhat.repo
#  [*repodir_immutable*]
#    Should I set /etc/yum.repos.d/ so no one can write there?
#  [*run_stage*]
#    At which puppet stage should I run
class rhsm_only (
  $repodir           = $::rhsm_only::defaults::repodir,
  $rhsm_repofile     = $::rhsm_only::defaults::rhsm_repofile,
  $repodir_immutable = $::rhsm_only::defaults::repodir_immutable,
  $run_stage         = $::rhsm_only::defaults::run_stage,
) inherits ::rhsm_only::defaults {

  file {$::rhsm_only::repodir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    require => File["${::rhsm_only::repodir}/${::rhsm_only::rhsm_repofile}"],
    stage   => $run_stage,
  }

  file {"${::rhsm_only::repodir}/${::rhsm_only::rhsm_repofile}":
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    stage  => $run_stage,
  }

  if $::rhsm_only::repodir_immutable {
    exec {"chattr +i ${::rhsm_only::repodir}":
      unless  => "lsattr -d ${::rhsm_only::repodir} | sed -e 's/-/:/g' | grep '::i::'",
      require => File[$::rhsm_only::repodir],
      stage   => $run_stage,
    }
  }
