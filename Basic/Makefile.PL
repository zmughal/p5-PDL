use strict;
use warnings;
use PDL::Core::Dev;
use ExtUtils::MakeMaker;

system("copy default.perldlrc default.pdl") if $^O =~ /win32/i;

WriteMakefile(
    'NAME'	=> 'PDL',
    'VERSION_FROM' => '../lib/PDL/Version.pm',
    NO_MYMETA => 1,
    DIR => [ qw(
        Core
        Bad
        Complex
        Math
        MatrixOps
        Primitive
        Slices
        Test
        Ufunc
    ) ],
#        Ops
);

# modify clean method not to delete files named 'core'
# (required for MacOSX, where "Core" and "core" are
# indistinguishable)
package MY; # so that "SUPER" works right
sub clean {
  my $inherited = shift->SUPER::clean(@_);
  $inherited =~ s/\s+core\s/ /;
  # print STDERR "processed list :\n$inherited\n";
  $inherited;
}
