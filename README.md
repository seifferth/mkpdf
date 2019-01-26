# mkpdf

This is a simple command line wrapper around pandoc and latexmk written in
shell script and tested with both bash and dash, so it should hopefully be
POSIX-compliant. It will generate pdf output from one or more files written in
pandoc's markdown using a specified template.


## Installing

### Arch Linux

There is a package in the AUR, so use something like `pacaur -S mkpdf`

### Debian

Run `make deb` to create a package for debian. Or just download an
already-built package from the releases page. To build the debian package,
the following additional dependencies need to be satisfied:

- dpkg
- fakeroot

### Ubuntu or Linux Mint

Preliminary testing suggests the Debian package will also work on these two
Debian-based distributions. Please feel free to contact me if you encounter
any problems.

### Manual Installation

Add the following files to your PATH and make sure they are executable:

- mkpdf
- furbishtex (optional postprocessor)
    * If furbishtex is found in your PATH and executable, it will be called
      before running latexmk. See ``furbishtex -h`` for further explanation.
    * for furbishtex to do something you will also want to
      move ``default.sed`` to ``/usr/share/furbishtex`` or
      at least to ``$HOME/.furbishtex`` for a user-specific
      installation

A manpage (`mkpdf.1.gz`) can be generated from [docs.md](docs.md) using
`make man`. This file usually has to be moved to `/usr/share/man/man1` to make
it globally available.

Install instructions are also contained in the makefile, so you can also
run `sudo make install` to set everything up.


## Dependencies

The main dependencies are:

- pandoc
- latexmk
- texlive (or probably even some other latex distribution)
- biber (if any bibliography is to be resolved)

Also some basic command line utils are used, but these should be included
in every GNU/Linux system by default. Please drop me a message, if this is
not the case.

### Automated Language Detection

Mkpdf can make use of the python [langdetect
library](https://pypi.python.org/pypi/langdetect) to automatically detect the
language used in a document -- which is done in case `lang` is neither specified
via metadata nor via the command line. This information is then used for
hyphenation, citations etc. To use this feature, make sure python 3.x is
installed and `python3` is executable and in your `PATH`. You will also have to
install `langdetect` -- e. g. via pip or pip3 (running `pip install --user
langdetect`). If either python3 or langdetect are missing, mkpdf will simply
skip language detection.

## Usage (v0.3.1)

```
Usage: mkpdf [options] <directory>
   Or: mkpdf [options] <files>

Options:
  -c  --clean           Remove temporary files before running
                        latexmk
  -d  --debug           Do not hide latexmk's output
  -o  --output          Specify a name for the output file
  -p  --preview         Open pdf once generated
  -t  --template        Specify a template to use with pandoc
  -h  --help            Print this help message and exit

Pandoc-Options:
  -M  --metadata        These options will be passed on to pandoc.
                        Please refer to pandoc's documentation for
                        further information on what they do.

Specifying templates:
    If no template is set from the command line, mkpdf will check
    metadata from input files for a field named 'template' and use
    it's value as the template name. If multiple templates are
    specified, any but the first one will be ignored.
```

Further information can be found in [docs.md](docs.md), which can also be used
to generate a manpage.
