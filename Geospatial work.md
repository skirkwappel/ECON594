# AH-Yugoslavia Project Geospatial Workflow

This README provides a description of the workflow for the geospatial data.  

I am very grateful to Phil Kirker and his expertise with geospatial software and advice on developing the border line workflow. 

Note that most of these layers can be left as temporary files, except where specified. 

## In QGIS

1. Dissolve .shp at (this) level
    * This file will longer have outlines of each province, only the entire empire

2. Polygons to Lines 
    * This creates a line of the outline of the empire
 
3. With the line layer selected, toggle editing and click "Add Line Feature" (Ctrl +) 
    1. Trace, with relative accuracy, the southeastern border of the line layer 
        * To avoid measurement error, especially at the coastline of the southern most parts of Croatia, trace as close as possible
    2. Once finished, right click and save 
        * Open the attribute table for this layer and select the attribute for **ONLY** the line you traced
    3. Right click and export, save feature as
4. Buffer over the traced line
    * Distance is by discretion, smaller distance improves accuracy only if the traced line from Step 3. is traced accurately
    * Ensure that entire border line is contained within the buffer
5. Clip the original border line by the buffer
    * You should end up with the border of the original AH shapefile along the SE border only
    * Save this for use in the figure
6. Using SAGA tool lines to points, convert the new border line to points
    * Make sure to select add extra points!
7. Calculate distance (finally) by selecting distance to nearest hub (points)
    * Use UCDP data as source and border points as the hub
    * Set units to km
    * Output will have a variable name called Hub_dist, rename this and add it to the main data
8. Repeat this process with the shapefile of AH not including Bosnia and Herzegovina 


## In ArcGIS 