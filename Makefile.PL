use 5.008009;
use ExtUtils::MakeMaker;

my %options = (
    'NAME'          => 'Plack::App::OpenVPN::Status',
    'VERSION_FROM'  => 'lib/Plack/App/OpenVPN/Status.pm',
    'AUTHOR'        => 'Anton Gerasimov <me@zyxmasta.com>',
    'ABSTRACT_FROM' => 'lib/Plack/App/OpenVPN/Status.pm',
    'LICENSE'       => 'perl',
    'PREREQ_PM'     => {
        'Carp'    => 0,
        'Plack'   => '0.9979',
        'parent'  => 0,
        'strict'  => 0,
        'warnings' => 0
    },
    'BUILD_REQUIRES' => {
        'Test::Deep' => '0.108',
        'Test::More' => '0.98',
    },
    'test' => {
        'TESTS' => 't/*.t',
    }
);

WriteMakefile(%options);
