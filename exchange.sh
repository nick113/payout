#!/usr/bin/perl -w
use strict;
use HTML::TokeParser;
use LWP::UserAgent;
use IO::Socket::SSL;
use JSON;
use Data::Dumper;
use feature qw/ say /;

my $ua      = LWP::UserAgent->new;
my $proxy   = '';
my $netloc  = '';
my $realm   = '';
my $uname   = '';
my $pass    = '';
$ua->credentials($netloc, $realm, $uname, $pass);
$ua->proxy( 'http', $proxy );


my $url = 'https://api.coinbase.com/v2/exchange-rates';
my $rate=get_rate($url,'BTC');

print $rate;




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

sub get_rate {

my($url, $currency) = @_;

$url .= '/' if $url =~ m|http://[^/]+$|i;  # add trailing / if forgott
my ($root) = $url =~ m|(http://.*/)|i;
my $content = get( $url );
my $obj  = from_json( $content );
my $rate = $obj->{data}->{rates}->{$currency};



return $rate;

}

