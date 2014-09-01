# NOTE: 
#  currently not in use anymore
#  - see PDL::Func (in Lib/) and t/func.t
use t::lib::TestHelper; # TODO migrate
print "1..1\nok 1 # Skipped: see PDL::Func\n";
exit;

use PDL::LiteF;

BEGIN {
    eval "use PDL::Slatec;";
    $loaded = ($@ ? 0 : 1);
}
 
my $ntests = 11;
print "1..$ntests\n";
unless ($loaded) {
    for (1..$ntests) {
	print "ok $_ # Skipped: PDL::Slatec not available.\n";
    }
    exit;
}                                                                               

use strict;

eval "use PDL::Interpolate::Slatec";

########### First test normal subclassing ###########

my $x   = sequence(float,10);
my $y   = $x*$x + 0.5;

my $obj = new PDL::Interpolate::Slatec( x => $x, y => $y );

ctr_ok( UNIVERSAL::isa( $obj, 'PDL::Interpolate' ) );
ctr_ok( $obj->library eq "Slatec" );
ctr_ok( $obj->status == 1 );

my ( $xi, $yi, $gi, $ans, $d );

$xi = sequence(float,5) + 2.3;
$yi = $obj->interpolate( $xi );
ctr_ok( $obj->status == 1 );

$ans = $xi*$xi + 0.5;
$d   = abs( $ans - $yi );
ctr_ok( all $d <= 0.03 );

( $yi, $gi ) = $obj->interpolate( $xi );
ctr_ok( $obj->status == 1 );

$ans = 2*$xi;
$d   = abs( $ans - $gi );
ctr_ok( all $d <= 0.04 );

# see how they cope with threading 
#
$y = cat( $x*$x+43.3, $x*$x*$x-23 );

$obj->set( x => $x, y => $y );
ctr_ok( $obj->status == 1 );

$yi = $obj->interpolate( $xi );
ctr_ok( $obj->status == 1 );
ctr_ok( (dims($yi) == 2) & ($yi->getdim(0) == $xi->getdim(0)) & ($yi->getdim(1) == 2) );

$ans = cat( $xi*$xi+43.3, $xi*$xi*$xi-23 );
$d   = abs( $ans - $yi );
ctr_ok( all $d <= 6 );

# end


