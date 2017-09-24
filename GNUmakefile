#
# autofont -- Pre-configure Makefile
# Copyright (C) 2017 James T. Lee
#
# This software may be modified and distributed under the terms
# of the MIT license.  See the LICENSE file for details.
#
# This makefile may be overwritten by configure.  That is OK.  The point of
# this makefile is to tell users to run configure, and to expose a target for
# running tests, which shouldn't be run in a configured environment.
#

.DEFAULT:
	@echo "Run 'configure' first."
	@false

all: .DEFAULT

test:
	$(MAKE) -C tests

.PHONY: test
