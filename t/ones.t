# Test other such primitives also
use t::lib::TestHelper; # TODO migrate

use PDL::LiteF;
kill INT,$$ if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

print "1..4\n";

$b = double ones(2,3);

$ind=1;


num_ok($ind++,($b->dims)[0] == 2);
num_ok($ind++,($b->dims)[1] == 3);
print $b;
num_ok($ind++,($b->at(1,1)) == 1);
num_ok($ind++,($b->at(1,2)) == 1);
