use t::lib::TestHelper; # TODO migrate
use PDL::LiteF;

my $ntests = 5;
print "1..$ntests\n";


use PDL::Reduce;

$a = sequence 5,5;
$b = $a->reduce('add',0);

ctr_ok(all $b == $a->sumover);
ctr_ok(all $a->reduce('add',1) == $a->mv(1,0)->sumover);
ctr_ok(all $a->reduce('mult',1) == $a->mv(1,0)->prodover);
# test the new reduce features
ctr_ok($a->reduce('+',0,1) == sum $a); # reduce over list of dims
ctr_ok(all $a->reduce(\&PDL::sumover) == $a->sumover); # use code refs
