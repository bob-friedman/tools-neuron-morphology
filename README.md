## Tools to remotely access NeuroMorpho.Org database
![](https://zenodo.org/badge/doi/10.5281/zenodo.3976710.svg)

This repository contains Perl code for tools to retrieve and organize neuronal data at Neuromorpho.Org. The access is by their application programming interface. The code of this repository is reported in a manuscript that is currently under review at a journal.

All testing was in Strawberry Perl at a version of Perl that is 5.8.1 or higher. Perl is a programming language that is available for commonly used operating systems. Strawberry Perl includes the LWP and JSON modules, but they may not be present in a different Perl distribution, so in this case please follow the instructions for your distribution on installing additional Perl modules. Typically, the CPAN package manager is available and supports installation of these modules.

In this repository is also a file named "list_of_species_names" which contains the list of species that is available at Neuromorpho.Org (as of Aug. 7, 2020). If the data for these species is not available at Neuromorpho.Org, then the interface to the web database may be temporarily unavailable. In this case, please test the status of the web server that hosts the database by the following web link:
http://neuromorpho.org/api/health

Even though the test above shows that the web server is working, the web database may not be fully available. The following web link is a test to verify that all species names are available in the database:
http://neuromorpho.org/api/neuron/partition/species

If the above list is empty or contains just a few species in the list, then the web database is temporarily unavailable. Try again at a later time. It should include many or all of the species names in the file "list_of_species_names".

## Terms of Usage at Neuromorpho.org

There are terms of use for access and use of the web database at NeuroMorpho.Org. Currently, the terms are here: http://neuromorpho.org/useterm.jsp. They cover the use of citations for assignment of credit to the developers of the web database and for the original source of the neuronal reconstruction data. There are also at least two major requirements on programmatic access of the web database which are relevant to this tool set. One of these is about use of the application programming interface for remote access of the metadata files. Another requirement is about use of a valid identifier where remotely accessing the web database by their API. This identifier is known as an “user agent”.

The tool set reported here is consistent with both these requirements, however, any user of this tool set must abide by the requirements in the case that additional components are added to this informatics pipeline. It is also important to prudently access the NeuroMorpho.Org web database for avoiding any excess burden on their web server, particularly for a study on a mammal with potentially thousands of neuronal data records. 

## Script Descriptions

### `join_metadata_morphology_tables.pl`

*   **Purpose:** Joins the metadata and morphology data tables based on the neuron name.
*   **Input Arguments:**
    *   `metadata_file`: Path to the metadata CSV file.
    *   `morphology_file`: Path to the morphology CSV file.
*   **Output Format:** Outputs the joined table to standard output as tab-separated values. This can be redirected to a file.
*   **Dependencies:** Input files should be tab-separated. The first column is used as the join key.
*   **Example Usage:** `perl join_metadata_morphology_tables.pl metadata_table.tsv morphology_table.tsv > joined_table.tsv`

### `parse_raw_metadata_to_table.pl`

*   **Purpose:** Parses raw metadata files (in JSON format) and converts them into a tab-separated table.
*   **Input Arguments:**
    *   `input_file`: Path to the raw JSON metadata file.
    *   `output_file`: Path for the output tab-separated table.
*   **Output Format:** A tab-separated table written to the specified `output_file`.
*   **Dependencies:** Input is a JSON file containing neuron metadata (e.g., as retrieved from NeuroMorpho.Org API). Requires the `JSON` Perl module.
*   **Example Usage:** `perl parse_raw_metadata_to_table.pl raw_metadata.json parsed_metadata.tsv`

### `pca_analysis_combined_table.pl`

*   **Purpose:** Performs Principal Component Analysis (PCA) on the combined metadata and morphology data. Note: This script is a template and requires modification by the user to load data into the `$data` variable within the script.
*   **Input Arguments:** None directly via command line. Data must be loaded by modifying the script's `$data` variable.
*   **Output Format:** Outputs cumulative variance of Principal Components to standard output.
*   **Dependencies:** Requires the `Statistics::PCA` Perl module. The user must modify the script to load data in the format expected by `Statistics::PCA`.
*   **Example Usage:** `perl pca_analysis_combined_table.pl` (and mention that the script needs to be edited first).

### `retrieve_morphology_by_neuron.pl`

*   **Purpose:** Retrieves morphometry data (not full SWC files) for neuron IDs extracted from a NeuroMorpho.Org metadata JSON file.
*   **Input Arguments:**
    *   `neuron_metadata_file`: Path to a JSON file containing neuron metadata (e.g., from `retrieve_neuron_metadata_by_species.pl` or directly from the API).
    *   `output_file`: Path for the output tab-separated table of morphometry data.
*   **Output Format:** A tab-separated table written to the specified `output_file`. The table includes a header row and a 'row' column, followed by morphometry data for each neuron.
*   **Dependencies:** Requires the `LWP::Simple` and `JSON` Perl modules. Input is a JSON file containing neuron metadata from NeuroMorpho.Org.
*   **Example Usage:** `perl retrieve_morphology_by_neuron.pl species_metadata.json morphology_data.tsv`

### `retrieve_neuron_counts_by_species.pl`

*   **Purpose:** Retrieves the count of neurons for each species available in NeuroMorpho.Org.
*   **Input Arguments:** None.
*   **Output Format:** Outputs a list of species and their corresponding neuron counts to standard output in a tab-separated format. The output includes a header derived from the 'fields' key in the API response.
*   **Dependencies:** Requires the `LWP::Simple` and `JSON` Perl modules. Internet access to NeuroMorpho.Org API.
*   **Example Usage:** `perl retrieve_neuron_counts_by_species.pl`

### `retrieve_neuron_metadata_by_species.pl`

*   **Purpose:** Retrieves metadata for all neurons of a specified species.
*   **Input Arguments:** Prompts the user to enter the species name via standard input.
*   **Output Format:** A single JSON file containing all pages of metadata for the specified species. The filename is constructed as `neuron_data_<species_name_underscored>_<epoch_timestamp>.json`.
*   **Dependencies:** Requires the `LWP::Simple` Perl module. Internet access to NeuroMorpho.Org API. The species name entered must be valid in NeuroMorpho.Org.
*   **Example Usage:**
    ```
    perl retrieve_neuron_metadata_by_species.pl
    # Then, when prompted:
    # Enter below the species name to retrieve its neuronal data:
    # <Enter species name here, e.g., "Mus musculus">
    ```

### `verify_metadata_species_id.pl`

*   **Purpose:** Reads tab-separated data (typically from `parse_raw_metadata_to_table.pl`) from standard input. It prints selected columns (neuron_id, species), then a unique list of species found, and finally a list of any neuron_id values that appear more than once.
*   **Input Arguments:** Accepts tab-separated data from standard input.
*   **Output Format:** Outputs the following to standard output: 1. A table of neuron_id and species. 2. A semicolon-separated list of unique species names found. 3. A semicolon-separated list of duplicate neuron_id values.
*   **Dependencies:** Expects tab-separated input with 'neuron_id' and 'species' columns. Requires the `List::MoreUtils` Perl module.
*   **Example Usage:** `perl parse_raw_metadata_to_table.pl raw_metadata.json parsed_metadata.tsv | perl verify_metadata_species_id.pl`
