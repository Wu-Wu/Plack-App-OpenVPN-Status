package Plack::App::OpenVPN::Status;

# ABSTRACT: Plack application to display the sessions of OpenVPN server

use 5.008009;
use strict;
use warnings;

use parent 'Plack::Component';
use Carp ();

our $VERSION = '0.1.1';

#
#
sub prepare_app {

}

#
#
sub call {
    my ($self, $env) = @_;

}

1;
__END__

=head1 NAME

Plack::App::OpenVPN::Status - Plack application to display the sessions of OpenVPN server

=head1 SYNOPSIS

  use Plack::App::OpenVPN::Status;

=head1 DESCRIPTION

to be written..


=head1 SEE ALSO

L<Plack>


=head1 AUTHOR

Anton Gerasimov, E<lt>me@zyxmasta.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Anton Gerasimov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.


=cut
