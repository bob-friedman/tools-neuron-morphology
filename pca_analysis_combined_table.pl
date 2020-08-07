# Principal components analysis of a table of neuronal morphological characters states

# example: pca_analysis_combined_table.pl

use strict;

use Statistics::PCA;
 
# Create new Statistics::PCA object.
my $pca = Statistics::PCA->new;

$data 

$pca->load_data ( { format => 'table', data => $data, } );

@list = $pca->results('cumulative');
print qq{\nOrdered list of cumulative variance of the PCs: @list};
