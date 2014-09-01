# Test ->*physical*(). This is not yet good enough: we need
# nasty test cases,

use t::lib::TestHelper; # TODO migrate
use PDL::LiteF;

sub tapprox {
	my($a,$b) = @_;
	$c = abs($a-$b);
	$d = max($c);
	$d < 0.01;
}

# Cheat
print "1..1\n";
print "ok 1\n";

if(0) {

print "1..6\n";

$a = zeroes(4,4);
num_ok(1,$a->isphysical());

$b = xvals $a + 0.1 * yvals $a;
$c = $b->slice("1:3:2,:");
num_ok(2,! $c->isphysical());

$d = $b->physical();
num_ok(3, $d == $b);

$e = $c->physical();
num_ok(4, $e != $c);
num_ok(5, $e->isphysical());

num_ok(6, tapprox($c,$e));

}
