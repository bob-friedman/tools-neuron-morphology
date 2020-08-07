# retrieves neuronal morphology data by neuron_id

# requires the raw neuron metadata file for input

# example: perl retrieve_morphology_by_neuron.pl <neuron metadata filename> <output file name>

# header information that defines fields at first row of table

# use strict;
use LWP::Simple qw(get);
# use Data::Dumper;
use JSON qw(decode_json);

my $line_no=0, my $neuron_morph_records, my $id, my $line, my $retrieval, my $key, my @neuronid;

# input file name specified at command line after the perl script name
my $file1 = shift @ARGV;

# output file name specified at command line after the perl script name
my $file2 = shift @ARGV;

# open input file in read only mode
open (FILEIN, "<$file1") or die "Error: unable to open input file '$file1'\n";

# test output file in write mode
open (FILEOUT, ">$file2") or die "Error: unable to open output file '$file2'\n";
close (FILEOUT);

while ($line=<FILEIN>) {
	chomp $line;

	my $obj = decode_json $line;

	# print data in human readable format for error checking
	# print Dumper $obj;

	# verify that scalar variable below refers to a hash type 
	# printf "reftype: %s\n", ref($obj);

	# print all keys in the hash variable type
	# print "key: $_\n" for keys %{$obj};

	my @obj_hash, my $hash_ref='';

	for my $object_name (keys %$obj){
		# neuronal data records
		if ($object_name =~ /_embedded/){
			@obj_hash = @{$obj->{$object_name}->{'neuronResources'}};

			# dump of values for error checking
			# print Dumper @obj_hash;

			foreach $hash_ref(@obj_hash){
				for $key (keys %$hash_ref){
					if ($key eq "neuron_id"){
						push(@neuronid,$hash_ref->{$key});
					}
				}
			}
		}
	}
}

close (FILEIN);

# open output file in write mode
open (FILEOUT, ">$file2") or die "Error: unable to open output file '$file2'\n";

# add row # to first column of header row
push (@header,"row");

print STDERR "\n"."Retrieving records";

foreach $id(@neuronid) {
	$line_no++;

	$retrieval = "http://neuromorpho.org/api/morphometry/id/$id";
	$neuron_morph_records = get $retrieval;

	my $obj = decode_json $neuron_morph_records;

	if (($line_no % 10) == 0) {
		print STDERR "\.";
	}

	# dump of values for error checking
	# print Dumper $obj;

	print FILEOUT $line_no."\t";
	foreach $key (sort keys %{$obj}){
		if($line_no == 1) {
			push (@header,$key);
		}
		print FILEOUT $obj->{$key}."\t";
	}
	print FILEOUT "\n";
}
close (FILEOUT);

# open output file in read mode
open (FILEOUT, "<$file2") or die "Error: unable to open output file '$file2'\n";

while ($line=<FILEOUT>) {
	chomp $line;
	push (@lines,$line);
}
close (FILEOUT);

# open output file in write mode
open (FILEOUT, ">$file2") or die "Error: unable to open output file '$file2'\n";

foreach $line(@header){
	print FILEOUT $line."\t";
}
print FILEOUT "\n";

foreach $line(@lines){
	print FILEOUT $line."\n";
}
close (FILEOUT);

print STDERR "\n";
