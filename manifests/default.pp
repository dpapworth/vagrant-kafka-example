node 'zk01' {
  class { 'avahi': }

  class { 'zookeeper':
    hosts => { 'zk01.local' => 1, 'zk02.local' => 2, 'zk03.local' => 3 },
    data_dir => '/var/lib/zookeeper',
  }

  class { 'zookeeper::server': }
}

node 'zk02' {
  class { 'avahi': }

  class { 'zookeeper':
    hosts => { 'zk01.local' => 1, 'zk02.local' => 2, 'zk03.local' => 3 },
    data_dir => '/var/lib/zookeeper',
  }

  class { 'zookeeper::server': }
}

node 'zk03' {
  class { 'avahi': }

  class { 'zookeeper':
    hosts => { 'zk01.local' => 1, 'zk02.local' => 2, 'zk03.local' => 3 },
    data_dir => '/var/lib/zookeeper',
  }

  class { 'zookeeper::server': }
}

node 'kafka01' {
  class { 'avahi': }

  class { 'kafka':
    broker_id => '1',
    zookeeper_connect => 'zk01.local:2181,zk02.local:2181,zk03.local:2181',
  }
}

node 'kafka02' {
  class { 'avahi': }

  class { 'kafka':
    broker_id => '2',
    zookeeper_connect => 'zk01.local:2181,zk02.local:2181,zk03.local:2181',
  }
}

