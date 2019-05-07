# Making Nature's Values Visible

The Economics of Ecosystems and Biodiversity (TEEB) initiative seeks to make “nature’s values visible”.  The TEEB website (www.teebweb.org) hosts a dataset that contains over 1000 valuation estimates.  We have built on the dataset by standardizing the valuation estimates in 2018 USD so that estimates are comparable across the globe. 

<!-- While this dataset is a useful resource, it does not appeal to non-experts that are accustomed to infographics that use data to tell a story.  The objective of this project is to use the TEEB dataset to construct visually appealing graphics that tell a story about the data. -->



## Data and Methods

The primary data source is the TEEB database of valuation studies.  The valuation estimates are converted to 2018 USD and augmented with GDP and population data from the World Bank.  All data sources are described below.  Data processing was mostly conducted in the R programming language.


### TEEB Database

The database is composed of a global sample of valuation studies from a variety of sources including peer-reviewed academic and grey literatures. The database includes 1,168 valuation estimates from 87 countries and 14 biomes (McVittie and Hussain, 2013).  More information is available in the users manual accessible at: http://www.teebweb.org/publication/tthe-economics-of-ecosystems-and-biodiversity-valuation-database-manual/    

 

### Converting Valuation Estimates to 2018 US Dollars

Valuation estimates in foreign currencies are converted to US dollars.  When available, exchange rate data are collected from https://www.xe.com/currencytables/.  Exchange rate data are reported back to 1995 for some but not all currencies in the TEEB dataset (98% of 1310 observations).  For the 27 records that are not matched, we collect exchange rate data from alternative sources.  We use the exchange rate from the business day nearest to June 15 in the year the valuation estimate was published.  In cases where we have data for the following year, we use the exchange rate in year+1.  The 1992 exchange rate for the Euro is from https://www.poundsterlinglive.com/bank-of-england-spot/historical-spot-exchange-rates/usd.  The 1991 exchange rate for the Nigerian Naira is from https://www.gpo.gov/fdsys/pkg/GOVPUB-T63_100-03122c2d85476df04b6b1b7d442bd942/pdf/GOVPUB-T63_100-03122c2d85476df04b6b1b7d442bd942.pdf.  

In several cases the country name in the exchange rate data does not match the country names listed in the TEEB dataset.  We merge the TEEB data with the exchange rates using the *fuzzyjoin* package (Robinson, 2018).  The matched country names are then verified by human review. 


We use the US CPI to convert reported values to 2018 dollars (https://fred.stlouisfed.org/series/CPALTT01USA661S).  We assume the dollars in the year of publication unless otherwise noted.  Some data is reported as standardized to 2007 data, which we convert to 2018.


### Data Augmentation

We augment the TEEB valuation estimates with GDP and population data from the World Bank accessed via the R package *wbstats* (Piburn, 2018).  GDP and population data are gathered for the year corresponding to the publication date of the valuation study.  

### Tableau

The augmented dataset of valuation estimates is transfered to the Tableau software where all visualizations are created.


# References 

McVittie A., Hussain S. S. (2013) The Economics of Ecosystems and Biodiversity – Valuation Database Manual.

Piburn, Jesse (2018). wbstats: Programmatic Access to the World Bank API. Oak Ridge National Laboratory. Oak Ridge,   Tennessee. URL https://www.ornl.gov/division/csed/gist

Robinson, David (2018). fuzzyjoin: Join Tables Together on Inexact Matching. R package version 0.1.4.  https://CRAN.R-project.org/package=fuzzyjoin
