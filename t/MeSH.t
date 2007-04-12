# This is -*-Perl-*- code
## Bioperl Test Harness Script for Modules
##
# $Id$

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'

use strict;
use vars qw($NUMTESTS $DEBUG);
$DEBUG = $ENV{'BIOPERLDEBUG'} || 0;

my $error;

BEGIN {
	eval { require Test::More; };
	$error = 0;
	if( $@ ) {
		use lib 't';
	}
	use Test::More;
	$NUMTESTS = 25;
	eval { require IO::String; 
			 require LWP::UserAgent;
			 require HTTP::Request::Common;
       };
	if( $@ ) {
		plan skip_all => "IO::String or LWP::UserAgent or HTTP::Request not installed. This means the MeSH modules are not usable. Skipping tests.";
	} else {
		plan tests => $NUMTESTS;
	}		
	use_ok('Bio::Phenotype::MeSH::Term');
	use_ok('Bio::Phenotype::MeSH::Twig');
	use_ok('Bio::DB::MeSH');
}
# For tests of Bio::DB::MeSH see t/DB.t

my $verbose = 0;

ok my $term = Bio::Phenotype::MeSH::Term->new(-verbose =>$verbose);
is $term->id('D000001'), 'D000001';
is $term->id, 'D000001';
is $term->name('Dietary Fats'), 'Dietary Fats';
is $term->name, 'Dietary Fats';
is $term->description('dietary fats are...'), 'dietary fats are...';
is $term->description, 'dietary fats are...';

ok my $twig = Bio::Phenotype::MeSH::Twig->new(-verbose =>$verbose);
is $twig->parent('Fats'), 'Fats';
is $twig->parent(), 'Fats';


ok $term->add_twig($twig);
is $term->each_twig(), 1;
is $twig->term, $term;

is $twig->add_sister('Bread', 'Candy', 'Cereals'), 3;
is $twig->add_sister('Condiments', 'Dairy Products'), 2;
is $twig->each_sister(), 5;
ok $twig->purge_sisters();
is $twig->each_sister(), 0;

is $twig->add_child('Butter', 'Margarine'), 2;
is $twig->each_child(), 2;
ok $twig->purge_children();
is $twig->each_child(), 0;


