Overview
========

This cookbook downloads, builds and installs the MINC toolkit.  The install
location is "/usr/local"

Dependencies
============

The build requires various development tools and libraries that need
to be available as installable packages.

Attributes
==========

See `attributes/default.rb` for the default values.

* `node['minc-toolkit']['download_url']` - The URL to fetch the source code tarball.  It is expected to be a 'tar.gz' file.
* `node['minc-toolkit']['force_install']` - If true, force the rebuild and install even if it looks like minc tools have been installed.  Defaults to false.
* `node['minc-toolkit']['prefix']` - Specifies the --prefix for "./configure".  Default is "/usr/local".
* `node['minc-toolkit']['clean_after)install']` - If true, delete the temporary build directory after a successful install.  Defaults to true.
* `node['minc-toolkit']['build_dir']` - The pathname of the temporary build directory.  Defaults to "/tmp/minc-build".

Note that the build directory needs to be on a partition with enough free space to hold the downloaded source tree and the files created during unpacking and building.  On my machine, that is ~35Mb.

TO_DO List
==========

The default behaviour should be to install a package from a repo ... if we know of a suitable one.  Apparently, minc packages are available for Ubuntu.
