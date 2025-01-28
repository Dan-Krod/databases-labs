USE Labor_SQL;
SELECT
	trip_no,
    date,
    ID_psg,
	CONCAT('ряд: ', SUBSTRING(place, 1, length(place) - 1)) as row_comment,
    CONCAT('місце: ', SUBSTRING(place, -1)) as seat_comment
FROM Pass_in_trip











-- SELECT 
--     place,
--     SUBSTRING(place, 1, CHAR_LENGTH(place) - 1) AS new_row_num,
--     SUBSTRING(place, CHAR_LENGTH(place), 1) AS new_seat
-- FROM Pass_in_trip
-- WHERE place IS NOT NULL;