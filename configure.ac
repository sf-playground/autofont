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

dnl Initialize automake as a non-GNU standard (i.e. "foreign") project
AM_INIT_AUTOMAKE([foreign])

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
       AS_IF([test "x$FONTMAKE" = x],
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
AS_IF([test "x$PYTHON" = x],
      [AC_MSG_ERROR([could not find python])])
AC_ARG_VAR([PYTHON], [the path to python])

# Do output
AC_CONFIG_FILES([GNUmakefile tests/configure/results])
AC_OUTPUT
