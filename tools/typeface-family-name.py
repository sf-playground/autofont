#!/usr/bin/env python
#
# Autofont -- typeface-family-name.py
# Copyright (C) 2017 James T. Lee
#
# This software may be modified and distributed under the terms
# of the MIT license.  See the LICENSE file for details.
#
# Given a list of UFO filenames, print the greatest common family name
# head, or the empty string if no common name can be found.
#
# Example:
#
# 1. Given UFOs with family names:
#   - Deja Vu Sans
#   - Deja Vu Sans Mono
#   - Deja Vu Serif
# The output would be "Deja Vu".
#
# 2. Given UFOs with family names:
#  - Hack
#  - Not Hack
# The output would be "", despite both names containing "Hack", they don't both
# begin with the same substring.
#

import sys
from itertools import takewhile
from ufoLib import UFOReader

class UFOInfo(object):
    def __init__(self, path):
        ufo = UFOReader(path)
        ufo.readInfo(self)

def main(argv):
    if len(argv) < 2:
        sys.stderr.write("Usage: %s UFO [UFO ...]\n" % argv[0])
        sys.exit(1)

    name = UFOInfo(argv[1]).familyName
    for ufo in argv[2:]:
        nextName = UFOInfo(ufo).familyName
        name = ''.join(map(lambda x: x[0],
            takewhile(lambda x: x[0] == x[1],
                zip(name, nextName))))

    print(name.strip())

if __name__ == '__main__':
    main(sys.argv)
