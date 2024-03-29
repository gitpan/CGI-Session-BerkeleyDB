# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

# $Id: api3_berkeleydb.t,v 3.0 2002/11/28 18:28:19 sherzodr Exp $
#########################

# change 'tests => 1' to 'tests => last_test_to_print';

BEGIN {     
    require Test;
    Test->import();
    
    plan(tests => 14); 
};

use CGI::Session qw/-api3/;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.
my $s = new CGI::Session("driver:BerkeleyDB", undef, {Directory=>"t"} );

ok($s);
    
ok($s->id);

$s->param(author=>'Sherzod Ruzmetov', name => 'CGI::Session', version=>'1'   );

ok($s->param('author'));

ok($s->param('name'));

ok($s->param('version'));


$s->param(-name=>'email', -value=>'sherzodr@cpan.org');

ok($s->param(-name=>'email'));

ok(!$s->expire() );

$s->expire("+10m");

ok($s->expire());

my $sid = $s->id();

$s->flush();

my $s2 = new CGI::Session("driver:BerkeleyDB", $sid, {Directory=>'t'});
ok($s2);

ok($s2->id() eq $sid);

ok($s2->param('email'));
ok($s2->param('author'));
ok($s2->expire());


$s2->delete();


