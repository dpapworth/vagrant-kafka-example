class kafka(
  $broker_id = '0',
  $zookeeper_connect = 'localhost:9192',
  $install_dir = '/opt/kafka_2.9.1-0.8.1',
) {

  # Set default exec path for this module
  Exec { path    => ['/usr/bin', '/usr/sbin', '/bin'] }

  # Create kafka user and group
  group { 'kafka':
    ensure => present,
  }
  user { 'kafka':
    ensure => present,
    gid => 'kafka',
    home => "$install_dir",
    shell => '/bin/bash',
    require => Group['kafka']
  }

  file { '/tmp/kafka_2.9.1-0.8.1.tgz':
    source => 'puppet:///modules/kafka/kafka_2.9.1-0.8.1.tgz',
  }

  # Unpack Kafka
  exec { 'extract_kafka':
    cwd     => '/opt/',
    command => 'tar -xf /tmp/kafka_2.9.1-0.8.1.tgz',
    creates => "$install_dir",
    require => File['/tmp/kafka_2.9.1-0.8.1.tgz'],
  }

  file { "$install_dir":
    owner => 'kafka',
    group => 'kafka',
    recurse => true,
    require => Exec['extract_kafka'],
  }

  # Update server.properties
  file { '/etc/kafka':
    owner => 'kafka',
    group => 'kafka',
    ensure => directory,
  }

  file { '/etc/kafka/server.properties':
    owner => 'kafka',
    group => 'kafka',
    content => template('kafka/server.properties.erb'),
    require => File['/etc/kafka'],
  }

  file { '/etc/init.d/kafka-broker':
    mode => 0744,
    content => template('kafka/kafka-broker.erb'),
    require => File['/etc/kafka/server.properties'],
  }

  # Set links depending on osfamily or operating system fact
  case $::osfamily {
    Debian: {
      # Install scala
      package { 'scala':
        ensure => '2.9.1.dfsg-3',
      }

      service { 'kafka-broker':
        ensure => running,
        enable => true,
        require => [
          Package['scala'],
          File['/etc/init.d/kafka-broker'],
        ]
      }
    }
    default: { fail('Unsupported OS') }
  }

}
