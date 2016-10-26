== Class: rhsm_only

A puppet module that removes any yum repo not provided in
 /etc/yum.repos.d/redhat.repo

=== Parameters

[*repodir*]
   /etc/yum.repos.d/

[*rhsm_repofile*]
   redhat.repo

[*repodir_immutable*]
   Should I set /etc/yum.repos.d/ so no one can write there?

[*certs_dir*]
   /etc/pki/entitlement

[*certs_mode*]
   What are the permissions on the certs?
   Defaults to allow owner and group read access.

[*certs_owner*]
   This should probably stay as 'root'

[*certs_group*]
   What group owns the certs, defaults to 'wheel'

[*before_packages*]
   setup Package to be after we set repos

[*manage_yum_rpm*]
   Ensure yum is up to date.  Required if using repodir_immutable

[*yum_rpm*]
   Name of package containing yum/dnf (should default just fine)

[*manage_release_rpm*]
   Ensure release rpm is up to date.  Required if using repodir_immutable

[*release_rpm*]
   Name of your release rpm

=== Examples
    include rhsm_only
    
    class { 'rhsm_only':
      repodir            => '/etc/yum.repos.d',
      rhsm_repofile      => 'redhat.repo',
      repodir_immutable  => true,
      certs_dir          => '/etc/pki/entitlement',
      certs_mode         => '0644',
      certs_owner        => 'root',
      certs_group        => 'wheel',
      before_packages    => true,
      manage_yum_rpm     => true,
      manage_release_rpm => false,
      release_rpm        => 'redhat-release',
    }

