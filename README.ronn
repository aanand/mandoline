mandoline(1) - delete Cucumber features/scenarios by tag
========================================================

Synopsis
--------

`mandoline` `-t`|`--tags` <tag>[,<tag>...] <path> [<path>...]

Installation
------------

`gem install mandoline`

Description
-----------

Given a tag or comma-separated list of tags (e.g. `foo,bar`) and a list of Cucumber feature file paths, mandoline will:

- delete files with `@foo` or `@bar` at the top
- delete scenarios with `@foo` or `@bar` on the preceding line

Options
-------

- `-t <tags>`, `--tags <tags>`
  Comma-separated list of tags to filter by.

- `<path>`
  One or more feature file paths. If a single argument is given, and it is a directory, it is recursively scanned for `.feature` files.

Bugs
----

Report bugs and find great salad recipes at [the Github page](https://github.com/aanand/mandoline).

Copyright
---------

Copyright 2012 by [Aanand Prasad](http://aanandprasad.com) under the MIT license (see the LICENSE file).
