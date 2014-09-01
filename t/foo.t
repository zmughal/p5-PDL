

use t::lib::TestHelper;
use PDL::LiteF;

kill INT,$$ if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

print "1..3\n";

# PDL::Core::set_debugging(1);

# Test basic use of foomethod.

$a = zvals zeroes 2,2,50;

$b = $a->oneslice(2,10,2,5);

caller_num_ok(1,$b->at(0,0,0) == 10);
caller_num_ok(2,$b->at(0,0,1) == 12);
caller_num_ok(3,$b->at(0,0,4) == 18);

# we don't test the foomethod
# had to disable some code that
# is required for foomethod since
# it caused another bug in more important code (see pdl_changed in pdlapi.c)
exit(0);

$t = $b->get_trans;

$t->call_trans_foomethod(11,3,6);

$b->make_physical();

caller_num_ok(4,$b->at(0,0,0) == 11);
caller_num_ok(5,$b->at(0,0,1) == 14);
caller_num_ok(6,$b->at(0,0,2) == 17);
caller_num_ok(7,$b->at(0,0,3) == 20);
caller_num_ok(8,$b->at(0,0,4) == 23);
caller_num_ok(9,$b->at(0,0,5) == 26);

# Now, start making affine stuffs...
# not yet.
exit(0);

print $a->slice("(0),(0)"),"\n";
$a0 = $a->slice("(0),(0)")->copy;

print $b;
$b->dump;
$b += 1;
$b->dump;
print $b;

print $a->slice("(0),(0)"),"\n";
$a1 = $a->slice("(0),(0)")->copy;

print $a1-$a0,"\n";

$t->call_trans_foomethod(11,6,6);

print $b->slice("(0),(0)"),"\n";
print $a->slice("(0),(0)"),"\n";
