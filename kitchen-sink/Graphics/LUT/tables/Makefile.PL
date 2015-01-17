use strict;
use warnings;

# files ending in .fits will end up in
# PDL/Graphics/LUT/tables/
use ExtUtils::MakeMaker;

my @tables = glob( "*.fits" );

WriteMakefile(
  'NAME'         => 'PDL::Graphics::LUT::tables::DATA',   
  'VERSION_FROM' => '../../../lib/PDL/Version.pm',
  'PM' => {
      (map {($_,'$(INST_LIBDIR)/'.$_)} @tables)
   },
   NO_MYMETA => 1,
);
