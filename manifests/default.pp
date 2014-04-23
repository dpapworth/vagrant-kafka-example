node 'zookeeper.damienpapworth.com' {
  class { 'zookeeper':
    hosts    => { 'zookeeper.damienpapworth.com' => 1 },
    data_dir => '/var/lib/zookeeper',
  }

  class { 'zookeeper::server': }
}
