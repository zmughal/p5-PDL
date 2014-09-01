# Test the dataflow magic & binding stuff
# XXX DISABLED!
use t::lib::TestHelper; # TODO migrate

use PDL::LiteF;

kill INT,$$ if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

print "1..1\n";

num_ok(1,1);

if (0) {

print "1..6\n";

$ind=1;

$a = pdl 2,3,4;
$a->doflow();

$b = $a + 1;

$c = $b * 2;

@cl = (-1,-1,-1);

$c->bind(sub{ @cl = $c->list() });

num_ok($ind++, ((join ',',@cl) eq "-1,-1,-1"));

$a->set(0,5);

num_ok($ind++, ((join ',',@cl) eq "-1,-1,-1"));

$a->set(1,6);

num_ok($ind++, ((join ',',@cl) eq "-1,-1,-1"));

PDL::dowhenidle();

num_ok($ind++, ((join ',',@cl) eq "12,14,10"));

$a->set(2,7);

num_ok($ind++, ((join ',',@cl) eq "12,14,10"));

PDL::dowhenidle();

num_ok($ind++, ((join ',',@cl) eq "12,14,16"));

}
