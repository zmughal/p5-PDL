use strict;
use warnings;
use ExtUtils::MakeMaker;
WriteMakefile(
        NAME => 'PDL::Filter',
        VERSION_FROM => '../../lib/PDL/Version.pm',
        PM => {
         map {($_ => '$(INST_LIBDIR)/Filter/'.$_)} <*.pm>
        },
    NO_MYMETA => 1,
       );
