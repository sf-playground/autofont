#!/usr/bin/env python
#
# Autofont -- typeface-property.py
# Copyright (C) 2017 James T. Lee
#
# This software may be modified and distributed under the terms
# of the MIT license.  See the LICENSE file for details.
#

import sys
from ufoLib import UFOReader

class UFOInfo(object):
    def __init__(self, path):
        ufo = UFOReader(path)
        ufo.readInfo(self)

def main(argv):
    if len(argv) < 2:
        sys.stderr.write("Usage: %s PROPERTY UFO\n" % argv[0])
        sys.exit(1)

    print(getattr(UFOInfo(argv[2]), argv[1]))

if __name__ == '__main__':
    main(sys.argv)
