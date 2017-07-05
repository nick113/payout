#!/usr/bin/perl -w
use strict;
use HTML::TokeParser;
use LWP::UserAgent;

my $ua      = LWP::UserAgent->new;
my $proxy   = '';
my $netloc  = '';
my $realm   = '';
my $uname   = '';
my $pass    = '';
$ua->credentials($netloc, $realm, $uname, $pass);
$ua->proxy( 'http', $proxy );

my $url = 'http://stackoverflow.com/';
$url .= '/' if $url =~ m|http://[^/]+$|i;  # add trailing / if forgott
#+en
my ($root) = $url =~ m|(http://.*/)|i;
#my $content = get( $url );
my $content = get( $url );
#print $content;

print "Checking links....\n";
my $parse = HTML::TokeParser->new( \$content );
while (my $token = $parse->get_tag('a')) {
   my $link = $token->[1]{href} || next;
   my $text=$parse->get_trimmed_text('/a');
   if ($link =~ m|^\s*mailto|i) {
      next;
   }
   elsif ($link=~ m|^\s*http://|i){
      print &test( $link, $text );
   } 
   else {
      $link =~ s|^\s*/||;
      print &test( $root.$link, $text );
   }
}

sub get {
    my $url = shift;
    print "Getting $url....";
    my $request = HTTP::Request->new( 'GET', $url );
    my $content = $ua->request( $request ); 
    print "$$content{_msg} $$content{_rc}\n";
  return $$content{_content};
}

sub test {
    my ( $url, $text ) = @_;
    my $request = HTTP::Request->new( 'HEAD', $url );
    my $content = $ua->request( $request );
  return  "$$content{_msg} $$content{_rc} ($text) $url\n";
}
