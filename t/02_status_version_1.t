use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Plack::Builder;

use Plack::App::OpenVPN::Status;

my $app = builder {
    mount '/foo' => Plack::App::OpenVPN::Status->new(status_from => 't/status-v1.log');
};

test_psgi $app, sub {
    my ($cb) = @_;

    my $res = $cb->(GET '/foo');
    is $res->code, 200, 'Status V1: response code';
    like $res->content, qr|cadvecisvo|, 'Status V1: common name';
    like $res->content, qr|00:ff:de:ad:be:ef|, 'Status V1: virtual address';
    like $res->content, qr|Tue Dec  4 11:05:56 2012|, 'Status V1: status date, time';

};

done_testing;
