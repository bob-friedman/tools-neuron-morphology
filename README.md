# tools-neuron-morphology

This repository contains Perl code for tools to retrieve and process neuronal data at Neuromorpho.Org.

The code is reported in a manuscript that is currently in review at a journal.

The code was tested in Strawberry Perl and is expected to run in Perl version 5.8.1 or higher, a language available for nearly any commonly used operating system.

Strawberry Perl includes the LWP or JSON modules, but if they are missing in your Perl distribution, then please follow the instructions of your distribution for installing additional modules. Typically, the CPAN package manager supports installation of the missing Perl modules.

The file named list_of_species_names contains the list of species that are available at Neuromorpho.Org (Aug. 7, 2020). If the data for these species is not available at Neuromorpho.Org, then the interface to the web database may be temporarily unavailable. In this case, please test the status of the web server that hosts the database by the following web link:
http://neuromorpho.org/api/health

Even though the test above shows that the web server is working, the database may not be fully available. The following web link is a test to verify that all species names are available in the database:
http://neuromorpho.org/api/neuron/partition/species

If the above list is empty or contains just a few species in the list, then the web database is temporarily unavailable. Try again at a later time. It should include many or all of the species names in the file named list_of_species_names that is at this repository.
