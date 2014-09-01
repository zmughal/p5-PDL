use t::lib::TestHelper; # TODO migrate
use PDL::LiteF;
kill INT,$$ if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

sub tapprox {
	my($a,$b,$c,$d) = @_;
	$c = abs($a-$b);
	$d = max($c);
	return $d < 0.01;
}

print "1..44\n";

# $a0 = zeroes 3,5;
# $b0 = xvals $a0;

$a = xvals zeroes 3,5;

$b = yvals zeroes 3,5;

$c = $a + $b;

num_ok(1,$c->at(2,2) == 4);
num_ok(2,$c->at(2,3) == 5);
eval '$c->at(3,3)';
num_ok(3,$@ =~ /Position out of range/);

$d = pdl 5,6;

$e = $d - 1;
num_ok(4,$e->at(0) == 4);
num_ok(5,$e->at(1) == 5);
$f = 1 - $d;
num_ok(6,$f->at(0) == -4);
num_ok(7,$f->at(1) == -5);

# Now, test one operator from each group
# biop1 tested already

$a = pdl 0,1,2;
$b = pdl 1.5;

$c = $a > $b;

num_ok(8,$c->at(1) == 0);
num_ok(9,$c->at(2) == 1);

$a = byte pdl 0,1,3;
$c = $a << 2;

num_ok(10,$c->at(0) == 0);
num_ok(11,$c->at(1) == 4);
num_ok(12,$c->at(2) == 12);


$a = pdl 16,64,9;
$b = sqrt($a);

num_ok(13,tapprox($b,(pdl 4,8,3)));

# See that a is unchanged.

num_ok(14,$a->at(0) == 16);

$a = pdl 1,0;
$b = ! $a;
num_ok(15,$b->at(0) == 0);
num_ok(16,$b->at(1) == 1);

$a = pdl 12,13,14,15,16,17;
$b = $a % 3;

num_ok(17,$b->at(0) == 0);
num_ok(18,$b->at(1) == 1);
num_ok(19,$b->at(3) == 0);
# [ More modulus testing farther down! ]

# Might as well test this also

num_ok(20,tapprox((pdl 2,3),(pdl 2,3)));
num_ok(21,!tapprox((pdl 2,3),(pdl 2,4)));

# Simple function tests

$a = pdl(2,3);
num_ok(22, tapprox(exp($a), pdl(7.3891,20.0855)));
num_ok(23, tapprox(sqrt($a), pdl(1.4142, 1.7321)));

# And and Or

num_ok(24, tapprox(pdl(1,0,1) & pdl(1,1,0), pdl(1,0,0)));
num_ok(25, tapprox(pdl(1,0,1) | pdl(1,1,0), pdl(1,1,1)));

# atan2
num_ok (26, tapprox(atan2(pdl(1,1), pdl(1,1)), ones(2) * atan2(1,1)));

$a = sequence (3,4);
$b = sequence (3,4) + 1;

num_ok (27, tapprox($a->or2($b,0), $a | $b));
num_ok (28, tapprox($a->and2($b,0), $a & $b));
num_ok (29, tapprox($b->minus($a,0), $b - $a));
num_ok (30, tapprox($b - $a, ones(3,4)));

# inplace tests

$a = pdl 1;
$sq2 = sqrt 2; # perl sqrt
$a->inplace->plus(1,0);  # trailing 0 is ugly swap-flag
num_ok(31, tapprox $a, pdl 2);
$warning_shutup = $warning_shutup = sqrt $a->inplace;
num_ok(32, tapprox $a, pdl($sq2));
$a = pdl 4;
num_ok(33, tapprox 2, sqrt($a->inplace));

# log10 now uses C library
# check using scalars and piddles
$a = log10(110);
$b = log(110) / log(10);
print "a: $a  [ref(\$a)='", ref($a),"']\n";
print "b: $b\n";
num_ok(34, abs($a-$b) < 1.0e-5 );
$a = log10(pdl(110,23));
$b = log(pdl(110,23)) / log(10);
print "a: $a\n";
print "b: $b\n";
num_ok(35, tapprox $a, $b );

# check inplace
num_ok(36, tapprox pdl(110,23)->inplace->log10(), $b );
$data = ones 5;
$data &= 0;
num_ok(37, all $data == 0);
$data |= 1;
num_ok(38, all $data == 1);

num_ok(39, all $data eq $data); # check eq operator


# check proper modulus... really we should do this for each datatype
$a = xvals(15)-7;
$b = $a % 3;
num_ok(40,sum($b != pdl(2,0,1,2,0,1,2,0,1,2,0,1,2,0,1)) == 0);
$b = $a % -3;
num_ok(41,sum($b != pdl(-1,0,-2,-1,0,-2,-1,0,-2,-1,0,-2,-1,0,-2))==0);
$b = $a % 0;
num_ok(42,sum($b != 0) == 0);
#check that modulus works on PDL_Index types correctly
$b = $a->qsorti;
$c = $b % 3;
num_ok(43,all($c->double==pdl("0 1 2 " x 5)));
num_ok(44,longlong(10)%longlong(5)==0);
