TESTS = $(sort $(patsubst %.test,%,$(wildcard *.test)))

all: $(TESTS)

$(TESTS):
	./run-test "$@"

.PHONY: $(TESTS)
.SILENT: $(TESTS)
