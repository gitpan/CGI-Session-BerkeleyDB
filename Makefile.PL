# $Id: Makefile.PL,v 3.2 2002/11/28 23:07:35 sherzodr Exp $
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
    PREREQ_PM		=> {BerkeleyDB=>undef, 'CGI::Session' => 3.5},
    ABSTRACT_FROM	=> 'BerkeleyDB.pm', 
    AUTHOR			=> 'Sherzod Ruzmetov <sherzodr@cpan.org>',
);
