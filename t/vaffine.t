use t::lib::TestHelper; # TODO migrate

# Test vaffine optimisation

use PDL::LiteF;

print "1..1\n";

$x = zeroes(100,100);

$y = $x->slice('10:90,10:90');

$y++;

num_ok(1, (not $y->allocated) ) ;


