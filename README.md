Plack-App-OpenVPN-Status
========================

Plack application to display the sessions of OpenVPN server.

[![Build Status](https://travis-ci.org/Wu-Wu/Plack-App-OpenVPN-Status.png)](https://travis-ci.org/Wu-Wu/Plack-App-OpenVPN-Status)

INSTALLATION
============

To install this module type the following:

    perl Makefile.PL
    make
    make test
    make install

SYNOPSYS
========

    use FindBin ();
    use Plack::Builder;
    use Plack::App::File;
    use Plack::App::OpenVPN::Status;

    builder {
        mount '/static' => Plack::App::File->new(root => "$FindBin::Bin/static");
        mount '/' => Plack::App::OpenVPN::Status->new(status_from => "$FindBin::Bin/status.log");
    };


Full sources of this PSGI app are available at distribution's `eg/` directory.


DEPENDENCIES
============

This module requires these other modules and libraries:

[Plack](http://search.cpan.org/perldoc?Plack)

[Text::MicroTemplate](http://search.cpan.org/perldoc?Text::MicroTemplate)

[Test::More](http://search.cpan.org/perldoc?Test::More)


COPYRIGHT AND LICENCE
=====================

Copyright (C) 2012 by Anton Gerasimov, <me@zyxmasta.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.


