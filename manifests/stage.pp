# until http://projects.theforeman.org/issues/1987 is fixed
# this is the cleanest way I can think of to get this in the
# right stage.
# Basically this is a stub I can force into a stage and then
# depend on for completion
class rhsm_only::stage {

  file {$::rhsm_only::repodir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    require => File["${::rhsm_only::repodir}/${::rhsm_only::rhsm_repofile}"],
  }

  file {"${::rhsm_only::repodir}/${::rhsm_only::rhsm_repofile}":
    ensure => present,
    mode   => '0644',
    notify => Exec['chown redhat.repo'],
  }

  exec {'chown redhat.repo':
    path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    command     => "chown root:root ${::rhsm_only::repodir}/${::rhsm_only::rhsm_repofile}",
    refreshonly => true,
  }

  if $::rhsm_only::repodir_immutable {
    exec {"chattr +i ${::rhsm_only::repodir}":
      path    => '/usr/bin/:/bin/:/sbin:/usr/sbin',
      unless  => "/usr/bin/lsattr -d ${::rhsm_only::repodir} | /bin/sed -e 's/-/:/g' | /bin/grep '::i::'",
      require => File[$::rhsm_only::repodir],
    }
  }

}
