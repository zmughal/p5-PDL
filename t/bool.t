use t::lib::TestHelper; # TODO migrate
use PDL::LiteF;
use Test::More tests => 5;
use Test::Exception;

use strict;
use warnings;

$|=1;

#  PDL::Core::set_debugging(1);
kill 'INT',$$  if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

sub pok { print "ok $_[0]\n" }

{
	my $pa = zeroes 1,1,1;
	ok !$pa;
}

{
	my $pa = ones 3;
	throws_ok { print "oops\n" if $pa } qr/multielement/;
}

{
	my $pa = ones 3;
	ok( all $pa );
}

{
	my $pa = pdl byte, [ 0, 0, 1 ];
	ok( any $pa > 0 );
}

{
	my $pa = ones 3;
	my $pb = $pa + 1e-4;
	ok( all PDL::approx($pa, $pb, 1e-3) ) ;
}

done_testing;
