# AH-Yugoslavia Project Geospatial Workflow

This README provides a description of the workflow for the geospatial data.  

I am very grateful to Phil Kirker and his expertise with geospatial software and advice on developing the border line workflow. 

Note that most of these layers can be left as temporary files, except where specified. 

## In QGIS
Import AH_emp.shp from the [MPIDR Population History GIS Collection](https://censusmosaic.demog.berkeley.edu/data/historical-gis-files) into QGIS

1. Dissolve AH_emp.shp, selecting SUBREGION as the the dissolve field 
    * This file will longer have outlines of each province, only the entire empire

2. Run Polygons to Lines usin the Dissolved layer
    * This creates a line of the outlining the empire
 
3. With the line layer selected, toggle editing and click "Add Line Feature" (Ctrl +) 
    1. Trace, with relative accuracy using point and click, the southeastern border of the line layer from the Mediterranean to the most eastern part of the line
        * To avoid measurement error, especially at the coastline of the southern most parts of Croatia, trace as close as possible
    2. Once finished, right click and save 
        * Open the attribute table for this layer and select the attribute for **ONLY** the line you traced
    3. Right click and export, save feature as "traced_line"
4. Use Buffer over "traced_line"
    * Distance is by discretion, I used 50m, smaller distance improves accuracy only if the traced line from Step 3. is traced accurately
    * Ensure that entire border line is contained within the buffer
5. Clip the original border line by the buffer
    * You should end up with the border of the original AH shapefile along the SE border only
    * Save this feature for use in the figure
6. Using SAGA tool Lines to Points, convert the new border line to points
    * Make sure to select add extra points!
7. Calculate distance (finally) by selecting distance to nearest hub (points)
    * Use the .csv into points of the UCDP data as source and border points as the hub
    * Set units to km
    * Output will have a variable name called Hub_dist, rename this and add the column it to the main dataframe
8. Repeat this process from 1. with the shapefile of AH not including Bosnia and Herzegovina
    * You can create this by re-importing AH_emp.shp and manually deleting attributes with NAME == "BOSNIA/HERCEGOVINA" or "PODRINJE" or "VALJEVO" or "UZICE"


## In ArcGIS 

Import the shapefile of the 1991 Yugoslav municipalities YUG_91.shp from [Milos Popovic](https://github.com/milos-agathon/yugoslavia-municipality-shapefiles) and the elevation map of Europe from the [European Environmental Agency](https://www.eea.europa.eu/data-and-maps/data/digital-elevation-model-of-europe) 
1. Open data engineering on YUG_91.shp right click the fields pane and go to Construct> Calculate field
   * Rewrite `munic = name.replace(' ', '')` 
   * Rewrite over the field name `munic = munic.replace('-','')` 
   * Save these edits
2.  Run a quick Calculate Geometry Attributes on YUG_91.shp to get sqkm of each municipality
3.  Import YUG_91 as a table and name it trivals
4.  Run Model.py and export results
   * Make sure to change to appropriate working directories in this file
5. Export results as YUG91final.csv into the raw folder
