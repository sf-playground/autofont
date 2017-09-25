#!/usr/bin/env bash
#
# push-autotools-products.sh
# Copyright (C) 2017 James T. Lee
#
# This software may be modified and distributed under the terms
# of the MIT license.  See the LICENSE file for details.
#
# Ordinarily, only the Autotools sources, like `configure.ac` and `Makefile.am`
# are stored in the repository.  However, this project is meant to be used as a
# "drop-in" to other projects, and as such should remain in a "distributable"
# format at all times.  To ensure the Autotools products, like `configure` and
# `Makefile.in` are always up-to-date, and that they're generated consistenly,
# from a known host (as opposed to whatever random environment the last
# developer was using), we commit and push the files generated from the Travis
# CI build.
#

# Print commands and die on any command failure
set -ex

# Do not push Autotools updates for builds triggered from pull requests or
# tags.  In the case of pull requests, updates will be pushed by the build
# triggered off by accepting the pull requests; in the case of tags, we should
# be tagging the updated commit in the first place.
if [[ $TRAVIS_PULL_REQUEST != 'false' || $TRAVIS_TAG != '' ]]; then
    exit 0
fi

# Forks will likely not have `GITHUB_TOKEN` set, so don't even attempt to push.
if [[ $GITHUB_TOKEN == '' ]]; then
    exit 0
fi

# Add the Autotools products as they would be distributed by `make dist`.
git add GNUmakefile.in aclocal.m4 configure install-sh missing

# Commit with a message that will not trigger another build.
git commit -F - <<END
CI: Updated autotools products

See: https://travis-ci.org/${TRAVIS_REPO_SLUG}/builds/${TRAVIS_BUILD_ID}

[ci skip]
END

# Push back to the branch that spawned the build.  If other commits were pushed
# between now and when the build was launched, this will be rejected as a
# non-fast-forward update.  That is OK, and the products will be updated by the
# next build triggered by the commit that caused it to be a non-fast-forward
# update in the first place.
#
# `GITHUB_TOKEN` is a token generated at https://github.com/settings/tokens with
# 'public_repo' access.
git push "https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" "HEAD:${TRAVIS_BRANCH}"
