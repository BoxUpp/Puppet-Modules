# Class: tomcat
#
#  Install and configure tomcat with java  
#
#  Parameters
#
#  [*$source_path*]
#  The is the directory from  where the tomcat module will get its setup files and configurations
# 
#  [*$java_version*]
#  The parameter checks version of java i.e java 1.7  or java 1.8 
# 
#  [*$java_dir*]
#  The is the base directory on which java is deployed.
# 
#  [*$platform*]
#  This parameter takes input from the user to check machine platform i.e x86 bit or x64 bit.
# 
#  [*$env_path*]
#  The is the parameter which sets java path.
# 
#  [*$tomcat_version*]
#  Specify tomcat version which you want to install  
# 
#  [*$tomcat_path*]
#  Specify tomcat path 
# 
#  [*$javaDownloadURI*]
#  Specify java download url  
#  
#  Authors
#
#  Boxupp Team <http://boxupp.com/>
#
#  Copyright
#  Copyright © 2014-2015 Paxcel Technologies (p) Ltd
#  site : http://paxcel.net/   http://boxupp.com/

 class tomcat		
 			(
			#Define java_version here . 7 or 8 
			$java_version 	= hiera('tomcat::java_version',	'8' ),
			#Define java_dir here 
			$java_dir  		= hiera('tomcat::java_dir', 	'/usr/java' ),
			$use_cache    	= hiera('tomcat::use_cache',   	false ),
			#Define OS platform here
			$platform     	= hiera('tomcat::platform',   	'x64' ),
			# Define your source diectory path here.
			$source_path 	= hiera('tomcat::source_path',	'/vagrant/modules/tomcat/files' ),
			# Define your environment variable diectory path here.
			$env_path  		= hiera('tomcat::env_path',	'/etc/profile.d/java.sh'),
			# Define  tomcat diectory path here.
			$tomcat_path    = hiera('tomcat::tomcat_path',	'/usr/tomcat'),
			# Define  tomcat version. 7 or 8 
			$tomcat_version = hiera('tomcat::tomcat_version','8'),
			)
			{

    # Setting default exec path for this module
    Exec { path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin',] }

	file {"$java_dir":
       		ensure 	=> directory,
       		owner 	=> root, 
        	group 	=> root,						
        }

	case $platform {
	'x64': {
	$plat_filename = 'x64'
		}
    	'x86': {
            $plat_filename = 'i586'
        }
    	default: {
            fail("Unsupported platform: ${platform}.  Implement me?")
        }
    }

    case $java_version {
       	'8': {
           $javaDownloadURI = "http://download.oracle.com/otn-pub/java/jdk/8-b132/jdk-8-linux-${plat_filename}.tar.gz"
           $java_home = "${java_dir}/jdk1.8.0"
        }
       	'7': {
       	 $javaDownloadURI = "http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-${plat_filename}.tar.gz"
       	 $java_home = "${java_dir}/jdk1.7.0"
       }
       	default: {
           fail("Unsupported java_version: ${java_version}.  Implement me?")
        }
    }

    	$installerFilename = inline_template('<%= File.basename(@javaDownloadURI) %>')

    	if ( $use_cache ){
       	notify { 'Using local cache for oracle java': }
        		
        file { "${java_dir}/${installerFilename}":
            	source  => "puppet:///modules/tomcat/${installerFilename}",
        }
        
        exec { 'get_jdk_installer':
           	cwd     => $java_dir,
		creates => "${java_dir}/jdk_from_cache",
           	command => 'touch jdk_from_cache',
           	require => File["${java_dir}/jdk-${java_version}-linux-x64.tar.gz"],
        }
      	} else {
        exec { 'get_jdk_installer':
           	cwd     => $java_dir,
           	creates => "${java_dir}/${installerFilename}",
           	command => "wget -c --no-cookies --no-check-certificate --header \"Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com\" --header \"Cookie: oraclelicense=accept-securebackup-cookie\" \"${javaDownloadURI}\" -O ${installerFilename}",
           	timeout => 1200,
        }
       
	   file { "${java_dir}/${installerFilename}":
           	mode    => '0755',
		owner 	=> root, 
		group 	=> root,
           	require => Exec['get_jdk_installer'],
        	}
    }

    	if ( $java_version in [ '7', '8' ] ) {
        exec { 'extract_jdk':
           	cwd     => "${java_dir}/",
           	command => "tar -xf ${installerFilename}",
           	creates => $java_home,
           	require => Exec['get_jdk_installer'],
        	}
    }

	if ( $java_version in [ '7', '8' ] ) {
	exec { "set_java_home":
		command => "echo 'export JAVA_HOME=${java_home}'>> ${env_path}",
		unless  => "grep 'JAVA_HOME=${java_home}' ${env_path}",
		require => Exec["extract_jdk"],
		}
     }

	exec { "java_path":
		command => "echo 'export PATH=\$JAVA_HOME/bin:\$PATH' >> ${env_path}",
		unless  => "grep 'export PATH=\$JAVA_HOME/bin:\$PATH' ${env_path}",
		require => Exec["set_java_home"],
		}

	exec { "set_env":
		command => "bash -c 'source ${env_path}'",
		require => Exec["java_path"];
		}

	file {"$tomcat_path":
            	ensure	=> directory,
            	owner 	=> root, 
		group 	=> root,
		require => Exec["set_env"];
		}

	case $tomcat_version {
	'8': {
            	$tomcatDownloadURI 	= "http://apache.osuosl.org/tomcat/tomcat-8/v8.0.9/bin/apache-tomcat-8.0.9.tar.gz"
            	$web_home 		= "${tomcat_path}/apache-tomcat-8.0.9"
		$tomcat_file_name	= "apache-tomcat-8.0.9"
	}
	'7': {
		$tomcatDownloadURI 	= "http://mirror.metrocast.net/apache/tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54.tar.gz"
		$web_home 		= "${tomcat_path}/apache-tomcat-7.0.54"
		$tomcat_file_name	= "apache-tomcat-7.0.54"
	}
	default: {
            	fail("Unsupported tomcat_version: ${tomcat_version}.  Implement me?")
		}
	}	
		
		
	if ( $tomcat_version in [ '7', '8' ] ) {	
	exec { 'get_tomcat':
            	cwd     => $tomcat_path,
            	command => "wget ${tomcatDownloadURI}",
		unless  => "test -e ${tomcat_file_name}.tar.gz",
            	timeout => 1200,
		require => File["$tomcat_path"],
		}	
	}
		
	if ( $tomcat_version in [ '7', '8' ] ) {
	exec { 'extract_tomcat':
            	cwd => "${tomcat_path}/",
            	command => "tar xzf ${tomcat_file_name}.tar.gz",
            	creates => $web_home,
		unless  => "test -e ${tomcat_file_name}",
            	require => Exec['get_tomcat'],
		}
	}

	if ( $tomcat_version in [ '7', '8' ] ) {
	file { "/etc/init.d/tomcat":
		mode    => '777',
		owner   => root,
		group   => root,
		content => template('tomcat/tomcat.erb'),
		backup  => false,
		require => Exec['extract_tomcat'],
		} 
	}

		
}
		
		
