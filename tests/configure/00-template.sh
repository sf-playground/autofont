#!/usr/bin/env bash
#
# TEST_NAME
# Copyright (C) YEAR YOUR_NAME
#
# This software may be modified and distributed under the terms
# of the MIT license.  See the LICENSE file for details.
#
# TEST_DESCRIPTION (Describe the specification that this script test for)
#

# Include a set of common test functions
source "$HELPERS"

# Establish expectations
expected_fontmake="$(which fontmake)"

# Perform the action under test
configure

# Read the results
source "$RESULTS"

# Validate the expectations
if [[ $expected_fontmake ]]; then
    [[ $CONFIGURE_STATUS == 0 && $FONTMAKE == $expected_fontmake ]]
else
    [[ $CONFIGURE_STATUS != 0 ]] && grep 'could not find fontmake' config.log
fi
