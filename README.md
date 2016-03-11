# puppet-rhsm_only

This module will remove any yum repo not provided in
  /etc/yum.repos.d/redhat.repo

It uses the stdlib stages to run as early as possible
to avoid any unclear ordering
