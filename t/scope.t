# Test if we can still do scopes ok - multiple uses etc..
# Also see that PDL loaders get the correct symbols.
use t::lib::TestHelper; # TODO migrate


print "1..10\n";

package A;
our $a;
# print "A: ",%A::,"\n";
use PDL;

# $a = zeroes 5,5;

# print "A: ",%A::,"\n";

$a = zeroes 5,5;

# print "A: %A::\n";



# print "AC: ",(bless {},A)->can("zeroes"),"\n";
::num_ok(1,(bless {},A)->can("zeroes"));

package B;
use PDL;

#print "B: ",%B::,"\n";
#print "B: ",%B::,"\n";
# $b = zeroes 5,5;
# print "BC: ",(bless {},B)->can("zeroes"),"\n";
::num_ok(2,(bless {},B)->can("zeroes"));

package C;
use PDL::Lite;
::num_ok(3,!((bless {},C)->can("zeroes")));

package D;
use PDL::Lite;
::num_ok(4,!((bless {},D)->can("zeroes")));

package E;
use PDL::LiteF;
::num_ok(5,(bless {},E)->can("zeroes"));

package F;
use PDL::LiteF;
::num_ok(6,(bless {},F)->can("zeroes"));

::num_ok(7,!((bless {},C)->can("imag")));
::num_ok(8,!((bless {},D)->can("imag")));
::num_ok(9,!((bless {},E)->can("imag")));
::num_ok(10,!((bless {},F)->can("imag")));
