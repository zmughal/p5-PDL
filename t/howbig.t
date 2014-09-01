# Test datatype sizes in bytes are correct

use t::lib::TestHelper; # TODO migrate
use PDL::LiteF;
use PDL::Core ':Internal'; # For howbig()

print "1..6\n";

num_ok(1, howbig(byte(42)->get_datatype)==1);
num_ok(2, howbig(short(42)->get_datatype)==2);
num_ok(3, howbig(ushort(42)->get_datatype)==2);
num_ok(4, howbig(long(42)->get_datatype)==4);
num_ok(5, howbig(float(42)->get_datatype)==4);
num_ok(6, howbig(double(42)->get_datatype)==8);

