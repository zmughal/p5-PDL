use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	      'NAME'  	=> 'PDL::Graphics::PGPLOT',
	      'VERSION_FROM' => '../../lib/PDL/Version.pm',
	      'DIR' => ['Window'],
    NO_MYMETA => 1,
);
