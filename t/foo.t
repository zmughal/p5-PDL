use PDL::LiteF;

use strict;
use warnings;

use Test::More tests => 9;

kill 'INT',$$ if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

# PDL::Core::set_debugging(1);

# Test basic use of foomethod.

my $pa = zvals zeroes 2,2,50;

my $pb = $pa->oneslice(2,10,2,5);

is($pb->at(0,0,0), 10);
is($pb->at(0,0,1), 12);
is($pb->at(0,0,4), 18);

# we don't test the foomethod
# had to disable some code that
# is required for foomethod since
# it caused another bug in more important code (see pdl_changed in pdlapi.c)

my $pt = $pb->get_trans;

SKIP: {
	skip 'TODO', 6;

	$pt->call_trans_foomethod(11,3,6);

	$pb->make_physical();

	is($pb->at(0,0,0), 11);
	is($pb->at(0,0,1), 14);
	is($pb->at(0,0,2), 17);
	is($pb->at(0,0,3), 20);
	is($pb->at(0,0,4), 23);
	is($pb->at(0,0,5), 26);
}

# Now, start making affine stuffs...
# not yet.

SKIP: {
	skip 'TODO', 0;
	note $pa->slice("(0),(0)"),"\n";
	my $a0 = $pa->slice("(0),(0)")->copy;

	note $pb;
	$pb->dump;
	$pb += 1;
	$pb->dump;
	note $pb;

	note $pa->slice("(0),(0)"),"\n";
	my $a1 = $pa->slice("(0),(0)")->copy;

	note $a1-$a0,"\n";

	$pt->call_trans_foomethod(11,6,6);

	note $pb->slice("(0),(0)");
	note $pa->slice("(0),(0)");
}

done_testing;
