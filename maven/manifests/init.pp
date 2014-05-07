#  Class: maven
#
#  Installs maven with java  
#
#  Parameters
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
#  [*$base_dir*]
#  Specify maven base_dir 
# 
#  [*$maven_version*]
#  Specify maven version
# 
#  [*$javaDownloadURI*]
#  Specify java download url  
#
#  [*$download_url*]
#  Specify maven download url  
#
#  [*$download_dir*]
#  Specify maven download dir path  
#  
#  Authors
#
#  Boxupp Team <http://boxupp.com/>
#
#  Copyright
#  Copyright © 2014-2015 Paxcel Technologies (p) Ltd
#  site : http://paxcel.net/   http://boxupp.com/

class maven

	(   
				#Define java_version here 
				$java_version 	= hiera('maven::java_version',	'7' ),
				#Define java_dir here 
				$java_dir  	= hiera('maven::java_dir', 	'/usr/java' ),
				$use_cache    	= hiera('maven::use_cache',   	false ),
				#Define OS platform here
				$platform     	= hiera('maven::platform',   	'x64' ),
				# Define your environment variable diectory path here.
				$env_path  	= hiera('maven::env_path',	'/root/.bash_profile'),
				# Define  maven base diectory path here.
				$base_dir 	= hiera('maven::base_dir',	'/usr/local'),
				# Define  maven version.
				$maven_version	= hiera('maven::maven_version',	'apache-maven-3.2.1'),
				# Define  maven download url.
				$download_url 	= hiera('maven::download_url',	'http://mirror.metrocast.net/apache/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz'),
				# Define  maven download dir.
				$download_dir   = hiera('maven::download_dir',  '/opt'),
				$maven_file	= hiera('maven::maven_file',  	'apache-maven-3.2.1-bin.tar.gz'),
				
	){
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
            	timeout => 600,
            
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
			
					
	exec { "download_maven":
		cwd 	=> "$download_dir",
		command => "wget '${download_url}'",
		unless  => "test -e ${maven_file}",
		require => Exec["set_env"];
		}
			
		
	exec { "extract_maven":
		cwd 	=> "$download_dir",
		command => "tar xzf '${maven_file}' -C ${base_dir}",
		unless  => "test -e ${base_dir}/${maven_version}",
		require => Exec["download_maven"],
		}	
			
			
	exec { "set_maven_home":
		command => "echo 'export M2_HOME=${base_dir}/${maven_version}' >> ${env_path}",
		unless  => "grep 'M2_HOME=${base_dir}/${maven_version}' ${env_path}",
		require => Exec["extract_maven"],	
		}
			
	exec { "set_maven_path":
		command => "echo 'export PATH=\$M2_HOME/bin:\$PATH' >> ${env_path}",
		unless  => "grep 'export PATH=\$M2_HOME/bin:\$PATH' ${env_path}",
		require => Exec["set_maven_home"],
		}
			
			
					
	exec { "set_env_maven":
		command => "bash -c 'source ${env_path}'",
		require => Exec["set_maven_path"];
         	}	

	}
