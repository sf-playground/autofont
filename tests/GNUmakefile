all: configure

configure: fixtures
	$(MAKE) -C configure

fixtures:
	$(MAKE) -C fixtures

distclean:
	$(MAKE) -C fixtures distclean

.PHONY: configure fixtures distclean
