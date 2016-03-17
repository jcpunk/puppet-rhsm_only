# == Class: rhsm_only
class rhsm_only (
  $repodir           = $::rhsm_only::defaults::repodir,
  $rhsm_repofile     = $::rhsm_only::defaults::rhsm_repofile,
  $repodir_immutable = $::rhsm_only::defaults::repodir_immutable,
  $run_stage         = $::rhsm_only::defaults::run_stage,
) inherits ::rhsm_only::defaults {

  validate_absolute_path($repodir)
  validate_string($rhsm_repofile)
  validate_bool($repodir_immutable)
  validate_string($run_stage)

  class { 'rhsm_only::stage': stage => $run_stage }

}
