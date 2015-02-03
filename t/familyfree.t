use t::lib::TestHelper; # TODO migrate
use PDL::LiteF;
kill INT,$$ if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

print "1..1\n";

# This is something that would cause an exception on 1.91_00:
# when the original was undef'd, xchghashes would barf.

$a = xvals zeroes(5,5);

$b = $a->slice(':,2:3');

$a = 1;  # Undefine orig. a

$b += 1;

num_ok(1,1);
