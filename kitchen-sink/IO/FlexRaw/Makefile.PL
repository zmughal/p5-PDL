use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => "PDL::IO::FlexRaw",
     'VERSION_FROM' => '../../lib/PDL/Version.pm',
    (eval ($ExtUtils::MakeMaker::VERSION) >= 6.57_02 ? ('NO_MYMETA' => 1) : ()),
);
