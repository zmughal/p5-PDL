use PDL;
use PDL::IO::Pic;
use PDL::ImageRGB;
use PDL::Dbg;
use File::Temp qw(tempdir);
use File::Spec;

# we need tests with index shuffling once vaffines are fixed
use t::lib::TestHelper;

sub tapprox {
	my($a,$b,$mdiff) = @_;
	$mdiff = 0.01 unless defined($mdiff);
	my $c = abs($a-$b);
	my $d = max($c);
	$d < $mdiff;
}

sub rpic_unlink {
  my $file = shift;
  my $pdl = PDL->rpic($file);
  unlink $file;
  return $pdl;
}

sub depends_on {
  print "# ushort is ok with $_[0]\n"
	if $PDL::IO::Pic::converter{$_[0]}->{ushortok};
  return 1 if $PDL::IO::Pic::converter{$_[0]}->{ushortok};
  return 256;
}

sub check {
  my ($err,$i) = @_;
  if ($err =~ /maxval is too large/) {
    print STDERR
       "skipping test $i (recompile pbmplus with PGM_BIGGRAYS!)\n"
  } else {
    print STDERR "skipping test $i (unknownm error: $err)\n"
  }
}

sub mmax { return $_[0] > $_[1] ? $_[0] : $_[1] }

$::warned = 0;
sub tifftest {
  my ($form) = @_;
  return 0 unless $form eq 'TIFF';
  warn "WARNING: you are probably using buggy tiff converters.
     Check IO/Pnm/converters for patched source files\n" unless $::warned;
  $warned = 1;
  return 1;
}

$PDL::debug = 0;
$PDL::IO::Pic::debug = 0;
$iform = 'PNMRAW'; # change to PNMASCII to use ASCII PNM intermediate
                   # output format

#              [FORMAT, extension, ushort-divisor,
#               only RGB/no RGB/any (1/-1/0), mxdiff]
#  no test of PCX format because seems to be severely brain damaged
%formats = ('PNM'  => ['pnm',1,0,0.01],
	    'GIF'  => ['gif',256,0,1.01],
	    'TIFF' => ['tif',1,0,0.01],
	    'RAST' => ['rast',256,0,0.01],
#	    'SGI'  => ['rgb',1,1,0.01],
 	    'PNG'  => ['png',1,1,0.01],
	   );

# only test PNM format
# netpbm has too many bugs on various platforms
@allowed = ();
## for ('PNM') { push @allowed, $_
for (keys %formats) {
   if (PDL->rpiccan($_) && PDL->wpiccan($_) && defined $formats{$_}) {
      push @allowed, $_;
   }
}

$ntests = 2 * (@allowed);
if ($ntests < 1) {
  print("1..1\n"); # dummy
  num_ok(1,1);
  exit;
}

print("1..$ntests\n");

print "# Testable formats on this platform:\n#  ".join(',',@allowed)."\n";


$im1 = ushort pdl [[[0,0,0],[256,65535,256],[0,0,0]],
		   [[256,256,256],[256,256,256],[256,256,256]],
		   [[2560,65535,2560],[256,2560,2560],[65535,65534,65535]]];
$im2 = byte ($im1/256);

if ($PDL::debug){
   print $im1;
   print $im2;
}

$n = 1;
$usherr = 0;
my $tmpdir = tempdir( CLEANUP => 1 );
sub tmpfile { File::Spec->catfile($tmpdir, $_[0]); }
foreach $form (sort @allowed) {
    print "# ** testing $form format **\n";

    $arr = $formats{$form};
    my $tushort = tmpfile("tushort.$arr->[0]");
    my $tbyte = tmpfile("tbyte.$arr->[0]");
    eval '$im1->wpic($tushort,{IFORM => $iform});';
    if ($@) { check($@,$n); $usherr = 1 } else { $usherr=0}
    $im2->wpic($tbyte,{IFORM => $iform});

    $in1 = rpic_unlink($tushort) unless $usherr;
    $in2 = rpic_unlink($tbyte);

    $comp = $im1 / PDL::ushort(mmax(depends_on($form),$arr->[1]));
    print "# Comparison arr: $comp" if $PDL::debug;
    numbad_ctr_ok($n++,$usherr || tapprox($comp,$in1,$arr->[3]) || tifftest($form));
    numbad_ctr_ok($n++,tapprox($im2,$in2) || tifftest($form));

    if ($PDL::debug) {
      print $in1->px;
      print $in2->px;
    }
}

use Data::Dumper;
if ($numbad > 0) {
   local $Data::Dumper::Pad = '#';
   print "# Dumping diagnostic PDL::IO::Pic converter data...\n";
   print Dumper(\%PDL::IO::Pic::converter);
}

