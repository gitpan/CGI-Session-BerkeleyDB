# $Id$
use strict;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

sub MY::postamble {
	return <<'MAKEFILE';
realclean::
	$(RM_RF) blib/
	$(RM_F) Makefile Makefile.old pod2htm* t/cgisess.*
MAKEFILE
}

WriteMakefile(
    NAME			=> 'CGI::Session::BerkeleyDB',
    VERSION_FROM	=> 'BerkeleyDB.pm',
    PREREQ_PM		=> {BerkeleyDB=>undef},
    ABSTRACT_FROM	=> 'BerkeleyDB.pm', 
    AUTHOR			=> 'Sherzod Ruzmetov <sherzodr@cpan.org>',
);
