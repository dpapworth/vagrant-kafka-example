# Host definitions for Zookeeper and Kafka nodes
host { 'zk01.lan':
  ip => '192.168.10.10',
  host_aliases => 'zk01',
}
host { 'zk02.lan':
  ip => '192.168.10.11',
  host_aliases => 'zk02',
}
host { 'zk03.lan':
  ip => '192.168.10.12',
  host_aliases => 'zk03',
}
host { 'kafka01.lan':
  ip => '192.168.10.13',
  host_aliases => 'kafka01',
}
host { 'kafka02.lan':
  ip => '192.168.10.14',
  host_aliases => 'kafka02',
}

node 'zk01' {
  class { 'zookeeper':
    hosts => { 'zk01.lan' => 1, 'zk02.lan' => 2, 'zk03.lan' => 3 },
    data_dir => '/var/lib/zookeeper',
  }

  class { 'zookeeper::server': }
}

node 'zk02' {
  class { 'zookeeper':
    hosts => { 'zk01.lan' => 1, 'zk02.lan' => 2, 'zk03.lan' => 3 },
    data_dir => '/var/lib/zookeeper',
  }

  class { 'zookeeper::server': }
}

node 'zk03' {
  class { 'zookeeper':
    hosts => { 'zk01.lan' => 1, 'zk02.lan' => 2, 'zk03.lan' => 3 },
    data_dir => '/var/lib/zookeeper',
  }

  class { 'zookeeper::server': }
}

node 'kafka01' {
  class { 'kafka':
    broker_id => '1',
    zookeeper_connect => 'zk01.lan:2181,zk02.lan:2181,zk03.lan:2181',
  }
}

node 'kafka02' {
  class { 'kafka':
    broker_id => '2',
    zookeeper_connect => 'zk01.lan:2181,zk02.lan:2181,zk03.lan:2181',
  }
}

