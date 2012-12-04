package Plack::App::OpenVPN::Status;

# ABSTRACT: Plack application to display the sessions of OpenVPN server

use 5.008009;
use strict;
use warnings;

use parent 'Plack::Component';
use Text::MicroTemplate;
use Plack::Util::Accessor qw/renderer status_from/;

our $VERSION = '0.1.2';

#
# default view (uses Twitter Bootstrap v2.x.x layout)
sub default_view {
    <<'EOTMPL' }
% my $vars = $_[0];
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>OpenVPN Status</title>
        <link href="/static/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <div class="row">
                <div class="page-header">
                    <h1>Active OpenVPN Sessions <small>Updated <%= $vars->{updated} %></small></h1>
                </div>
            </div>
            <div class="row">
% if (keys %{$vars->{users}}) {
                <table class="table table-bordered table-striped table-hover">
                    <thead>
                        <tr>
                            <th class="span2">Virtual address</th>
                            <th class="span2">Common name</th>
                            <th>Remote IP (port)</th>
                            <th>Recv (from)</th>
                            <th>Xmit (to)</th>
                            <th class="span3">Connected since</th>
                        </tr>
                    </thead>
                    <tbody>
% for my $user (keys %{$vars->{users}}) {
                        <tr>
                            <td><tt><%= $vars->{users}->{$user}->{'virtual'} %></tt></td>
                            <td><%= $vars->{users}->{$user}->{'common-name'} %></td>
                            <td><%= $vars->{users}->{$user}->{'remote-ip'} %> (<%= $vars->{users}->{$user}->{'remote-port'} %>)</td>
                            <td><%= $vars->{users}->{$user}->{'rx-bytes'} %></td>
                            <td><%= $vars->{users}->{$user}->{'tx-bytes'} %></td>
                            <td><%= $vars->{users}->{$user}->{'connected'} %></td>
                        </tr>
% }
                    </tbody>
                </table>
% } else {
                <div class="alert alert-block alert-info">
                    <h4>Attention!</h4>
                    There is no connected OpenVPN users.
                </div>
% }
            </div>
        </div>
        <!--
        <script src="/static/jquery.min.js"></script>
        <script src="/static/bootstrap.min.js"></script>
        -->
    </body>
</html>
EOTMPL

#
# some preparations
sub prepare_app {
    my ($self) = @_;

    $self->renderer(
        Text::MicroTemplate->new(
            template   => $self->default_view,
            tag_start  => '<%',
            tag_end    => '%>',
            line_start => '%',
        )->build
    );
}

#
# execute application
sub call {
    my ($self, $env) = @_;

    my ($body);

    unless ($self->status_from) {
        $body = "Error: OpenVPN status file is not set!";
    }
    else {
        unless (-e $self->status_from || -r _) {
            $body = "Error: OpenVPN status file '" . $self->status_from . "' does not exist or unreadable!";
        }
        else {
            $body = $self->renderer->($self->openvpn_status);
        }
    }

    [ 200, [ 'Content-Type' => 'text/html; charset=utf-8' ], [ $body ] ];
}

#
# parse OpenVPN status log
sub openvpn_status {
    my ($self) = @_;

    my $vars = {};

    # octets formatter
    # http://en.wikipedia.org/wiki/Octet_%28computing%29
    my $adaptive_octets = sub {
        my ($octets) = @_;

        if ($octets > 1152921504606846976) { # exbioctet (Eio) = 2^60 octets
            $octets = sprintf('%.6f Eio', $octets/1152921504606846976);
        }
        elsif ($octets > 1125899906842624) { # pebioctet (Pio) = 2^50 octets
            $octets = sprintf('%.5f Pio', $octets/1125899906842624);
        }
        elsif ($octets > 1099511627776) {    # tebioctet (Tio) = 2^40 octets
            $octets = sprintf('%.4f Tio', $octets/1099511627776);
        }
        elsif ($octets > 1073741824) {       # gibioctet (Gio) = 2^30 octets
            $octets = sprintf('%.3f Gio', $octets/1073741824);
        }
        elsif ($octets > 1048576) {          # mebioctet (Mio) = 2^20 octets
            $octets = sprintf('%.2f Mio', $octets/1048576);
        }
        elsif ($octets > 1024) {             # kibioctet (Kio) = 2^10 octets
            $octets = sprintf('%.1f Kio', $octets/1024);
        }

        $octets;
    };

    open(STATUS, '<' . $self->status_from) or Carp::croak "Cannot open '" . $self->status_from . "'";

    while (<STATUS>) {
        next if /^$/;
        chomp;

        my @line = split /,/, $_;
        my $length = scalar(@line);

        $length == 2 && do {
            next unless $line[0] =~ /^Updated/;
            $vars->{'updated'} = $line[1];
            next;
        };

        $length == 5 && do {
            next if $line[0] =~ /^Common Name/;
            my ($ip, $port) = split /:/, $line[1];
            $vars->{'users'}->{$line[0]} = {
                'common-name' => $line[0],
                'remote-ip'   => $ip,
                'remote-port' => $port,
                'rx-bytes'    => $adaptive_octets->($line[2]),
                'tx-bytes'    => $adaptive_octets->($line[3]),
                'connected'   => $line[4],
            };
            next;
        };

        $length == 4 && do {
            next if $line[0] =~ /^Virtual Address/;
            $vars->{'users'}->{$line[1]}->{'virtual'} = $line[0];
            $vars->{'users'}->{$line[1]}->{'last-ref'} = $line[3];
            next;
        };
    }
    close(STATUS);

    $vars;
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
