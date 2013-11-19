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

* `node['minc-toolkit']['download_url']` - The URL to fetch the source code from.  It is expected to be a 'tar.gz' file.

TO_DO List
==========

Make the installation location configurable (?)
