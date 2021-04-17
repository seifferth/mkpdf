# Name

mkpdf - A simple wrapper around pandoc and latexmk

# Synopsis

```
mkpdf [options] <directory>
mkpdf [options] <files>
```

# Description

Mkpdf is a wrapper around pandoc and latexmk that aims at simplifying the
generation of pdfs from plain text files written in a markup language which
pandoc understands, such as pandoc's own variant of markdown.


# Options

-c, \--clean
: Remove the relevant temporary files before running latexmk. If `-c` is
specified as the only option, all temporary files will be removed.

-d, \--debug
: Print latexmk's output directly to stdout.

-o FILENAME, \--output=FILENAME
: Specify a name for the output file. If this option is specified multiple
times, all but the first one will be ignored.

-p, \--preview
: Open the output file after it has been generated, using the system's default
pdf viewer.

-t FILENAME, \--template=FILENAME
: Specify a template to use with pandoc. If this option is specified multiple
times, all but the first one will be ignored.

-h, \--help
: Print a short help message and exit.

## Pandoc-Options

The following options will be passed on to pandoc. Please refer to pandoc's
documentation for further information.

-M KEY[=VAL], \--metadata=KEY[:VAL]
: Specify metadata fields directly from the command line, such as `-M lang=en`
or `--metadata="lang:en"`.


# Templates

Pandoc uses templates, which act as a sort of frame in which the converted
markup content (in this case, the latex code) is embedded. Templates can either
be specified using relative or absolute paths or using only the name, if the
template is located at one of the places where pandoc looks for templates by
default. I.\ e.\ in `/usr/share/pandoc/data/templates` for globally available
templates or in `~/.pandoc/templates` for templates available only for specific
users. Further information on pandoc templates can be found in pandoc's
documentation.

It is also worth noting that, by default, mkpdf will turn off pandoc's
heuristics for determining the top-level-division of a latex document
and thus ensure that pandoc produces `\section{foo}` as the topmost
sectioning element. Template authors are encouraged to redefine latex
sectioning commands as the see fit.

## LaTeX Engine

Mkpdf uses `xelatex` as the default engine when invoking latexmk. It is
possible, however, to specify a custom engine via a so-called magic line in a
way known from LaTeX IDEs such as TeXworks or TeXstudio. A magic line is a
LaTeX comment (prefixed with `%`) that must be included in the template itself
and is often found in one of the first lines. Mkpdf currently allows you to
specify either one of `xelatex`, `lualatex` or `pdflatex` as the LaTeX engine
to use. To use `lualatex` with a specific template, for example, you would have
to include the following line somewhere in that template:

```
%!TEX program=lualatex
```

# Directory Mode

Mkpdf allows you to specify an entire directory as input. In fact, if mkpdf is
invoked without any file or directory name as input, it will default to using
the current working directory. This directory must contain a file named
`toc.conf`, which is used to point to other files and may optionally contain
metadata blocks. Filenames are specified relative to the directory where
`toc.conf` is located in and must not contain whitespace. Comments can be
included by prefixing lines or parts of lines with `#`. An example `toc.conf`
could look like this:

```
---
author: John Doe
title: Some example document
template: default.latex
...

# Intro
intro.txt

# Chapters
ch1/part1.txt
ch1/part2.md    # This is also a comment

ch2.txt

---
bibliography:
  - bibfile1.bib
  - bibfile2.bib
---
```

# Bibliography Mode

If input files specified from the command line are BibTeX or BibLaTeX files,
mkpdf will generate a pdf containing only a bibliography. In this case pandoc's
`biblio-title` variable will be set to a non-breaking-space, so that there
should be no bibliography-specific heading in the output pdf. If no title is
specified for the document, the input filenames will be used instead. Custom
values for `title`, `author` or `date` may be specified from the command line
using the `-M` / `--metadata` switch. Alternativeley this information can be
specified in the BibTeX / BibLaTeX file itself by including a pandoc title
block in the first three lines of the bibliography file. Such a titleblock
consists of three lines beginning with `%` followed by the title, author and
date respectiveley:

```
% My Bibliography Title
% Jane Doe
% 20. January 2018

@article{my-article,
    title={Some Article I read},
```


# Configuration

The mkpdf configuration file is located at `~/.config/mkpdfrc` and will be
sourced at each invokation of the script. This even allows to use some basic
shell scripting to e.\ g.\ enclose configuration options in conditionals. It
also allows for comments by prefixing lines with `#`. Options are specified or
unset as simple shell variables:

```
# Set option_1 to value
option_1="value"
# Set boolean option_2 to false
unset option_2
```


## Boolean Options

clean
: Always remove temporary files before running latexmk.

debug
: Always print latexmk's output to stdout.

preview
: Always open pdf after generation.

## Other Options

default_template
: Use the following template as default if none is specified from command line
or via metadata fields.

default_bib_template
: Use the following template as default for BibTeX files if no template is
specified from the command line.

pandoc_options
: Use the following command line options when invoking pandoc. If you want to
add options, rather than to replace default options, you can do that as
follows:

```
pandoc_options="$pandoc_options --new-option"
```

pandoc_metavars
: In contrast to pandoc_options, this option it is meant for document
metadata rather than for technical switches or formating information. It
could e.\ g.\ be used to have all documents automatically recieve your
name for author as follows below. Note however, that pandoc's `-M`
option will override any metadata found in titleblocks.

```
pandoc_metavars="$pandoc_metavars -M author='Jane Doe'"
```

tmpdir
: Specify the root of the directory where mkpdf stores temporary
files. Note that this directory is completely removed with `mkpdf
-c`, so make sure it is not used for any other purpose. Default value:
`/tmp/mkpdf-$UID`, where `$UID` is a unique id assigned by the system to
the user running mkpdf.

## Postprocessing

Mkpdf will run postprocessing options on the tex files generated by pandoc
before invoking latexmk. These postprocessing options are specified within a
shell function which receives the path to the tex file as an argument
(accessible as `$1`). The default definition is as follows:

```
postprocessing() {
    test "$(which furbishtex 2>/dev/null)" && furbishtex "$1"
}
```

To use custom postprocessing, you can simply define a function called
postprocessing in your configuration file. This custom function will then be
invoked instead of the default one. To completely disable postprocessing,
simply unset the default definition:

```
unset postprocessing
```


# Author

Frank Seifferth <frankseifferth@posteo.net>. Feel free to contact me
with feedback or suggestions.
