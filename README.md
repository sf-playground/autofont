[![Build Status](https://travis-ci.org/source-foundry/autofont.svg?branch=master)](https://travis-ci.org/source-foundry/autofont)

# ![Autofont](autofont.svg "Autofont Logo")

Autofont is a set of build and release tools for building fonts from UFO
sources.  It is based on
[Autoconf](https://www.gnu.org/software/autoconf/autoconf.html) and
[Automake](https://www.gnu.org/software/automake/) and aims to be portable and
easy to use.  Use Autofont to be able to customize a source font at build time,
and worry less about build dependencies.

## Contents

1. [Users](#users)
2. [Designers](#designers)
3. [Developers](#developers)

## Users

If you have downloaded font source code that contains this set of build tools,
you will be able to compile and install this font like a lot of open-source
software, and with a minimum of build dependencies.

You need a POSIX-ish environment like Linux, macOS, or
[Cygwin](https://www.cygwin.com/), containing at least:

* Bourne shell
* GNU make
* Python 2.7 or greater

Optionally, you will need:

* [fontmake](https://github.com/googlei18n/fontmake)
* [ufoLib](https://github.com/unified-font-object/ufoLib)
* [ttfautohint](https://www.freetype.org/ttfautohint/)

If these dependencies are not available in standard locations, or you do not
want to build/install them, you can supply the Autofont `configure` script with
the `--enable-build-dependencies` argument to download and install them local
to the build.

A typical build looks like:

```
> autofont/configure
> gmake
> gmake install   # optionally install the fonts to the OS's font directory
```

### `configure` Options

* `--enable-build-dependencies`: Installs build dependencies automatically so
  you don't have to.
* `--with-font-srcdir=DIR`: Build fonts from this root `DIR`.  If Autofont is
  built into the project you are attempting to build, you do not need to
  provide this argument.
* `--with-font-ufodirname=DIRNAME`: The name of the directory within the font
  "srcdir" that contains the `.ufo` source data.  By default, Autofont will
  search directories called `.`, `src`, and `source`.  The font project authors
  should have either already complied with this convention or preconfigured
  this setting so you don't have to worry about it.
* `--with-installdir=DIR`: The directory where the compiled font should be
  installed when running `gmake install`.  The configure script attempts to
  detect the correct installation directory based on your operating system.

*more to come...*

### `gmake` Targets

* `all` *(default)*: Build the font as configured, usually resulting in hinted
  TTFs.
* `install`: Install the font files to the operating system font directory, or
  the directory specified by the `--with-installdir` configure option.
* `uninstall`: The reverse of `install`.
* `dist`: Make a distributable source font and tools release archive called
  `<typeface_family_name>-<version>.tar.gz`.
* `clean`: Remove any build targets and intermediate files, usually in
  preparation to be rebuilt.
* `distclean`: Also remove any build dependencies, like fontmake and
  ttfautohint, if they have been installed by Autofont.

*more to come...*

### Separate Build Directories

You can maintain several independent build trees in parallel.  You may want to
do this if you want to build fonts with different sets of options.  Simply make
and change to a new directory before running the `configure` script:

```
> mkdir build1 && cd build1
> ../autofont/configure --configure-options-for-build1
> gmake
> cd ..
> mkdir build2 && cd build2
> ../autofont/configure --configure-options-for-build2
> gmake
```

### Per-Platform Guidance

Autofont is highly portable.  Find specific instructions for setting up a build
environment for your platform below.

#### Debian/Ubuntu

*TODO: Document what to `apt install`*

#### Red Hat/Fedora

*TODO: Document what to `yum/dnf install`*

#### Windows/Cygwin

*TODO: Document packages to select from setup.exe*

#### macOS

*TODO: Document requirements for GNU make and GCC (xcode?)*

## Designers

If you design or maintain a typeface based on the [Unified Font Object
(UFO)](http://unifiedfontobject.org/) source format, you can integrate Autofont
into your project for a turn-key build and distribution solution.
Alternatively, use Autofont along side your project for an easy way to get
started without any commitment.

### Autofont as a Drop-In

Autofont is always built and ready to be integrated into your source font
project.  If you use Git, consider using a
[subtree](https://www.atlassian.com/blog/git/alternatives-to-git-submodule-git-subtree)
to pull in Autofont.

```
> cd your/font/project_root
> git subtree add --prefix autofont https://github.com/source-foundry/autofont.git master --squash
> git push
```

If you do not use Git, simply download a [release
archive](https://github.com/source-foundry/autofont/releases) and unpack it
into your project.

Autofont expects to live in a directory in the root of your project.  The
directory can be named anything (e.g. `autofont`, `tools`, `build`).  The UFO
files should either be in the project root, or a directory called `src` or
`source`, to be automatically detected.

To update your copy of Autofont as a subtree, run:

```
> git subtree pull --prefix autofont https://github.com/source-foundry/autofont.git master --squash
```

### Autofont as an External Tool

You can experiment with Autofont without integrating it into your project.
Simply clone or extract an Autofont release anywhere, then run the Autofont
`configure` script with the argument `--with-font-srcdir` pointing to your font
project source directory.  For example:

```
> cd your/font/project_root
> ~/autofont/configure --with-font-srcdir=.
> gmake
```

You can supply any other valid Autofont configure options that you want.

### Preconfiguring Autofont

## Developers
