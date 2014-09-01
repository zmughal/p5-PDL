# tests for error checking of input args to PP compiled function
#

use t::lib::TestHelper; # TODO migrate

use PDL::LiteF;
kill INT,$$ if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

# sub tapprox {
#         my($a,$b,$c,$d) = @_;
#         $c = abs($a-$b);
#         $d = max($c);
#         return $d < 0.01;
# }


sub eprint {
	print "EXPECT ERROR NEXT:\n-----\n";
	print $_[0];
	print "-----\n";
}

print "1..4\n";

my $b=pdl([1,2,3])->long;
my $a=[1,2,3];
eval 'PDL::Ufunc::sumover($a,$b)';

num_ok(1,!$@);

$aa=3;
$a=\$aa;
eval 'PDL::Ufunc::sumover($a,$b)';
eprint $@;
num_ok(2,$@ =~ /Error - tried to use an unknown/);

eval { PDL::Ufunc::sumover({}) };
eprint $@;

num_ok 3, $@ =~ /Hash given as a pdl - but not \{PDL} key/;


$c = 0;
eval { PDL::Ufunc::sumover(\$c) };
eprint $@;

num_ok 4, $@ =~ /Error - tried to use an unknown/;


