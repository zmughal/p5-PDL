package
	t::lib::TestHelper;

use strict;
use warnings;
use parent 'Exporter'; 
our @EXPORT = qw(num_ok);

sub num_ok {
        my $no = shift ;
        my $result = shift ;
        print "not " unless $result ;
        print "ok $no\n" ;
}

1;
