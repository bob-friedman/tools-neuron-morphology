# join the metadata and morphology tables

# specify both tables as file names at the command line and redirect the joined table to a new file name

# perl join_metadata_morphology_tables.pl <metadata file> <morphology data> > neuron_tables_joined.txt

$file1 = shift @ARGV;
$file2 = shift @ARGV;

open (FILEA,"$file1");
open (FILEB,"$file2");

@first=<FILEA>;
@second=<FILEB>;

close FILEA;
close FILEB;


foreach (@second) {
 chomp;
 @record1 = split(/\t/,$_);
 $hash1{$record1[0]} = $_;
}

foreach (@first) {
 chomp;
 @record2 = split(/\t/,$_);
 print $_.$hash1{$record2[0]}."\n";
}

