CONFIGURE_TESTS = $(sort $(wildcard configure/*.test))
BUILD_TESTS = $(sort $(wildcard build/*.test))

all: configure build

fixtures:
	$(MAKE) -C fixtures

%.test: fixtures
	./run-test "$@"

configure: $(CONFIGURE_TESTS)

build: $(BUILD_TESTS)

distclean:
	$(MAKE) -C fixtures distclean

.PHONY: %.test configure fixtures distclean
.SILENT: $(CONFIGURE_TESTS) $(BUILD_TESTS)
