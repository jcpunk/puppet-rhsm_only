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

[*stage*]
   At which puppet stage should I run, defaults to main.
   I suggest 'setup' from stdlib

[*certs_dir*]
   /etc/pki/entitlement

[*certs_mode*]
   What are the permissions on the certs?
   Defaults to allow owner and group read access.

[*certs_owner*]
   This should probably stay as 'root'

[*certs_group*]
   What group owns the certs, defaults to 'wheel'

=== Examples
    include rhsm_only
    
    class { 'rhsm_only':
      repodir           => '/etc/yum.repos.d',
      rhsm_repofile     => 'redhat.repo',
      repodir_immutable => true,
      stage             => 'setup',
      certs_dir         => '/etc/pki/entitlement',
      certs_mode        => '0644',
      certs_owner       => 'root',
      certs_group       => 'wheel',
    }

