#
# autofont -- Legacy Makefile
# Copyright (C) 2017 James T. Lee
#
# This software may be modified and distributed under the terms
# of the MIT license.  See the LICENSE file for details.
#
# All of this project's core rules are defined in GNUmakefiles which are picked
# up first by GNU make.  When invoked non-GNU make, this file will be read, a
# message noting the GNU make requirement is printed, and then the target is
# reexecuted with gmake.
#

.DEFAULT:
	@echo "This project requires GNU make.  Attempting to make '$@' using gmake..."
	gmake $@
