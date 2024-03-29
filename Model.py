# -*- coding: utf-8 -*-
"""
Generated by ArcGIS ModelBuilder on : 2023-02-10 14:58:16
"""
import arcpy
def #  NOT  IMPLEMENTED# Function Body not implemented

def Model1():  # Model 1

    # To allow overwriting outputs change overwriteOutput option to True.
    arcpy.env.overwriteOutput = False

    # Check out any necessary licenses.
    arcpy.CheckOutExtension("spatial")
    arcpy.CheckOutExtension("ImageExt")
    arcpy.CheckOutExtension("ImageAnalyst")

    YUG91_2_ = "YUG91"
    TRI_layer_tif = arcpy.Raster("TRI layer.tif")
    YUG91_Municipalities = "YUG91"
    TRI_table = "trivals"

    for I_YUG91_munic, munic in #  NOT  IMPLEMENTED(YUG91_Municipalities, [["munic", ""]], False):

        # Process: Extract by Mask (Extract by Mask) (sa)
        munic = "1"
        Extract_munic_ = fr"C:\Users\skirk\Documents\ArcGIS\Projects\594\594.gdb\Extract{munic}"
        Extract_by_Mask = Extract_munic_
        Extract_munic_ = arcpy.sa.ExtractByMask(in_raster=TRI_layer_tif, in_mask_data=I_YUG91_munic)
        Extract_munic_.save(Extract_by_Mask)


        # Process: Zonal Statistics as Table (Zonal Statistics as Table) (ia)
        trimean_munic_ = fr"C:\Users\skirk\Documents\ArcGIS\Projects\594\594.gdb\trimean_{munic}"
        arcpy.ia.ZonalStatisticsAsTable(in_zone_data=YUG91_2_, zone_field="munic", in_value_raster=Extract_munic_, out_table=trimean_munic_, ignore_nodata="DATA", statistics_type="MEAN", process_as_multidimensional="CURRENT_SLICE", percentile_values=90, percentile_interpolation_type="AUTO_DETECT")
        .save(Zonal_Statistics_as_Table)


        # Process: Append (Append) (management)
        TRI_table_2_ = arcpy.management.Append(inputs=[trimean_munic_], target=TRI_table, schema_type=munic, field_mapping="munic \"name\" true true false 255 Text 0 0,First,#,C:\\Users\\skirk\\Documents\\ArcGIS\\Projects\\594\\594.gdb\\trimean_Ada,munic,0,254;ZONE_CODE \"ZONE_CODE\" true true false 4 Long 0 0,First,#,C:\\Users\\skirk\\Documents\\ArcGIS\\Projects\\594\\594.gdb\\trimean_Ada,ZONE_CODE,-1,-1;AREA \"AREA\" true true false 8 Double 0 0,First,#,C:\\Users\\skirk\\Documents\\ArcGIS\\Projects\\594\\594.gdb\\trimean_Ada,AREA,-1,-1;MEAN \"MEAN\" true true false 8 Double 0 0,First,#,C:\\Users\\skirk\\Documents\\ArcGIS\\Projects\\594\\594.gdb\\trimean_Ada,MEAN,-1,-1", subtype="", expression="")[0]

if __name__ == '__main__':
    # Global Environment settings
    with arcpy.EnvManager(scratchWorkspace=r"C:\Users\skirk\Documents\ArcGIS\Projects\594\594.gdb", workspace=r"C:\Users\skirk\Documents\ArcGIS\Projects\594\594.gdb"):
        Model1()
