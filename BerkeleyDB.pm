package CGI::Session::BerkeleyDB;

# $Id: BerkeleyDB.pm,v 3.0 2002/11/28 18:28:17 sherzodr Exp $

use strict;
use base qw(
    CGI::Session
    CGI::Session::ID::MD5
    CGI::Session::Serialize::Default
);


# Load neccessary libraries below
use File::Spec;
use BerkeleyDB;

use vars qw($VERSION $REVISION $FileName);

$FileName = 'cgisess.db';


($REVISION) = '$Revision: 3.0 $' =~ m/Revision:\s*(\S+)/;
$VERSION = '3.0';

sub store {
    my ($self, $sid, $options, $data) = @_;

    my $storable_data = $self->freeze($data);

    my $args = $options->[1] || {};

    my $filename = File::Spec->catfile($args->{Directory},
                            $args->{FileName} || $FileName );

    tie (my %db, "BerkeleyDB::Hash", -Filename=>$filename, -Flags=>DB_CREATE)
                or die $!;
    $db{$sid} = $storable_data;
    untie(%db);

    return 1;
}


sub retrieve {
    my ($self, $sid, $options) = @_;

    # you will need to retrieve the stored data, and
    # deserialize it using $self->thaw() method

    my $args = $options->[1] || {};
    my $filename = File::Spec->catfile($args->{Directory},
                                $args->{FileName} || $FileName);

    tie (my %db, "BerkeleyDB::Hash", -Filename=>$filename, -Flags=>DB_RDONLY)
                    or die $!;
    unless ( defined $db{$sid} ) {
        untie(%db);
        return undef;
    }

    my $data = $self->thaw($db{$sid});
    untie(%db);
    return $data;
}



sub remove {
    my ($self, $sid, $options) = @_;

    # you simply need to remove the data associated
    # with the id

    my $args = $options->[1] || {};
    my $filename = File::Spec->catfile($args->{Directory},
                    $args->{FileName} || $FileName);

    tie (my %db, "BerkeleyDB::Hash", -Filename=>$filename) or die $!;
    unless ( defined $db{$sid} ) {
        untie(%db);
        return undef;
    }
    delete $db{$sid};
    untie(%db);

    return 1;
}



sub teardown {
    my ($self, $sid, $options) = @_;

    # this is called just before session object is destroyed
}




# $Id: BerkeleyDB.pm,v 3.0 2002/11/28 18:28:17 sherzodr Exp $

1;

=pod

=head1 NAME

CGI::Session::BerkeleyDB - BerkeleyDB CGI::Session driver

=head1 SYNOPSIS

    use CGI::Session qw/-api3/;
    $session = new CGI::Session("driver:BerkeleyDB", undef,
                                    {Directory=>'/tmp'} );

For more examples, consult L<CGI::Session> manual

=head1 DESCRIPTION

CGI::Session::BerkeleyDB is a CGI::Session driver to store session data in BerkeleyDB 2.x or better. If you have older version of BerkeleyDB, use L<DB_File|CGI::Session::DB_File> driver instead.

To write your own drivers for B<CGI::Session> refere to L<CGI::Session> manual.

The driver requires both BerkeleyDB and  L<BerkeleyDB> Perl interface installed.
You can download latest version of BerkeleyDB from http://www.sleepycat.com .
Latest release of L<BerkeleyDB> Perl interface can be acquired from your nearest CPAN mirror.

=head1 ATTRIBUTES

The only driver attribute required is B<Directory>, which denotes the location where session database and necessary locks to be stored. By default, name of the session database file is "cgisess.db". If you'd rather use a different name, there's B<FileName> attribute you can set:

    $session = new CGI::Session("driver:BerkeleyDB", undef,
                    {Directory=>'/tmp', FileName=>'my_sessions.db'});

=head1 COPYRIGHT

Copyright (C) 2002 Sherzod Ruzmetov. All rights reserved.

This library is free software and can be modified and distributed under the same
terms as Perl itself.

=head1 AUTHOR

Sherzod Ruzmetov <sherzodr@cpan.org>

Feedbacks, suggestions and patches are welcome.

=head1 SEE ALSO

=over 4

=item *

L<CGI::Session|CGI::Session> - CGI::Session manual

=item *

L<DB_File|CGI::Session::DB_File> - BerkeleyDB driver for BerkeleyDB 2.x and older.

=item *

L<CGI::Session::Tutorial|CGI::Session::Tutorial> - extended CGI::Session manual

=item *

L<CGI::Session::CookBook|CGI::Session::CookBook> - practical solutions for real life problems

=item *

B<RFC 2965> - "HTTP State Management Mechanism" found at ftp://ftp.isi.edu/in-notes/rfc2965.txt

=item *

L<CGI|CGI> - standard CGI library

=item *

L<Apache::Session|Apache::Session> - another fine alternative to CGI::Session

=back

=cut


# $Id: BerkeleyDB.pm,v 3.0 2002/11/28 18:28:17 sherzodr Exp $
