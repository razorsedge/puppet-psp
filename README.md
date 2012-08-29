Puppet HP Proliant Support Pack Module
======================================

[![Build Status](https://secure.travis-ci.org/razorsedge/puppet-psp.png?branch=master)](http://travis-ci.org/razorsedge/puppet-psp)

Introduction
------------

This module manages the installation of the hardware monitoring aspects of the HP
[Proliant Support Pack](http://h18013.www1.hp.com/products/servers/management/psp/)
from the [Software Delivery Repository](http://downloads.linux.hp.com/SDR/).  It
does not support the HP kernel drivers.

This module currently only works on CentOS, Oracle Linux, and Red Hat Enterprise
Linux distributions.

Actions:

* Installs the PSP YUM repository.
* Installs the HP Version Control Agent.
* Installs the HP Health packages and services.
* Installs the HP Systems Management Homepage packages, service, and configuration.
* Installs the HP SNMP Agent package, service, and configuration.

OS Support:

* RedHat family  - tested on CentOS 6.3
* Fedora         - presently unsupported (patches welcome)
* SuSE family    - presently unsupported (patches welcome)
* Debian family  - presently unsupported (patches welcome)
* Asianux        - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

Examples
--------

      # Parameterized Class:
      class { 'snmp': }
      class { 'psp': smh_gid => '1001', smh_uid => '1001', }
      class { 'psp::hpvca': }
      class { 'psp::hphealth': }
      class { 'psp::hpsmh': port2301 => 'false', }
      class { 'psp::hpsnmp': cmalocalhostrwcommstr => 'SomeSecureString', }

Notes
-----

* Only tested on CentOS 6.3 x86_64 on a HP DL140 G2.

Issues
------

* None.

Copyright
---------

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

