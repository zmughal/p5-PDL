use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  'NAME' => 'PDL::Graphics::PGPLOT::Window',
  'VERSION_FROM' => '../../../lib/PDL/Version.pm',
  'INC' => '-I../../../lib/PDL/Core/', # for ppport.h
);
