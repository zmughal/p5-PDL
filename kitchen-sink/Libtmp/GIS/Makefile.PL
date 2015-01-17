use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME' => 'PDL::Lib::GIS',
    VERSION_FROM => '../../lib/PDL/Version.pm',
    DIR =>  [ qw/ Proj / ],
    NO_MYMETA => 1,
);

