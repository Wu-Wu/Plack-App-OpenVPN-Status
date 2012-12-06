use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Plack::Builder;

use Plack::App::OpenVPN::Status;

can_ok 'Plack::App::OpenVPN::Status', qw/default_view renderer status_from prepare_app call openvpn_status/;

my $app = builder {
    mount '/foo' => Plack::App::OpenVPN::Status->new; # undefined status source
    mount '/bar' => Plack::App::OpenVPN::Status->new(status_from => 't/nonexistent.log');
    mount '/baz' => Plack::App::OpenVPN::Status->new(status_from => 't/status-empty.log');
};

test_psgi $app, sub {
    my ($cb) = @_;

    my $res;

    $res = $cb->(GET '/foo');
    is $res->code, 200, 'No status: response code';
    like $res->content, qr|status file is not set|, 'No status: message';

    $res = $cb->(GET '/bar');
    is $res->code, 200, 'Nonexistent status: Response code';
    like $res->content, qr|does not exist or unreadable|, 'Nonexistent status: message';

    $res = $cb->(GET '/baz');
    is $res->code, 200, 'Correct status (with no users): response code';
    like $res->content, qr|There is no connected OpenVPN users|, 'Correct status (with no users): content';
    like $res->content, qr|Tue Dec  4 02:31:18 2012|, 'Correct status (with no users): status date, time';

};

done_testing;
