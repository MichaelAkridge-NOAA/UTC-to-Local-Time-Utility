# UTC to Local Time Converter - Utility Package
# Notes

### SDO (Spatial Data Option) functions 
SDO (Spatial Data Option) functions to perform operations on spatial data. Details of the Query:
- 2001 indicates the type of geometry (in this case, a 2D point).
- 8307 is the SRID (Spatial Reference System Identifier), which specifies the spatial reference system for the geometry. 8307 typically refers to WGS 84, a common coordinate system used for GPS data.
- SDO_POINT_TYPE(a.LON_DD, a.LAT_DD, NULL) creates the point using the longitude and latitude values.
- SDO_RELATE: This function determines the spatial relationship between two SDO_GEOMETRY objects. 
    - In this query, it checks if the point created from table a's longitude and latitude (SDO_GEOMETRY) has any interaction ('mask=ANYINTERACT') with the shapes (SHAPE) defined in table b(timezone table). If the function returns 'TRUE', it means the point is within (or intersects with) one of the geographic areas defined in b.
- SHAPE: This is a column in table b (tz_all) that contains SDO_GEOMETRY data representing different time zones as spatial areas.
### Oracle Timezone File
- IMPORTANT: Make sure Oracle has an up to date timezone file when possible: 
    - Check version
```
SELECT VERSION FROM V$TIMEZONE_FILE;
```
- The latest version (https://oracle-base.com/articles/misc/update-database-time-zone-file)
    - depends on the current date and any recent changes to global time zone rules.
- Impact of Using an Older Version: 
    - Using an older version of the oracle time zone data files means that the  database might not correctly handle the local time for regions that have changed their DST rules or time zone offsets since the last release. 
    - This could affect applications that rely on accurate local time calculations.
### Note about The POSIX TZ standard used by Global timezone dataset
- The timezone data uses  POSIX TZ standard settings 
- Ocean zones are in the output from Etc/GMT+12 to Etc/GMT-12
- A common misconception is that Etc/GMT* zones should increase from west to east,
- However, this is not the case as explained in the timezone database in the timezone database files. Their notes:
    -  POSIX TZ settings in the Zone names, are the opposite of what many people expect.
    -  POSIX has positive signs west of Greenwich, but many people expect positive signs east of Greenwich.  
    -  For example, TZ='Etc/GMT+4' uses the abbreviation "-04" and corresponds to 4 hours behind UT
    -  (i.e. west of Greenwich) even though many people would expect it to mean 4 hours ahead of UT (i.e. east of Greenwich).
## Sources
- Public Timezones & location data: 
    - OpenStreetMap database 
    - Timezone Database (https://www.iana.org/time-zones)
    - CIA World Factbook for global timezones
- Public Shapefile with the locations/time zone boundaries:
    - see the following for more info: https://github.com/evansiroky/timezone-boundary-builder/releases/tag/2024a
        - file: timezones-with-oceans-now.shapefile.zip (combined-shapefile-with-oceans-now)