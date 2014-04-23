# Host definitions for Zookeeper nodes
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

class { 'zookeeper':
  hosts => { 'zk01.lan' => 1, 'zk02.lan' => 2, 'zk03.lan' => 3 },
  data_dir => '/var/lib/zookeeper',
}

node 'zk01' {
  class { 'zookeeper::server': }
}

node 'zk02' {
  class { 'zookeeper::server': }
}

node 'zk03' {
  class { 'zookeeper::server': }
}
