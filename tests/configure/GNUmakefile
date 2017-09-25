TESTS = $(sort $(patsubst %.test,%,$(wildcard *.test)))

all: $(TESTS)

$(TESTS): ../fixtures/Hack
	./run-test "$@"

.PHONY: $(TESTS)
.SILENT: $(TESTS)
