# perl script to verify species name and neuron_id in the output from parse_raw_metadata_to_table.pl

# at the end of the output is a non-redundant species name list and a list of redundant neuron_id values

# example: perl verify_metadata_species_id.pl

use strict;
use List::MoreUtils qw(uniq);

my $line, my $line_no=0, my @row, my @sorted_id, my @sorted_species, my $column, my $column_no=0, my $column_species=0, my @species, my @id, my @unique_species, my @unique_id, my $column_id=0, my $element;

print "neuron_id\tspecies\n";

while ($line=<>){
	chomp $line;
	$line_no++;
	@row=split(/\t/,$line);
	if ($line_no == 1) {
		for $column(@row) {
			if ($column eq "species") {
				$column_species = $column_no;
			}
			if ($column eq "neuron_id") {
				$column_id = $column_no;
			}
			$column_no++;
		}
	} else {
		print $row[$column_id]."\t".$row[$column_species]."\n";
		push(@species,$row[$column_species]);
		push(@id,$row[$column_id]);
	}
}

print "\nAbove table has records by neuron_id to verify the species names are correct.\n\n";

@sorted_species = sort @species;
@sorted_id = sort @id;

@unique_species = uniq @sorted_species;
# @unique_id = uniq @sorted_id;

print "Below is a simple list of species names that appear in the above output:\n";

foreach $element (@unique_species) {
	print "$element; ";
}
print "\n\n";

print "Below is a list of neuron_id values that occur more than once:\n";

my %seen;
foreach $element (@id) {
	# print $element," ";
    next unless $seen{$element}++;
	print "$element; ";
}
print "\n";
