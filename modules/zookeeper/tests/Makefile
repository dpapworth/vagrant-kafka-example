MANIFESTS=zookeeper.po server.po
TESTS_DIR=$(dir $(CURDIR))
MODULE_DIR=$(TESTS_DIR:/=)
MODULES_DIR=$(dir $(MODULE_DIR))

all:	test

test: $(MANIFESTS) 

%.po:	%.pp
	puppet apply --noop --modulepath $(MODULES_DIR) $<
