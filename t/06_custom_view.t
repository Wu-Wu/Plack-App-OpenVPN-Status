use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Plack::Builder;

use Plack::App::OpenVPN::Status;

sub my_custom_view { <<'EOTMPL' }
% my $vars = $_[0];
<html>
    <head>
        <title>Customized OpenVPN Status</title>
    </head>
    <body>
        <h1>Updated: <%= $vars->{updated} %>; Status Version #<%= $vars->{version} %></h1>
        <h2>Connected <%= scalar(@{$vars->{users}}) %> user(s)</h2>
    </body>
</html>
EOTMPL

my $app = builder {
    mount '/foo' => Plack::App::OpenVPN::Status->new(status_from => 't/status-v1.log', custom_view => \&my_custom_view);
    mount '/bar' => Plack::App::OpenVPN::Status->new(status_from => 't/status-v1.log', custom_view => []);
};

test_psgi $app, sub {
    my ($cb) = @_;

    my $res = $cb->(GET '/foo');
    is $res->code, 200, 'Custom view: response code';
    like $res->content, qr|Customized OpenVPN Status|, 'Custom view: title';
    like $res->content, qr|Updated: Tue Dec  4 11:05:56 2012|, 'Custom view: status date, time';

    $res = $cb->(GET '/bar');
    is $res->code, 200, 'Custom invalid view: response code';
    unlike $res->content, qr|Customized OpenVPN Status|, 'Custom invalid view: title';
    unlike $res->content, qr|Updated: Tue Dec  4 11:05:56 2012|, 'Custom invalid view: status date, time';
};

done_testing;
