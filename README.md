## Tools to remotely access NeuroMorpho.Org database

This repository contains Perl code for tools to retrieve and process neuronal data at Neuromorpho.Org. The access is by their application programming interface. The code of this repository is reported in a manuscript that is currently under review at a journal.

All testing was in Strawberry Perl at a Perl version of 5.8.1 or higher. Perl is a programming language that is available for commonly used operating systems. Strawberry Perl includes the LWP and JSON modules, but they may not be present in a different Perl distribution, so in this case please follow the instructions for your distribution on installing additional Perl modules. Typically, the CPAN package manager is available and supports installation of these modules.

In this repository is also a file named "list_of_species_names" which contains the list of species that is available at Neuromorpho.Org (as of Aug. 7, 2020). If the data for these species is not available at Neuromorpho.Org, then the interface to the web database may be temporarily unavailable. In this case, please test the status of the web server that hosts the database by the following web link:
http://neuromorpho.org/api/health

Even though the test above shows that the web server is working, the web database may not be fully available. The following web link is a test to verify that all species names are available in the database:
http://neuromorpho.org/api/neuron/partition/species

If the above list is empty or contains just a few species in the list, then the web database is temporarily unavailable. Try again at a later time. It should include many or all of the species names in the file "list_of_species_names".

## Terms of Usage at Neuromorpho.org

There are terms of use for access and use of the web database at NeuroMorpho.Org. Currently, the terms are here: http://neuromorpho.org/useterm.jsp. They cover the use of citations for assignment of credit to the developers of the web database and for the original source of the neuronal reconstruction data. There are also at least two major requirements on programmatic access of the web database which are relevant to this tool set. One of these is about use of the application programming interface for remote access of the metadata files. Another requirement is about use of a valid identifier where remotely accessing the web database by their API. This identifier is known as an “user agent”.

The tool set reported here is consistent with both these requirements, however, any user of this tool set must abide by the requirements in the case that additional components are added to this informatics pipeline. It is also important to prudently access the NeuroMorpho.Org web database for avoiding any excess burden on their web server, particularly for a study on a mammal with potentially thousands of neuronal data records. 
