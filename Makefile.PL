use 5.010;
use ExtUtils::MakeMaker;

my %options = (
    'NAME'          => 'Plack::App::OpenVPN::Status',
    'VERSION_FROM'  => 'lib/Plack/App/OpenVPN/Status.pm',
    'AUTHOR'        => 'Anton Gerasimov <me@zyxmasta.com>',
    'ABSTRACT_FROM' => 'lib/Plack/App/OpenVPN/Status.pm',
    'LICENSE'       => 'perl',
    'PREREQ_PM'     => {
        'Plack'   => '0.9979',
        'Text::MicroTemplate' => '0.15',
        'parent'  => 0,
        'strict'  => 0,
        'warnings' => 0
    },
    'BUILD_REQUIRES' => {
        'Test::More' => '0.98',
    },
    'MIN_PERL_VERSION' => '5.10.0',
    'test' => {
        'TESTS' => 't/*.t',
    }
);

WriteMakefile(%options);
