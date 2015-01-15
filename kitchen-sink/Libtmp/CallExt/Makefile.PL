use strict;
use warnings;
use ExtUtils::MakeMaker;

my $malloclib = $PDL::Config{MALLOCDBG}->{libs};
my $mallocinc = $PDL::Config{MALLOCDBG}->{include};

WriteMakefile(
 'NAME'	        => 'PDL::CallExt',
 'VERSION_FROM' => '../../lib/PDL/Version.pm',
 'INC' => "-I../../Basic/Core $mallocinc",
 'LIBS' => [$malloclib],
);
