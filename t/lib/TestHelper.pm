package
	t::lib::TestHelper;

use strict;
use warnings;
use parent 'Exporter'; 
our @EXPORT = qw(num_ok ctr_ok caller_num_ok numbad_ctr_ok $numbad);

sub num_ok {
        my $no = shift ;
        my $result = shift ;
        print "not " unless $result ;
        print "ok $no\n" ;
}

my $ctr = 0;
sub ctr_ok {
    $ctr++;
    my $result = shift ;
    print "not " unless $result ;
    print "ok $ctr\n" ;
}

sub caller_num_ok {
	my $no = shift ;
	my $result = shift ;
	if($ENV{PDL_T}) {
		if($result) { print "ok $no\n";return }
		my ($p,$f,$l) = caller;
		print "FAILED TEST $no AT $p $f $l\n";
	} else {
		print "not " unless $result ;
		print "ok $no\n" ;
	}
}

our $numbad = 0;
sub numbad_ctr_ok {
	my $no = shift ;
	my $result = shift ;
	print "not " unless $result ;
	print "ok $no\n" ;
        $numbad++ unless $result;
        $result;
}


1;
