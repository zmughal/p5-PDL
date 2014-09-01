#!/bin/perl -w

#
## Test of PDL::Char subclass -- treating byte PDLs as matrices of fixed strings
#

use t::lib::TestHelper; # TODO migrate
use PDL;
use PDL::Char;
use strict;

print "1..6\n";

my $a = PDL::Char->new ([[['abc', 'def', 'ghi'],['jkl', 'mno', 'qrs']],
		    [['tuv', 'wxy', 'zzz'],['aaa', 'bbb', 'ccc']]]);

my $stringized = $a->string;
my $comp = 
qq{[
 [
  [ 'abc' 'def' 'ghi'   ] 
  [ 'jkl' 'mno' 'qrs'   ] 
 ] 
 [
  [ 'tuv' 'wxy' 'zzz'   ] 
  [ 'aaa' 'bbb' 'ccc'   ] 
 ] 
] 
};


num_ok(1, ($stringized eq $comp));
$a->setstr(0,0,1, 'foo');
num_ok(2, ($a->atstr(0,0,1) eq 'foo'));
$a->setstr(2,0,0, 'barfoo');
num_ok(3, ($a->atstr(2,0,0) eq 'bar'));
$a->setstr(0,0,1, 'f');
num_ok(4, ($a->atstr(0,0,1) eq "f"));
$b = sequence (byte, 4, 5) + 99;
$b = PDL::Char->new($b);
$stringized = $b->string;
$comp = "[ 'cdef' 'ghij' 'klmn' 'opqr' 'stuv' ] \n";
num_ok(5, ($stringized eq $comp));



# Variable-length string test
my $varstr = PDL::Char->new( [ ["longstring", "def", "ghi"],["jkl", "mno", 'pqr'] ] );
 
# Variable Length Strings: Expected Results
my $comp2 = 
"[
 [ 'longstring' 'def' 'ghi'  ] 
 [ 'jkl' 'mno' 'pqr'  ] 
] 
";

num_ok(6, ("$varstr" eq $comp2));
