package CGI::Session::BerkeleyDB;

use strict;
use vars qw($VERSION);
use base qw(CGI::Session CGI::Session::MD5);

use Data::Dumper;
use BerkeleyDB;

$VERSION = "1.1";


# do not use any indentation
$Data::Dumper::Indent = 0;

sub retrieve {
    my ($self, $sid, $options) = @_;

    my $file    = $options->{FileName};

    tie (my %session, "BerkeleyDB::Hash", -Filename=>$file, -Flags=>DB_RDONLY)
        or $self->error("Couldn't open $file, $! $BerkeleyDB::Error"), return;
    my $tmp = $session{$sid} or $self->error("Session ID '$sid' doesn't exist"), return;

    untie %session;

    my $data = {};  eval $tmp;

    return $data;
}





sub store {
    my ($self, $sid, $hashref, $options) = @_;

    my $file    = $options->{FileName};
    tie my %session, "BerkeleyDB::Hash", 
						-Filename => $file, 
						-Flags=> DB_CREATE 						
			or $self->error("Couldn't open $file: $! $BerkeleyDB::Error"), return;

    my $d = Data::Dumper->new([$hashref], ["data"]);

    $session{$sid} = $d->Dump();

    untie %session;

    return 1;
}



sub tear_down {
    my ($self, $sid, $options) = @_;

    my $file = $options->{FileName};

    tie (my %session, "BerkeleyDB::Hash", -Filename=>$file) or die $!;
    delete $session{$sid};
    untie %session;

}

1;

=pod

=head1 NAME

CGI::Session::BerkeleyDB - Driver for CGI::Session 

=head1 SYNOPSIS

    use constant COOKIE => "TEST_SID";  # cookie to store the session id

    use CGI::Session::BerkeleyDB;
    use CGI;

    my $cgi = new CGI;

    # getting the
    my $c_sid = $cgi->cookie(COOKIE) || undef;

    my $session = new CGI::Session::BerkeleyDB($c_sid,
        {
            LockDirectory   =>'/tmp/locks',
            FileName        => '/tmp/sessions.db'
        });

    # now let's create a sid cookie and send it to the client's browser.
    # if it is an existing session, it will be the same as before,
    # but if it's a new session, $session->id() will return a new session id.
    {
        my $new_cookie = $cgi->cookie(-name=>COOKIE, -value=>$session->id);
        print $cgi->header(-cookie=>$new_cookie);
    }

    print $cgi->start_html("CGI::Session::File");

    # assuming we already saved the users first name in the session
    # when he visited it couple of days ago, we can greet him with
    # his first name

    print "Hello", $session->param("f_name"), ", how have you been?";

    print $cgi->end_html();

=head1 DESCRIPTION

C<CGI::Session::BerkeleyDB> is the driver for C<CGI::Session> to store and retrieve
the session data in and from the Berkeley DB 2.x or better. For this you
need to have L<BerkeleyDB> installed properly. To be able to write your own
drivers for the L<CGI::Session>, please consult L<developer section|CGI::Session/DEVEROPER SECTION>
of the L<manual|CGI::Session>.

Constructor requires two arguments, as all other L<CGI::Session> drivers do.
The first argument has to be session id to be initialized (or undef to tell
the L<CGI::Session>  to create a new session id). The second argument has to be
a reference to a hash with a following required key/value pair:


If you do not have BerkeleyDB 2.x or better, you are better of going with 
L<CGI::Session::DB_File>, which is an interface for BerkeleyDB 1.x.

=over 4

=item C<Filename>

path to a file where all the session data will be stored

=back

C<CGI::Session::BerkeleyDB> uses L<Data::Dumper|Data::Dumper> to serialize the session data
before storing it in the session file.

For examples of the C<CGI::Session> usage, please refer to L<CGI::Session manual|CGI::Session>

=head1 AUTHOR

Sherzod B. Ruzmetov <sherzodr@cpan.org>

=head1 COPYRIGHT

This library is free software and can be redistributed under the same
conditions as Perl itself.

=head1 SEE ALSO

L<CGI::Session>, L<CGI::Session::File>, L<CGI::Session::DB_File>,
L<CGI::Session::MySQL>, L<Apache::Session>

=cut
