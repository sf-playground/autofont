CONFIGURE_TESTS = $(sort $(wildcard configure/*.test))

all: configure

fixtures:
	$(MAKE) -C fixtures

%.test: fixtures
	./run-test "$@"

configure: $(CONFIGURE_TESTS)

distclean:
	$(MAKE) -C fixtures distclean

.PHONY: %.test configure fixtures distclean
.SILENT: $(CONFIGURE_TESTS)
