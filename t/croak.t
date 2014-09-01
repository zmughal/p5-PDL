use t::lib::TestHelper; # TODO migrate
use PDL::LiteF;
# sub tapprox {
# 	my($a,$b) = @_;
# 	$c = abs($a-$b);
# 	$d = max($c);
# 	$d < 0.01;
# }

if($^O !~ /mswin32/i) {$SIG{BUS} = \&not_ok}
$SIG{SEGV} = \&not_ok;

sub not_ok {
	print STDERR "\ngot fatal signal\n";
	print "not ok ".$::i."\n";
	exit;
}

print "1..4\n";

# PDL::Core::set_debugging(1);
$b = pdl [[1,1,1],[2,2,2]];

# we are using more dims than are available
$i = 1;
eval {$c = $b->slice(':,:,:,(1)'); $c->make_physical();};
print "ERROR WAS: '$@'\n";
num_ok(1,$@ =~ /too many dims/i);

$i++;
# now see if we survive the destruction of this invalid trans
$b = zeroes(5,3,3);
$c = $b->slice(":,:,1");
num_ok(2,1);  # if we're here we survived

$i++;
$b = pdl [[1,1,1],[2,2,2]];
eval {$c = $b->dummy(5,1); $c->make_physical();};
num_ok(3,!$@);

$i++;
$b = zeroes(5,3,3);
$c = $b->slice(":,:,1");
num_ok(4,1);

# if we're here we survived


