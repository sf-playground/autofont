dnl
dnl autofont -- configure.ac
dnl Copyright (C) 2017 James T. Lee
dnl
dnl This software may be modified and distributed under the terms
dnl of the MIT license.  See the LICENSE file for details.
dnl

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

# Add hidden `--enable-test-results` argument to turn on results output for the
# configure unit tests.
AC_ARG_ENABLE([test-results], [],
              [AS_IF([test "x$enableval" = xyes],
                     [test_results='test/configure/results'],
                     [test_results=''])],
              [test_results=''])

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
                   have_font_ufodir='true'
                   font_ufodir="$dir"
                   break],
                  [AC_MSG_RESULT([not found])
                   have_font_ufodir='false'])
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
AS_IF([test "x$have_font_ufodir" != xtrue],
      [AC_MSG_NOTICE([no UFO sources found; fonts will not be built])])
AM_CONDITIONAL([HAVE_FONT_UFODIR], [test "x$have_font_ufodir" = xtrue])
AC_SUBST([font_ufodir], [$font_ufodir])

# Allow the path to `fontmake` to be set from an environment variable.  When it
# is set to the special value 'pip', configure will sub in a path which `make`
# knows how to resolve using pip.
AS_IF([test "x$FONTMAKE" = xpip],
      [AC_MSG_NOTICE([fontmake will be installed by pip])
       FONTMAKE=deps/bin/fontmake
       AC_SUBST([PYTHONUSERBASE], [deps])],
      [AS_IF([test "x$FONTMAKE" = x], [FONTMAKE=fontmake])
       AS_IF([AS_EXECUTABLE_P([$FONTMAKE])],
             [AC_MSG_NOTICE([using fontmake '$FONTMAKE'])],
             [requested_fontmake="$FONTMAKE"
              AS_UNSET([FONTMAKE])
              AC_PATH_PROG([FONTMAKE], [$requested_fontmake])])
       AS_IF([test "x$FONTMAKE" = x -a "x$have_font_ufodir" = xtrue],
             [AC_MSG_ERROR([could not find fontmake])])])
AC_ARG_VAR([FONTMAKE], [the path to fontmake or 'pip' to install
                        fontmake local to the build environment])

# Allow the path to `pip` to be set from an environment variable, but only fail
# if it's not found when `FONTMAKE=pip`.
AS_IF([test "x$PIP" = x], [PIP=pip])
AS_IF([AS_EXECUTABLE_P([$PIP])],
      [AC_MSG_NOTICE([using pip '$PIP'])],
      [requested_pip="$PIP"
       AS_UNSET([PIP])
       AC_PATH_PROG([PIP], [$requested_pip])])
AS_IF([test "x$PIP" = x -a "x$FONTMAKE" = xdeps/bin/fontmake],
      [AC_MSG_ERROR([could not find pip])])
AC_ARG_VAR([PIP], [the path to pip])

# Allow the path to `python` to be set from an environment variable.
AS_IF([test "x$PYTHON" = x], [PYTHON=python])
AS_IF([AS_EXECUTABLE_P([$PYTHON])],
      [AC_MSG_NOTICE([using python '$PYTHON'])],
      [requested_python="$PYTHON"
       AS_UNSET([PYTHON])
       AC_PATH_PROG([PYTHON], [$requested_python])])
AS_IF([test "x$PYTHON" = x -a "x$have_font_ufodir" = xtrue],
      [AC_MSG_ERROR([could not find python])])
AC_ARG_VAR([PYTHON], [the path to python])

# Do output
AC_CONFIG_FILES([GNUmakefile $test_results])
AC_OUTPUT
