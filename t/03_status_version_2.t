use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Plack::Builder;

use Plack::App::OpenVPN::Status;

my $app = builder {
    mount '/foo' => Plack::App::OpenVPN::Status->new(status_from => 't/status-v2.log');
};

test_psgi $app, sub {
    my ($cb) = @_;

    my $res = $cb->(GET '/foo');
    is $res->code, 200, 'Status V2: response code';
    like $res->content, qr|cadvecisvo|, 'Status V2: common name';
    like $res->content, qr|00:ff:de:ad:be:ef|, 'Status V2: virtual address';
    like $res->content, qr|Wed Dec  5 21:15:35 2012|, 'Status V2: status date, time';

};

done_testing;
