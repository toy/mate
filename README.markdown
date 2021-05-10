# mate

TextMate 2 properties builder using git ignores for exclusions.

You can add `alias mate='tm2'` to your `.profile`, `.bash_profile` …

When `tm2` command (or `mate` if aliased) is called with one or more paths, for all directories a `.tm_properties` file is generated or changed and mate is called. Its file and folder filters are built based on all types of git ignores (global, `.gitignore` and `.git/info/exclude`) and special `.tmignore` which works like other ignore files for project but doesn't affect git itself (you can use global `~/.tmignore` file), also `.git` folder and certain files (images, archives, media files, logs and some other binary files) are filtered.

## Copyright

Copyright (c) 2010-2021 Ivan Kuchin. See LICENSE.txt for details.
