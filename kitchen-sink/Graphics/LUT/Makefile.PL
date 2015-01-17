use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
 'NAME'         => 'PDL::Graphics::LUT',
 'VERSION_FROM' => '../../lib/PDL/Version.pm',
 'DIR'          => [ 'tables', 'ramps' ],
 NO_MYMETA => 1,
);
