/* This script is used to generate insights that can be visualized.

   Step 1 is to create 'big_table' which is 
*/
-- Take information from massdot_bluetoad_data & pair_definitions
CREATE TABLE big_table
(pair_id mediumint(8) unsigned NOT NULL,
 Description varchar(2000),
 Direction varchar(2000),
 Origin varchar(2000),
 Destination varchar(2000),
 Distance float,
 `insert_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
 ON UPDATE CURRENT_TIMESTAMP,
 `travel_time` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`pair_id`,`insert_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- SELECT INTO big_table from massdot_bluetoad_data
INSERT INTO big_table (pair_id, insert_time, travel_time)
SELECT pair_id, insert_time, travel_time
FROM massdot_bluetoad_data;

-- Find duplicate foreign keys between big_table and pair_definitions
SELECT big_table.*, COUNT(big_table.pair_id) AS "Duplicates"
FROM big_table,pair_definitions
WHERE big_table.pair_id = pair_definitions.pair_id
GROUP BY big_table.pair_id
HAVING COUNT(big_table.pair_id) > 1;

-- Remove duplicates
DELETE FROM big_table WHERE pair_id IN
(SELECT COUNT(pair_definitions.pair_id) 
 FROM big_table,pair_definitions
 WHERE big_table.pair_id = pair_definitions.pair_id
 GROUP BY pair_definitions.pair_id
 HAVING COUNT(pair_definitions.pair_id) > 1);

-- Update big_table to include information in pair_definitions
UPDATE big_table
INNER JOIN pair_definitions
ON big_table.pair_id = pair_definitions.pair_id
SET big_table.Description = pair_definitions.Description,
    big_table.Direction = pair_definitions.Direction,
    big_table.Origin = pair_definitions.Origin,
    big_table.Destination = pair_definitions.Destination,
    big_table.Distance = pair_definitions.Distance;

