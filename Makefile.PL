use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'CGI::Session::BerkeleyDB',
    'VERSION_FROM'	=> 'BerkeleyDB.pm', # finds $VERSION
    'PREREQ_PM'		=> {CGI::Session=>2.4, BerkeleyDB => 0.18}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'BerkeleyDB.pm', # retrieve abstract from module
       AUTHOR     => 'Sherzod B. Ruzmetov <sherzodr@cpan.org>') : ()),
);
