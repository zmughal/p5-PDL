use strict;
use warnings;
use ExtUtils::MakeMaker;
WriteMakefile(
  NAME => 'PDL::Filter',
  VERSION_FROM => '../../Basic/PDL.pm',
  PM => {
   map {($_ => '$(INST_LIBDIR)/Filter/'.$_)}
   grep {
      !defined $PDL::Config{WITH_SLATEC} ||
      $PDL::Config{WITH_SLATEC}==1 ||
      !($_ eq 'LinPred.pm')
   } <*.pm>
  },
  NO_MYMETA => 1,
);
