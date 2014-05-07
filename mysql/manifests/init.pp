#  Class: mysql
#
#  Install and configure mysql 5.5 
#
#  Parameters
#
#  [*$sourcefile*]
#  The is the directory from  where the mysql module will get its configurations.
#
#  [*$mysql_logs_dir*]
#  Define mysql log directory on this path.
#
#  [*$$mysql_download_path*]
#  Define the directory in which mysql packages will be downloaded.
#
#  [*$mysql_server_download_url*]
#  Define the mysql server download url path here.
#
#  [*$mysql_client_download_url*]
#  Define the mysql client download url pathere.
#
#  [*$mysql_server_version*]
#  Define mysql-sever package version here
#
#  [*$mysql_client_version*]
#  Define mysql-client package verion here
#
#  [*$mysql_server_package*]
#  Define mysql server package name 
#
#  [*$mysql_client_package*]
#  Define mysql client package here
#
#  [*$root_password*]
#  Define mysql root password here 
#
#  Authors
#
#  Boxupp Team <http://boxupp.com/>
#
#  Copyright
#  Copyright © 2014-2015 Paxcel Technologies (p) Ltd
#  site : http://paxcel.net/   http://boxupp.com/



class mysql(
	#Define mysql configuration files source path here
	$source_path		    =  hiera('mysql::source_path',		'/vagrant/modules/mysql/files'),
	#Define mysql logs directory
	$mysql_logs_dir		    =  hiera('mysql::mysql_logs_dir',  		'/var/log/mysqllogs'),
	#Define download path for downloading mysql packages 
	$mysql_download_path	    =  hiera('mysql::mysql_download_path',	'/opt'),
	#Define download url for mysql-server 
	$mysql_server_download_url  =  hiera('mysql::mysql_server_download_url','http://dev.mysql.com/get/Downloads/MySQL-5.5/MySQL-server-5.5.37-1.linux2.6.x86_64.rpm'),
	#Define download url for mysql client 
	$mysql_client_download_url  =  hiera('mysql::mysql_client_download_url','http://dev.mysql.com/get/Downloads/MySQL-5.5/MySQL-client-5.5.37-1.linux2.6.x86_64.rpm'),
	#Define mysql server version
	$mysql_server_version	    =  hiera('mysql::mysql_server_version',	'MySQL-server-5.5.37-1.linux2.6.x86_64'),
	#Define mysql client version
	$mysql_client_version	    =  hiera('mysql::mysql_client_version',	'MySQL-client-5.5.37-1.linux2.6.x86_64'),
	#Define mysql server package 
	$mysql_server_package	    =  hiera('mysql::mysql_server_package',	'MySQL-server-5.5.37-1.linux2.6.x86_64.rpm'),
	#Define mysql client package
	$mysql_client_package	    =  hiera('mysql::mysql_client_package',	'MySQL-client-5.5.37-1.linux2.6.x86_64.rpm'),
        #Define mysql root password
        $root_password		    =  hiera('mysql::root_password',		'boxupp@123'),
	){   	   
		
	Exec { path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin',] }
  				
	package { 'mysql-libs':
		ensure 	=> 'purged',
			
		}
		
	exec { "download_mysql_server":
		cwd 	=> "$mysql_download_path",
		command => "wget '${mysql_server_download_url}'",
		unless  => "test -e ${mysql_server_package}",
		require => Package['mysql-libs'],
		timeout	=> 1200,
		}
		
	exec { "download_mysql_client":
		cwd 	=> "$mysql_download_path",
		command => "wget '${mysql_client_download_url}'",
		unless  => "test -e ${mysql_client_package}",
		require => Exec['download_mysql_server'],
		timeout	=> 600,
		}
		
	package {$mysql_server_version:
		provider => 'rpm',
		ensure	=> installed,
		source 	=> "$mysql_download_path/${mysql_server_package}",
		require => Exec['download_mysql_client'],
		}
	
	package { $mysql_client_version:
		provider => 'rpm',
		ensure	 => installed,
		source 	 => "$mysql_download_path/${mysql_client_package}",
		require	 => Package[$mysql_server_version],
		}
		
	file { "/etc/my.cnf":
        	owner 	=> "mysql", 
		group 	=> "mysql",
            	source	=> "$source_path/my.cnf",
		require	=> Package[$mysql_client_version],
		}
		
	file {"$mysql_logs_dir":
                ensure 	=> directory,
            	owner 	=> mysql, 
		group 	=> mysql,
		require	=> File["/etc/my.cnf"];
        	}

     	exec { "Open3306":
		command => "iptables -I INPUT -p tcp --dport 3306 -j ACCEPT",
		require => File["/etc/my.cnf"];
	     	}	
			 
  	service { "mysql":
        	enable => true,
            	ensure => running,
            	require => Exec["Open3306"];
        	}
        
        file { '/root/.my.cnf':
		ensure  => 'present',
		path    => '/root/.my.cnf',
		mode    => '0400',
		owner   => 'root',
		group   => 'root',
		content => template('mysql/root.my.cnf.erb'),
    		}

  	file { '/root/.my.cnf.backup':
	   	ensure  => 'present',
		path    => '/root/.my.cnf.backup',
		mode    => '0400',
		owner   => root,
		group   => root,
		content => template('mysql/root.my.cnf.backup.erb'),
		replace => false,
		before  => [Exec['mysql_root_password'],
			   Exec['mysql_backup_root_my_cnf'] ],
  		}

  	exec { 'mysql_backup_root_my_cnf':
		require => Service['mysql'],
		unless  => 'diff /root/.my.cnf /root/.my.cnf.backup',
		command => 'cp /root/.my.cnf /root/.my.cnf.backup ; true',
		before  => File['/root/.my.cnf'],
  		}


	exec { 'mysql_root_password':
		subscribe   => File['/root/.my.cnf'],
		require     => Service['mysql'],
		refreshonly => true,
		command     => "mysqladmin --defaults-file=/root/.my.cnf.backup -uroot password '${mysql::root_password}'",
  		}
         
	}

