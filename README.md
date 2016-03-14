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
[*run_stage*]
   At which puppet stage should I run, defaults to main.
   I suggest 'setup' from stdlib

=== Examples
    include rhsm_only
    
    class { 'rhsm_only':
      repodir           => '/etc/yum.repos.d',
      rhsm_repofile     => 'redhat.repo',
      repodir_immutable => true,
      run_stage         => 'setup',
    }

