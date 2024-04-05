--------------------------------------------------------
--  DDL for Function F_CONVERT_UTC_TO_LOCAL_GLOBAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "F_CONVERT_UTC_TO_LOCAL_GLOBAL" (
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
