# this script has a time to completion that is dependent on network speed
# typical time to completion is in many minutes not seconds
# prints neuron data for a species

# downloads data to a file per page of neuron records
# stores the data in unique filenames by system time and page number

# example: perl retrieve_neuron_metadata_by_species.pl

use strict;
use LWP::Simple qw($ua get);

print "\nRun species-neuron-counts.pl if the exact species name is not known for the query of the web database\n\n";

print "This script requires time to download all neuronal records for a species\n\n";

print "A file is created to store the neuronal records and the file name is appended with a unique number\n\n";

print "Enter below the species name to retrieve its neuronal data:\n";
my $species_name = <STDIN>;
chomp $species_name;

if ($species_name eq ""){
	print "Error: species name not entered\n";
	exit;
}

print "\nRetrieving neurons for species name: $species_name\n\n";

my $initial_retrieval = 'http://neuromorpho.org/api/neuron/select?q=species:'."\"".$species_name."\"";
my $total_pages = get $initial_retrieval;

print "Using this URL to search for neurons: \n".$initial_retrieval."\n\n";

# print neuron data per species for error checking
# print $initial_retrieval;

$total_pages =~ s/{.*{//;

# parse the number of total pages in neuronal database
$total_pages =~ s/totalPages":(.*?),//;

# check number of total pages from above regular expression
# print "\nNumber of pages of neuronal records to retrieve: $1\n\n";
my $total_pages = $1 - 1; 

my $iterate=0, my $retrieval, my $neuron_records, my $all_records;
my $epoc = time();

# file name for output of neuronal records
my $filename = 'neuron_data_';
my $species_name_2 = $species_name;
$species_name_2 =~ s/ /_/g;
$species_name_2 =~ s/\./_/g;
$filename .= $species_name_2;
$filename .= "_".$epoc;	
open(my $filehandle, '>', $filename) or die "Error: unable to open file '$filename'\n";

for ($iterate; $iterate < $total_pages + 1; $iterate++){
	# retrieve all neuron records in database by page
	$retrieval = 'http://neuromorpho.org/api/neuron/select?'."page=".$iterate."&"."q=species:"."\"".$species_name."\"";
	$neuron_records = get $retrieval;
	print $filehandle $neuron_records;

	if ($iterate < $total_pages) {
		print $filehandle "\n";
	}

	print "Writing page $iterate of $total_pages of neuron data to '$filename'\n";
	
	# error check for correct URL to retrieve data from web database
	# print "Using this URL: $retrieval"."\n";
}
close $filehandle;

print "\nRetrieval of neuronal records complete but not yet checked for error\n";
