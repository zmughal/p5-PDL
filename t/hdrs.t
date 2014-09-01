use t::lib::TestHelper; # TODO migrate
use PDL::LiteF;

$|=1;

#  PDL::Core::set_debugging(1);
kill INT,$$  if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

sub hdrcmp {
  my ($ah,$bh) = map {$_->gethdr} @_;
# Copy-by-reference test is obsolete; check contents instead (CED 12-Apr-2003)
#   return $ah==$bh
  my %ahh = %{$ah};
  my (@ahhkeys) = sort keys %ahh;
  my %bhh = %{$bh};
  my (@bhhkeys) =  sort keys %bhh;
  return join("",@bhh{@bhhkeys}) eq join("",@ahh{@ahhkeys});
}

print "1..9\n";

$a = zeroes(20);
$a->hdrcpy(1);
$a->dump;
$a->sethdr( {Field1=>'arg1',
	     Field2=>'arg2'});
print "a: ",$a->gethdr(),"\n";
num_ok(1,$a->hdrcpy);

$b = $a+1;
print "b: ",$b->gethdr(),"\n";
num_ok(2, defined($b->gethdr));
num_ok(3,hdrcmp($a,$b));

$b = ones(20) + $a;
print "b: ",$b->gethdr(),"\n";
num_ok(4, defined($b->gethdr));
num_ok(5,hdrcmp($a,$b));

$c = $a->slice('0:5');
print "c: ",$c->gethdr(),"\n";
num_ok(6,hdrcmp($a,$c));

$d = $a->copy;
print "d: ",$d->gethdr(),"\n";
num_ok(7,hdrcmp($a,$d));

$a->hdrcpy(0);
num_ok(8,defined($a->slice('3')->hdr) && !( keys (%{$a->slice('3')->hdr})));
num_ok(9,!defined($a->slice('3')->gethdr));
