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
into your porject.

Autofont expects to live in a directory in the root of your project.  The
directory can be named anything (e.g. `autofont`, `tools`, `build`).  The UFO
files should either be in the project root, or a directory called `src` or
`source`, to be automatically detected.

To update your copy of Autofont as a subtree, run:

```
> git subtree pull --prefix autofont https://github.com/source-foundry/autofont.git master --squash
```

### Autofont as an External Tool

### Preconfiguring Autofont

## Developers
