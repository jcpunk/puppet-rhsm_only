# == Class: rhsm_only
class rhsm_only (
  $repodir           = $::rhsm_only::defaults::repodir,
  $rhsm_repofile     = $::rhsm_only::defaults::rhsm_repofile,
  $repodir_immutable = $::rhsm_only::defaults::repodir_immutable,
  $stage             = $::rhsm_only::defaults::stage,
  $certs_dir         = $::rhsm_only::defaults::certs_dir,
  $certs_mode        = $::rhsm_only::defaults::certs_mode,
  $certs_owner       = $::rhsm_only::defaults::certs_owner,
  $certs_group       = $::rhsm_only::defaults::certs_group,

) inherits ::rhsm_only::defaults {

  validate_absolute_path($repodir)
  validate_string($rhsm_repofile)
  validate_bool($repodir_immutable)
  validate_string($stage)
  validate_absolute_path($certs_dir)
  validate_string($certs_mode)
  validate_string($certs_owner)
  validate_string($certs_group)

  file {$certs_dir:
    ensure  => directory,
    recurse => true,
    purge   => false,
    owner   => $certs_owner,
    group   => $certs_group,
    mode    => $certs_mode,
  }

  file {$repodir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    require => File["${repodir}/${rhsm_repofile}"],
  }

  file {"${repodir}/${rhsm_repofile}":
    ensure => present,
    mode   => '0644',
    notify => Exec['chown redhat.repo'],
  }

  exec {'chown redhat.repo':
    path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    command     => "chown root:root ${repodir}/${rhsm_repofile}",
    refreshonly => true,
  }

  if $repodir_immutable {
    exec {"chattr +i ${repodir}":
      path    => '/usr/bin/:/bin/:/sbin:/usr/sbin',
      unless  => "/usr/bin/lsattr -d ${repodir} | /bin/sed -e 's/-/:/g' | /bin/grep '::i::'",
      require => File[$repodir],
    }
  }



}
