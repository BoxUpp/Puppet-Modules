#  Class: percona
#
#  Install and restore mysql database backup taken through Percona XtraBackup
#
#  Parameters
#
#  [*$backup_dir*]
#  The is the directory from  where the percona application will restore
#  database.
#
#  Authors
#
#  Boxupp Team <http://boxupp.com/>
#
#  Copyright
#  Copyright © 2014-2015 Paxcel Technologies (p) Ltd
#  site : http://paxcel.net/   http://boxupp.com/

class percona 

	# Define your backup diectory path here.
	( 			$backup_dir  = '/opt/backup',)
		
	{
  	          
		package { 'percona-release-0.0-1.x86_64':
				provider => 'rpm',
				ensure 	 => installed,
				source   => "http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm";
       	}
      
		 package { 'percona-xtrabackup.x86_64':
                 		ensure  => installed,
                 		require => Package["percona-release-0.0-1.x86_64"];
	}
          
		exec { "stop_mysql":
				path    => ["/bin", "/usr/bin","/usr/sbin"],
				command => "/etc/init.d/mysql stop",
				require => Package["percona-xtrabackup.x86_64"];
       	}

		exec { "prep_backup":
				path 	=> ["/bin", "/usr/bin","/usr/sbin"],
				command => "innobackupex --apply-log $backup_dir",
				require => Exec["stop_mysql"];
       	}

		exec { "clean_datadir":
				path    => ["/bin", "/usr/bin","/usr/sbin"],
				command => "sudo rm -rf /var/lib/mysql/*",
				require => Exec["prep_backup"];
       	}	
       
		exec { "import":
				path 	=> ["/bin", "/usr/bin","/usr/sbin"],
				command => "innobackupex --copy-back $backup_dir",
				require => Exec["clean_datadir"],
				timeout => 140000;
       	}
         
		exec { "permissions":
				path 	=> ["/bin", "/usr/bin","/usr/sbin"],        
				command => "chown -R mysql:mysql /var/lib/mysql/*",
				require => Exec["import"];
       	}
       
		service { "mysql":
				enable => true,
				ensure => running,
				require => Exec["permissions"];
        }

}
