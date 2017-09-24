TESTS = $(sort $(patsubst %.sh,%,$(wildcard *.sh)))

all: $(TESTS)

$(TESTS):
	./run-test "$@"

.PHONY: $(TESTS)
.SILENT: $(TESTS)
