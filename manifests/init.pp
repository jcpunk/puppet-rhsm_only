# == Class: rhsm_only
class rhsm_only (
  $repodir            = $::rhsm_only::defaults::repodir,
  $rhsm_repofile      = $::rhsm_only::defaults::rhsm_repofile,
  $repodir_immutable  = $::rhsm_only::defaults::repodir_immutable,
  $certs_dir          = $::rhsm_only::defaults::certs_dir,
  $certs_mode         = $::rhsm_only::defaults::certs_mode,
  $certs_owner        = $::rhsm_only::defaults::certs_owner,
  $certs_group        = $::rhsm_only::defaults::certs_group,
  $before_packages    = $::rhsm_only::defaults::before_packages,
  $manage_yum_rpm     = $::rhsm_only::defaults::manage_yum_rpm,
  $manage_release_rpm = $::rhsm_only::defaults::manage_release_rpm,
  $release_rpm        = $::rhsm_only::defaults::release_rpm,

) inherits ::rhsm_only::defaults {

  validate_absolute_path($repodir)
  validate_string($rhsm_repofile)
  validate_bool($repodir_immutable)
  validate_absolute_path($certs_dir)
  validate_string($certs_mode)
  validate_string($certs_owner)
  validate_string($certs_group)
  validate_bool($before_packages)
  validate_bool($manage_yum_rpm)
  validate_bool($manage_release_rpm)
  validate_string($release_rpm)

  if $before_packages {
    Package {
      require => File[$repodir],
    }
  }

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

  if $manage_yum_rpm {
    exec {'yum -y update yum':
      path   => '/usr/bin/:/bin/:/sbin:/usr/sbin',
      onlyif => "yum list updates yum && chattr -i ${repodir}",
    }
    if $repodir_immutable {
      Exec['yum -y update yum'] {
        notify => Exec["chattr +i ${repodir}"],
        before => [ Exec["chattr +i ${repodir}"], File[$repodir],],
      }
    } else {
      Exec['yum -y update yum'] {
        before => File[$repodir],
      }
    }
  }

  if $manage_release_rpm {
    exec {"yum -y update ${release_rpm}":
      path   => '/usr/bin/:/bin/:/sbin:/usr/sbin',
      onlyif => "yum list updates ${release_rpm} && chattr -i ${repodir}",
    }
    if $repodir_immutable {
      Exec["yum -y update ${release_rpm}"] {
        notify => Exec["chattr +i ${repodir}"],
        before => [ Exec["chattr +i ${repodir}"], File[$repodir],],
      }
    } else {
      Exec["yum -y update ${release_rpm}"] {
        before => File[$repodir],
      }
    }
  }

}
