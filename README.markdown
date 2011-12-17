# mate

TextMate project builder using git ignores for exclusions

You can add `alias mate='tm'` to your `.profile`, `.bash_profile` …

When `tm` command (or `mate` if aliased) is called with one or more paths and any of them is a directory, than project is created in `~/.tmprojs/` and opened. Its file and folder filters are built based on all types of git ignores (global, `.gitignore` and `.git/info/exclude`) and special `.tmignore` which works like other ignore files for project but doesn't affect git itself, also `.git` folder and certain files (images, archives, media files, logs and some other binary files) are filtered.

## Copyright

Copyright (c) 2010-2011 Ivan Kuchin. See LICENSE.txt for details.
