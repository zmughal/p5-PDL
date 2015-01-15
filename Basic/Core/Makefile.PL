use strict;
use warnings;
use File::Spec;
use Devel::CheckLib;
use PDL::Core::Dev;
use Config;
use IO::File;
use ExtUtils::MakeMaker;

## $DB::single = 1;  # uncomment to have debugger stop here

my $pthread_include = $Config::Config{usrinc};  # not good for win32
my $pthread_library = '-lpthread';              # not good for MSVC
my $pthread_define  = ' -DPDL_PTHREAD ';

my $macos_braindamage_define = ($^O eq 'darwin') ? " -DMACOS_MZERO_BRAINDAMAGE " : "";

my $malloclib = $PDL::Config{MALLOCDBG}->{libs};
my $mallocinc = $PDL::Config{MALLOCDBG}->{include};

my $fh = IO::File->new( "> mymalloc.p" )
  or die "couldn't open mymalloc.p";
if ( defined $PDL::Config{MALLOCDBG}->{define} ) {
    $fh->print( "\$mymalloc = <<'EOM';\n$PDL::Config{MALLOCDBG}->{define}\nEOM\n" );
} else {
    $fh->print( "\$mymalloc = '';\n" );
}
$fh->print( "1;\n" );
$fh->close;

print "Trying to figure out POSIX threads support ...\n";

# TODO: replace directory and file checks for pthread.h by Devel::CheckLib test
if ( exists $PDL::Config{POSIX_THREADS_INC} and  defined $PDL::Config{POSIX_THREADS_INC} ) {
    $pthread_include = $PDL::Config{POSIX_THREADS_INC};
    print "\t..setting \$pthread_include to $pthread_include\n";
} elsif (-d $pthread_include) {
    print "\tSaw pthread.h. Fine.\n";
    $pthread_include = "-I$pthread_include"
} else {
    print "\tEhh. Didn't see include file 'pthread.h'.\n";
    $pthread_include = '';
}

# For SGI, I had to link a new perl - cannot dlopen libpthread...
require Config;

# TODO: need to clean up per-platform logic herer
if ( exists $PDL::Config{POSIX_THREADS_LIBS} and defined $PDL::Config{POSIX_THREADS_LIBS} ) {
    $pthread_library = $PDL::Config{POSIX_THREADS_LIBS};
    print "\tUsing POSIX_THREADS_LIBS from perldl.conf\n";
} elsif ($Config::Config{libs} =~ /-lpthread/) {   # wrong
    print "\tFine, your perl was linked against pthread library.\n";
} elsif ($^O eq 'dec_osf') {
    if ($Config::Config{usemymalloc} eq 'n') {
        print "\tFine pthread, works with Digital Unixs malloc\n";
    } else {
        #
        print "\tPerls malloc has problems when perl is not linked with -lpthread\n";
        $pthread_library = '';
    }
} elsif ($^O eq 'freebsd'){
    if ($Config::Config{libs} =~ /-lc_r/) {
        print "\tGood, found -lc_r on a freebsd system.\n";
    } else {
        print "On FreeBSD try building perl with libc_r instead of libc\n";
        $pthread_library = '';
    }
 } elsif ($^O =~ /bsd$/i){
    if ($Config::Config{ldflags} =~ /-pthread/) {
       if ($Config::Config{usemymalloc} eq 'y') {
          print "\tGood, usemymalloc=y, will build with pthread support\n";
       } else {
          print "\tGot usemymalloc=$Config::Config{usemymalloc} so not building with pthreads\n";
          $pthread_library = '';
       }
    } else {
          print "\tMissing '-pthread' from ldflags=$Config::Config{lddlflags} so not building with pthreads\n";
          $pthread_library = '';
    }
 } else {
    print "\tNope, your perl was not linked against pthread library\n";
    if ($^O =~ /mswin/i or $^O =~ /cygwin/i) {
       if (check_lib(LIB=>'-lpthread',header=>'pthread.h')) {
          print "\tWe found -lpthread and pthread.h so will build anyway\n";
          $pthread_library = '-lpthread';
       } else {
          $pthread_library = '';
       }
    } else {
       print "\tWe'll try the default -lpthread anyway\n";
       # $pthread_library = '';
    }
 }

$pthread_include = $pthread_library = '' unless $pthread_include and $pthread_library;

{
    # TODO: use a Devel::CheckLib build/run test to verify working build params
    my $conf = $PDL::Config{WITH_POSIX_THREADS};

    if ((!defined($conf) or $conf)
	and $pthread_include and $pthread_library) {
	print "\t==> Will build PDL with POSIX thread support. Gifts to TJL :-)\n";
	$PDL::Config{WITH_POSIX_THREADS} = 1;
    } elsif($conf) {
	print "\t==> I couldn't find pthread support. However, you have\n";
	print "\t    turned on the forcing option in PDL_CONFIG so I guess I gotta do it\n";
    } else {
	print "\t==> PDL will be built without POSIX thread support.\n";
	print "\t==> *NOTE*: PDL threads are unrelated to perl threads (usethreads=y)!\n";
	print "\t==> Enabling perl threads will not help!\n";
	$pthread_define = '';
	$PDL::Config{WITH_POSIX_THREADS} = 0;
    }
}

print "Trying to figure out endian-ness of machine...";
print " It is " . (PDL::Core::Dev::isbigendian() ? "big" : "little") . " endian\n";

undef &MY::postamble; # suppress warning
*MY::postamble = sub {
  my @m = PDL::Core::Dev::postamble();
  push @m, "\npdlsections.c : ../../lib/PDL/Types.pm\n";
  join '', @m;
};

WriteMakefile(
 'NAME'	        => 'PDL::Core',
 'VERSION_FROM' => '../../lib/PDL/Version.pm',
 'OBJECT'       => 'Core$(OBJ_EXT) pdlcore$(OBJ_EXT) pdlapi$(OBJ_EXT) '.
                   'pdlhash$(OBJ_EXT) pdlthread$(OBJ_EXT) '.
                   'pdlconv$(OBJ_EXT) pdlmagic$(OBJ_EXT) pdlsections$(OBJ_EXT) ',
 'DEFINE' 	=> $pthread_define.$macos_braindamage_define,
 'LIBS'         => ["$pthread_library $malloclib"],
 'clean'        => {'FILES'  => 'pdlcore$(OBJ_EXT) pdlapi$(OBJ_EXT) '.
                   'pdlhash$(OBJ_EXT) pdlconv$(OBJ_EXT) pdlsections$(OBJ_EXT) '.
                   'pdlconv.c pdlsections.c pdlcore.c '.
		   'pdl.h pdlsimple.h pdlcore.h '.
		   'Types.pm Core.pm Core.c Core.xs ' .
		   'mymalloc.p badsupport.p'
		   },
 'INC'          => join(' ',
   PDL_INCLUDE(), map {length($_) ? qq{"$_"} : ()} $pthread_include, $mallocinc
 ),
 'NO_MYMETA' => 1,
);
