Zeatacoin Core integration/staging tree
=====================================

[![Build Status](https://github.com/DigiMancer3D/Zeatacoin?branch=master)](https://github.com/DigiMancer3D/Zeatacoin)


What is Zeatacoin?
----------------

Zeatacoin is an experimental digital currency that enables instant payments to
anyone, anywhere in the world. Zeatacoin uses peer-to-peer technology to operate
with no central authority: managing transactions and issuing money are carried
out collectively by the network. Zeatacoin Core is the name of open source
software which enables the use of this currency.

License
-------

Litecoin Core is released under the terms of the MIT license.


Development Process
-------------------

The `master` branch is regularly built and tested, but is not guaranteed to be
completely stable. [Tags](https://github.com/digimancer3d/zeatacoin/tags) are created
occasionally to indicate new official, stable release versions of Zeatacoin Core.

The contribution workflow is described in [CONTRIBUTING.md](CONTRIBUTING.md)
and useful hints for developers can be found in [doc/developer-notes.md](doc/developer-notes.md).


Testing
-------

Testing and code review is the bottleneck for development; we get more pull
requests than we can review and test on short notice. Please be patient and help out by testing
other people's pull requests, and remember this is a security-critical project where any mistake might cost people
lots of money.

### Automated Testing

Developers are strongly encouraged to write [unit tests](src/test/README.md) for new code, and to
submit new unit tests for old code. Unit tests can be compiled and run
(assuming they weren't disabled in configure) with: `make check`. Further details on running
and extending unit tests can be found in [/src/test/README.md](/src/test/README.md).

There are also [regression and integration tests](/test), written
in Python, that are run automatically on the build server.
These tests can be run (if the [test dependencies](/test) are installed) with: `test/functional/test_runner.py`

