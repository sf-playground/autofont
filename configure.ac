dnl
dnl autofont -- configure.ac
dnl Copyright (C) 2017 James T. Lee
dnl
dnl This software may be modified and distributed under the terms
dnl of the MIT license.  See the LICENSE file for details.
dnl

dnl Load local macros from `m4` directory
AC_CONFIG_MACRO_DIRS([m4])

dnl Initialize autoconf--this macro can only take static strings, except for
dnl the version number, which can be set from a call to `m4_esyscmd`.
AC_INIT([autofont], [0.1.0], [https://github.com/source-foundry/autofont/issues])

# When configure is run in the directory it lives in, it breaks VPATH builds
# (including the autofont unit tests) until `make distclean` is run.  Given
# that autofont will be mostly used as a subdirectory in a font project anyway,
# most people will be running it from a separate directory anyway, so just
# enforce that usage pattern.
AS_IF([test "x$srcdir" = x.],
      [AC_MSG_ERROR([create a build directory and run configure from there])])

dnl Determine the host system type or allow it to be set
AC_CANONICAL_HOST

dnl Initialize automake as a non-GNU standard (i.e. "foreign") project
AM_INIT_AUTOMAKE([foreign])

dnl Disable maintainer mode by default.
dnl Maintainer mode is a setting which triggers autoconf/automake rebuilds
dnl whenever the configure.ac file is newer than configure or Makefile.am is
dnl newer than Makefile.in.  Because autofont stores everything in Git, this
dnl mode can have trouble resolving the timestamps properly, triggering
dnl spurious rebuilds.
dnl See: https://www.gnu.org/software/automake/manual/html_node/maintainer_002dmode.html
AM_MAINTAINER_MODE

# Add switch to enable compiling/installing missing dependencies to the local
# build path in a best-effort fashion.  Generally, build dependencies are
# considered external concerns, but to make this as easy as possible, we will
# pull in what we can.
AC_ARG_ENABLE([build-dependencies],
              [AS_HELP_STRING([--enable-build-dependencies],
                              [install/compile missing dependencies])],
              [AS_IF([test "x$enableval" = xyes],
                     [build_dependencies='true'
                      AC_SUBST([PYTHONUSERBASE], [`pwd`/deps])
                      export PYTHONUSERBASE])])

# Expose a configure argument, --with-font-srcdir, that can be used to specify
# the root of the font project.  If left unspecified, use the parent of the
# directory containing the configure script, under the assumption that autofont
# is just a subdirectory in a font project, like:
#
#   font_project/autofont/configure
#   font_project/src/*.ufo
#
AC_ARG_WITH([font-srcdir],
            [AS_HELP_STRING([--with-font-srcdir=DIR],
                            [build from font project root at DIR [SRCDIR/..]])],
            [font_srcdir="$withval"],
            [font_srcdir="${srcdir}/.."])
AC_SUBST([font_srcdir], [$font_srcdir])

dnl Define a macro that takes a list of directories and finds the first one
dnl that contains any *.ufo sources, and sets 'font_ufodir' to that directory.
AC_DEFUN([CHECK_FONT_UFODIRS],
         [for dir in m4_flatten([$1]); do
            AC_MSG_CHECKING([$dir for UFO sources])
            AS_IF([(cd -L "$dir" && ls *.ufo) > /dev/null 2>&1],
                  [AC_MSG_RESULT([found])
                   AC_SUBST([font_ufodir], [`cd -L "$dir" && pwd`])
                   break],
                  [AC_MSG_RESULT([not found])])
          done])

# Expose a configure argument, --with-font-ufodirname, that can be used to
# specify the name of the directory under font_srcdir that contains the UFO
# source files.  If left unspecified, configure will search the font_srcdir
# itself, and subdirectories 'src' and 'source' for UFO files.
AC_ARG_WITH([font-ufodirname],
            [AS_HELP_STRING([--with-font-ufodirname=DIRNAME],
                            [build from UFO sources in FONT_SRCDIR/DIRNAME
                             [`.', `src', or `source']])],
            [CHECK_FONT_UFODIRS(["${font_srcdir}/${withval}"])],
            [CHECK_FONT_UFODIRS(["$font_srcdir"
                                 "${font_srcdir}/src"
                                 "${font_srcdir}/source"])])
AS_IF([test "x$font_ufodir" = x],
      [AC_MSG_NOTICE([no UFO sources found; fonts will not be built])])
AM_CONDITIONAL([HAVE_FONT_UFODIR], [test "x$font_ufodir" != x])


#
# Everything in the block that follows will only be performed if we acutally
# have a font to configure.
#
AS_IF([test "x$font_ufodir" != x], [

# Allow the path to `fontmake` to be set from an environment variable.
AS_IF([test "x$FONTMAKE" = x], [FONTMAKE=fontmake])
AS_IF([AS_EXECUTABLE_P([$FONTMAKE])],
      [AC_MSG_NOTICE([using fontmake '$FONTMAKE'])],
      [requested_fontmake="$FONTMAKE"
       AS_UNSET([FONTMAKE])
       AC_PATH_PROG([FONTMAKE], [$requested_fontmake])])
AS_IF([test "x$FONTMAKE" = x],
      [AS_IF([test "x$build_dependencies" = xtrue],
             [AC_MSG_NOTICE([fontmake will be installed with pip by make])
              FONTMAKE=deps/bin/fontmake
              need_pip=true],
             [AC_MSG_ERROR([could not find fontmake])])])
AC_ARG_VAR([FONTMAKE], [the fontmake name or path to build with])

# Allow the path to `python` to be set from an environment variable.
AS_IF([test "x$PYTHON" = x], [PYTHON=python])
AS_IF([AS_EXECUTABLE_P([$PYTHON])],
      [AC_MSG_NOTICE([using python '$PYTHON'])],
      [requested_python="$PYTHON"
       AS_UNSET([PYTHON])
       AC_PATH_PROG([PYTHON], [$requested_python])])
AS_IF([test "x$PYTHON" = x],
      [AC_MSG_ERROR([could not find python])])
AC_ARG_VAR([PYTHON], [the python name or path to build with])

# Check for ufoLib.  This will be used by configure to read the source font
# information and make configuration-time decisions based on it.  Thus, it is
# required if we've detected UFOs.  If we don't detect ufoLib, and the
# --enable-build-dependencies argument is set, then configure will check for
# pip and install ufoLib later.
AS_IF([test "x$build_dependencies" != xtrue],
      [need_ufoLib=true])
AX_PYTHON_MODULE([ufoLib], [$need_ufoLib])
AS_IF([test "x$HAVE_PYMOD_UFOLIB" = xno],
      [AC_MSG_NOTICE([ufoLib will be installed with pip later during configuration])
       need_pip=true])

# Check for pip.  If it doesn't exist, it is only fatal if `fontmake` or
# `ufoLib` is expected to be installed by pip (i.e., the `need_pip` variable is
# defined).
AX_PYTHON_MODULE([pip], [$need_pip])

# Install ufoLib, if necessary, using pip to a build-local directory called
# `deps` (based on the `PYTHONUSERBASE` environment variable).
AS_IF([test "x$HAVE_PYMOD_UFOLIB" = xno],
      [AC_MSG_NOTICE([installing ufoLib with pip])
       AC_RUN_LOG(["$PYTHON" -m pip install --user ufoLib >&2])
       AX_PYTHON_MODULE([ufoLib], [required])])
AC_SUBST([HAVE_PYMOD_UFOLIB])

# Detect the typeface family name from the UFO sources.  UFOs only define the
# font family name, or typeface name.  Projects should be able to deliver
# multiple typefaces, as long as they are part of the same family, which is
# determined by whether the names all start with the same substring.
AC_MSG_CHECKING([for the source typeface family name])
source_typeface_family="`"$PYTHON" "${srcdir}/tools/typeface-family-name.py" "$font_ufodir"/*.ufo 2>&5`"
AS_IF([test $? -eq 0 -a "x$source_typeface_family" != x],
      [AC_MSG_RESULT([$source_typeface_family])],
      [AC_MSG_RESULT([not found])
       AC_MSG_ERROR([could not detect typeface family name])])
AC_SUBST([source_typeface_family], [$source_typeface_family])

# Transform 'Font Name' -> 'font-name', for use in unix style directory names.
source_typeface_family_lc="`echo "$source_typeface_family" | tr 'A-Z ' 'a-z-'`"
AC_SUBST([source_typeface_family_lc], [$source_typeface_family_lc])

# Detect the typeface version from the UFO sources.
AC_MSG_CHECKING([for the source typeface version])
source_typeface_version_major="`"$PYTHON" "${srcdir}/tools/typeface-property.py" versionMajor "$font_ufodir"/*.ufo 2>&5`"
source_typeface_version_minor="`"$PYTHON" "${srcdir}/tools/typeface-property.py" versionMinor "$font_ufodir"/*.ufo 2>&5`"
source_typeface_version="`printf '%d.%03d' "$source_typeface_version_major" "$source_typeface_version_minor"`"
AC_MSG_RESULT([$source_typeface_version])
AC_SUBST([source_typeface_version], [$source_typeface_version])

]) # AS_IF([test "x$ufo_dir" != x])

# Expose a configure argument to set the font installation directory or disable
# installation.  If unspecified, try to choose a reasonable default based on
# the **host** (target) operating system (not necessarily the **build**
# operating system).  If a default can't be chosen, installation is disabled.
#
# TODO: Set default paths for darwin (macos?), cygwin, mingw32 hosts
AC_ARG_WITH([installdir],
            [AS_HELP_STRING([--with-installdir=DIR],
                            [install the fonts to DIR])],
            [AS_IF([test "x$withval" != xno], [installdir="$withval"])],
            [AS_CASE([$host_os],
                     [linux*], [installdir="\${datadir}/fonts/\${source_typeface_family_lc}"],
                               [AC_MSG_NOTICE([unsupported OS $host_os; installation will be disabled])])])
AC_SUBST([installdir], [$installdir])
AM_CONDITIONAL([HAVE_INSTALLDIR], [test "x$installdir" != x])

# Do output
AC_CONFIG_FILES([GNUmakefile])
AS_IF([test "x$TESTING" = xtrue], [AC_CONFIG_FILES([test/configure/results])])
AC_OUTPUT
