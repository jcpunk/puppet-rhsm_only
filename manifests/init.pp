class rhsm_only (
  $repodir           = $::rhsm_only::defaults::repodir,
  $rhsm_repofile     = $::rhsm_only::defaults::rhsm_repofile,
  $repodir_immutable = $::rhsm_only::defaults::repodir_immutable,
) inherits ::rhsm_only::defaults {

  file {$::rhsm_only::repodir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    require => File["${::rhsm_only::repodir}/${::rhsm_only::rhsm_repofile}"],
  }

  file {"${::rhsm_only::repodir}/${::rhsm_only::rhsm_repofile}":
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  if $::rhsm_only::repodir_immutable {
    exec {"chattr +i ${::rhsm_only::repodir}":
      unless  => "lsattr -d ${::rhsm_only::repodir} | sed -e 's/-/:/g' | grep '::i::'",
      require => File[$::rhsm_only::repodir],
    }
  }
