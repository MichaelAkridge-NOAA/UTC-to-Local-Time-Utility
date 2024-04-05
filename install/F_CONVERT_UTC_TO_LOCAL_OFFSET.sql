--------------------------------------------------------
--  DDL for Function F_CONVERT_UTC_TO_LOCAL_OFFSET
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "F_CONVERT_UTC_TO_LOCAL_OFFSET" (
    p_utc_timestamp IN TIMESTAMP,
    p_utc_offset_str IN VARCHAR2
) RETURN TIMESTAMP DETERMINISTIC IS
    v_local_timestamp TIMESTAMP;
    v_utc_offset VARCHAR2(6); -- To store '+HH:MI' or '-HH:MI' format
BEGIN
    -- Extract the offset part from the input string, assuming the format 'UTC+HH:MI' or 'UTC-HH:MI'
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
