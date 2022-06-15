# site-occupancy

This repository contains MATLAB code used for the atom probe crystallographic analysis presented in the following journal article:
[1] Breen AJ, Theska F, Lim B, Primig S, Ringer SP. Advanced quantification of the site-occupancy in ordered multi-component intermetallics using atom probe tomography. Intermetallics. 2022 Jun 1;145:107538.
https://doi.org/10.1016/j.intermet.2022.107538

If you use the code for your own analysis and present the results, please reference/cite the journal article above.
 
The code contained in this repository was used to measure changes to the solute site-occupancy behaviour in the L12 ordered gamma-prime phase found in an additively manufactured Ni-based superalloy - Inconel 738 (In738). The code is currently configured to measure site-occupancy in an atom probe tomography (APT) dataset of an L12 ordered crystal structure. However, with small modifications the code could also be used to study site-occupancy behaviour in other ordered systems. Keep in mind though that the ability to measure site-occupancy using this code is highly dependent on the experimental parameters and material properties of the analysed specimen. In general, crystallographic information is more apparent in specimens which have been analysed using voltage pulsing at colder (< 50 K) temperatures. Ordering behaviour may not be observed using the developed protocol if individual lattice planes are not evaporated in a sequential layer-by-layer manner. This can sometimes happen due to the changes in the relative evaporation fields of the contained atomic species and cause a ‘collapsing plane’ artefact in the reconstruction and is a known potential artefact. If this is the case in your dataset, I would recommend reading the following article for additional ideas on how you could extract ordering information from your APT data:   
[2] Boll T, Al-Kassab T, Yuan Y, Liu ZG. Investigation of the site occupation of atoms in pure and doped TiAl/Ti3Al intermetallic. Ultramicroscopy. 2007 Sep 1;107(9):796-801.
https://doi.org/10.1016/j.ultramic.2007.02.011

All code was written to work on Matlab R2020a.

Code for reading in experimental apt data and performing high signal species specific SDMs:

readepos.m – reads a .epos  file of an atom probe dataset into Matlab
SDM_1D_SS_2021.m – generates high signal species-specific (SS) SDMs of APT data
atomProbeRecon06.m – reconstructs the atom probe data contained in the .epos file, based on the detector co-ordinates and user inputted reconstruction parameters
filter_elements.m -filters the elements of interest from the APT data
readrange_rng_05.m – reads in a .rng range file of the dataset
*other third party code is also called and contained within the repository - please refer to the licencing and acknowdegements in code for more information

Code for Facilitating measurement of solute site-occupancy behaviour in APT data of ordered intermetallics:
*To be added shortly

Some test data from one of the datasets used in the paper can be found here:

https://unisyd-my.sharepoint.com/:f:/g/personal/andrew_breen_sydney_edu_au/EsWXSPq9giZJlmwQobTfwCYBSYqzOus8BAOpAHsLwj4AiQ?e=Q8fCrE

## How to use the code
To generate species specific SDMs:
Open 'SDM_1D_SS_2021.m' in the Matlab editor and change user inputs to suit the dataset of interest.
This main script calls the other functions contained in this repository. Make sure all code called is in the search path. Make sure all datasets (.epos, .pos, .rng etc.) are in your current folder.  
Follow comments in script and called functions for detailed info/instructions
Please email andrew.breen@sydney.edu.au if there are problems or you require more information.





