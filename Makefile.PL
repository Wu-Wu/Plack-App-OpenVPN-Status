use 5.010;
use ExtUtils::MakeMaker;

my $meta_merge = {
    META_MERGE => {
        resources => {
            repository => 'https://github.com/Wu-Wu/Plack-App-OpenVPN-Status',
            bugtracker => 'https://github.com/Wu-Wu/Plack-App-OpenVPN-Status/issues',
        },
    }
};

my %options = (
    'NAME'          => 'Plack::App::OpenVPN::Status',
    'VERSION_FROM'  => 'lib/Plack/App/OpenVPN/Status.pm',
    'AUTHOR'        => 'Anton Gerasimov <chim@cpan.org>',
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
    },
    $ExtUtils::MakeMaker::VERSION >= 6.50 ? (%$meta_merge) : (),
);

WriteMakefile(%options);
