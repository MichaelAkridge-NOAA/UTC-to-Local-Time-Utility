# INSTALL - UTC to Local Time Converter - Utility Package
## Requirements
- System Requirements
    - Oracle w/ oracle spatial
## Download Files
View latest release: https://github.com/MichaelAkridge-NOAA/UTC-to-Local-Time-Utility/releases/
## Setup
1. Import timezone tables into schema
2. Import utc to local timezone function(s)


## Example Installs
### Example | Install Timezone Data Table(s) via Data pump util: 
- can be used via sql dev wizard or via command line
- file "./EXPDAT01-18_54_12.DMP"

```
impdp username/password DIRECTORY=directory DUMPFILE=EXPDAT01-00_51_06.DMP TABLE_EXISTS_ACTION=REPLACE
```
### Example | Install Timezone Data Table(s) via shapefile & ArcGIS Pro
- Importing a Shapefile into ArcGIS Pro (drag and drop or see below)
    - unzip shape file found in ("./UTL_TIMEZONE_LOCATIONS_GLOBAL_SHP.zip")
    - Start ArcGIS Pro and open your project.
    - Add Data to Your Project:
    - Navigate to the “Map” tab on the top menu.
    - Click on the “Add Data” dropdown.
    - Choose “Data” from the dropdown options.
    - Browse to the location of your shapefile (.shp) on your computer or network.
    - Select the shapefile you want to import and click “OK.”
    - The shapefile will now appear in your project’s Contents pane and on the map.
            <img align="right" src="./docs/screenshots/s02.png" alt="Map of Timezones" >
- Setup Database Connection
    - Go to the Catalog Pane:
    - Right-click on the “Databases” item and select “New Database Connection” from the context menu.
    -  Enter Connection Details like so
- Exporting Features to a Database
    - After you’ve imported your shapefile into ArcGIS Pro, you can export its features to a geodatabase by following these steps:
    - Right-click the layer (the imported shapefile) in the Contents pane that you want to export to a database.
    - Choose “Data” and then “Export Features.”
    - In the Export Features pane:
    - For “Output Feature Class,” click the folder icon to specify the output location. Here, you will choose your database. If you're exporting to an enterprise geodatabase, make sure you have the appropriate connection set up.
    - You may give a new name to the output feature class or use the default one provided.
    - Adjust any other export options as needed.
    - Click “Run” to execute the export. The features from your shapefile will now be exported to the specified location in your database.

### Example | Import utc to local timezone function -  Just Run the Sql file via sql dev or cmd
### UTC to Local w/ Offset
```
CREATE OR REPLACE FUNCTION f_convert_utc_to_local_offset(
    p_utc_timestamp IN TIMESTAMP,
    p_utc_offset_str IN VARCHAR2 -- The offset in the format 'UTC+HH:MI' or 'UTC-HH:MI'
) RETURN TIMESTAMP DETERMINISTIC IS
    v_local_timestamp TIMESTAMP;
    v_utc_offset VARCHAR2(6); -- To store '+HH:MI' or '-HH:MI' format
BEGIN
    -- Extract the offset part from the input string, the format 'UTC+HH:MI' or 'UTC-HH:MI'
    -- The extraction skips the first 3 characters ('UTC') and captures the rest
    v_utc_offset := SUBSTR(p_utc_offset_str, 4);
    -- Convert the UTC timestamp to a TIMESTAMP WITH TIME ZONE using the extracted offset
    v_local_timestamp := FROM_TZ(p_utc_timestamp, 'UTC') AT TIME ZONE v_utc_offset;

    RETURN v_local_timestamp;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END f_convert_utc_to_local_offset;
/

```
### UTC to Local w/ Timezone Global Dataset
```
CREATE OR REPLACE FUNCTION f_convert_utc_to_local_global(
    p_utc_timestamp IN TIMESTAMP,
    p_tz_id IN VARCHAR2
) RETURN TIMESTAMP DETERMINISTIC IS
    v_local_timestamp TIMESTAMP;
BEGIN
    EXECUTE IMMEDIATE 
        'SELECT FROM_TZ(CAST(:1 AS TIMESTAMP), ''UTC'') AT TIME ZONE ''' || 
        REPLACE(p_tz_id, '''', '''''') || ''' FROM dual'
    INTO v_local_timestamp
    USING p_utc_timestamp;

    RETURN v_local_timestamp;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END f_convert_utc_to_local_global;
/    
```
