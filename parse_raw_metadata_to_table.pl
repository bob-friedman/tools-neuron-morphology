# example: perl parse_raw_metadata_to_table.pl <input file> <output file>

# header information that defines fields at first row of table

# use strict;
# use Data::Dumper;
use JSON qw(decode_json);

my $build_header=1, my $line, my @lines, my $line_no=0;

# input file name specified at command line after the perl script name
my $file1 = shift @ARGV;

# output file name specified at command line after the perl script name
my $file2 = shift @ARGV;

# open input file in read only mode
open (FILEIN, "<$file1") or die "Error: unable to open input file '$file1'\n";

# open output file in write mode
open (FILEOUT, ">$file2") or die "Error: unable to open output file '$file2'\n";

# add row # to first column of header row
push (@header,"row");

while (<FILEIN>){
	chomp $_;
	$input = $_;

	# print $input;

	my $obj = decode_json $input;

	# print data in human readable format for error checking
	# print Dumper $obj;

	# verify that scalar variable below refers to a hash type 
	# printf "reftype: %s\n", ref($obj);

	# print all keys in the hash variable type
	# print "key: $_\n" for keys %{$obj};

	for my $object_name (sort keys %$obj){
		# print "In $object_name:\n";
		if ($object_name =~ /page/){
			for my $key (sort keys %{ $obj->{$object_name} }){
					my $val = $obj->{$object_name}{$key};
					# print elements of page for records
					# print "$key\t$val\n";
			}
		}
		# neuronal data records
		if ($object_name =~ /_embedded/){
			my @obj_hash = @{$obj->{$object_name}->{'neuronResources'}};

			# dump of values for error checking
			# print Dumper @obj_hash;

			foreach my $hash_ref(@obj_hash){
				for $key (sort keys %{$hash_ref}){
					# disabled the printing of _links fields
					if ($key eq "_links"){
						# print $key."\t";
						if ($build_header == 1) {
						   push(@header,$key);
						}
						for $key2 (sort keys %{$hash_ref->{$key}}){
							print FILEOUT $key2.", ";
							for $key3 (sort keys %{$hash_ref->{$key}->{$key2}}){
								# $hash_ref->{$key}->{$key2}->{$key3} =~ tr/\n//d;
								print FILEOUT $key3.", ".$hash_ref->{$key}->{$key2}->{$key3}."; ";
							}
						}
						print FILEOUT "\t";
					}elsif ($key ne "brain_region" && $key ne "cell_type" && $key ne "experiment_condition" && $key ne "reference_doi" && $key ne "reference_pmid"){
						# may disable printing fields for 'note' if they contain special characters in final version
						if ($key eq "note"){
							$hash_ref->{$key} =~ tr/\n//d;
						}
						# print $key."\t";
						if ($build_header == 1) {
						   push(@header,$key);
						}
						print FILEOUT $hash_ref->{$key}."\t";
						if ($key eq "volume"){
							print FILEOUT "\n";
							$build_header=0;
						}
					}else{
						# print $key."\t";
						if ($build_header == 1) {
							push(@header,$key);
						}
						foreach $element(@{$hash_ref->{$key}}){
							print FILEOUT $element.", ";
						}
						print FILEOUT "\t";
					}
				}
			}
		}
	}
}
close (FILEIN);
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
	$line_no++;
	print FILEOUT $line_no."\t";
	print FILEOUT $line."\n";
}
close (FILEOUT);
