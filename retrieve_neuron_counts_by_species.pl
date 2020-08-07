# prints counts of neurons for all species
# use grep tool to parse output by species
# example: perl retrieve_neuron_counts_by_species.pl

# use strict;
use LWP::Simple qw(get);
# use Data::Dumper;
use JSON qw(decode_json);

my $species_stats = "http://neuromorpho.org/api/neuron/partition/species";
my $html = get $species_stats;

my $obj = decode_json $html;

# print data in human readable format for error checking
# print Dumper $obj;

# verify that scalar variable below refers to a hash type 
# printf "reftype: %s\n", ref($obj);

# print all keys in the hash variable type
# print "key: $_\n" for keys %{$obj};

# print species name and neuron count from the hash
for my $object_name (sort keys %$obj){
		# print "In $object_name:\n";
        for my $key (sort keys %{ $obj->{$object_name} }){
                my $val = $obj->{$object_name}{$key};
				if ($object_name eq "fields"){
	                print "$key\t$val\n";
				}
        }
}
