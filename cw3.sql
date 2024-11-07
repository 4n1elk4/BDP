CREATE EXTENSION POSTGIS;

-- shp2pgsql "C:\[...]\Karlsruhe_Germany_Shapefile\T2018_KAR_GERMANY\T2018_KAR_BUILDINGS.shp" b_2018 | psql -U postgres -h localhost -p 5432 -d bdp_cw3
-- shp2pgsql "C:\[...]\Karlsruhe_Germany_Shapefile\T2019_KAR_GERMANY\T2019_KAR_BUILDINGS.shp" b_2019 | psql -U postgres -h localhost -p 5432 -d bdp_cw3
--1
CREATE TEMP TABLE changed_buildings as 
SELECT b9.gid, 
	b9.polygon_id, 
	b9.name,
	b9.geom
FROM b_2018 as b8
FULL JOIN b_2019 as b9
ON b8.polygon_id = b9.polygon_id
WHERE NOT(ST_Equals(b8.geom, b9.geom))
OR b8.height != b9.height
OR b8.polygon_id is NULL;

-- shp2pgsql "C:\[...]\Karlsruhe_Germany_Shapefile\T2018_KAR_GERMANY\T2018_KAR_POI_TABLE.shp" poi_2018 | psql -U postgres -h localhost -p 5432 -d bdp_cw3
-- shp2pgsql "C:\[...]\Karlsruhe_Germany_Shapefile\T2019_KAR_GERMANY\T2019_KAR_POI_TABLE.shp" poi_2019 | psql -U postgres -h localhost -p 5432 -d bdp_cw3
--2
WITH new_poi as (
	SELECT p9.poi_id,
		ST_SetSRID(p9.geom, 3068) as geom, 
		p9.type
	FROM poi_2018 as p8
	RIGHT JOIN poi_2019 as p9
	ON p9.poi_id = p8.poi_id
	WHERE p8.poi_id is NULL
)
SELECT DISTINCT COUNT(*) as counts,
	np.type
FROM changed_buildings as cb
JOIN new_poi as np
ON ST_Intersects(np.geom, ST_Buffer(ST_SetSRID(cb.geom, 3068), 500))
GROUP BY np.type
ORDER BY counts desc;

-- shp2pgsql "C:\[...]\Karlsruhe_Germany_Shapefile\T2019_KAR_GERMANY\T2019_KAR_STREETS.shp" streets_2019 | psql -U postgres -h localhost -p 5432 -d bdp_cw3
--3
CREATE TABLE streets_reprojected as
SELECT gid,
	link_id,
	st_name,
	ref_in_id,
	nref_in_id,
	func_class,
	speed_cat,
	fr_speed_l,
	to_speed_l,
	dir_travel,
	ST_SetSRID(geom, 3068) as geom
FROM streets_2019

--4
CREATE TABLE input_points (
	id SERIAL PRIMARY KEY,
	geom geometry
);
INSERT INTO input_points (geom)
VALUES ('POINT(8.36093 49.03174)'),
	('POINT(8.39876 49.00644)');

--5
UPDATE input_points
SET geom = ST_SetSRID(geom,3068);

-- shp2pgsql "C:\[...]\Karlsruhe_Germany_Shapefile\T2019_KAR_GERMANY\T2019_KAR_STREET_NODE.shp" street_node_2019 | psql -U postgres -h localhost -p 5432 -d bdp_cw3
--6
UPDATE street_node_2019
SET geom = ST_SetSRID(geom,3068);

WITH line as (
	SELECT ST_SetSRID(ST_MakeLine(ip.geom), 3068) as geom
	FROM input_points as ip
)
SELECT gid,
	node_id,
	link_id,
	lat,
	lon,
	sn.geom
FROM street_node_2019 as sn
CROSS JOIN line
WHERE ST_Contains(ST_Buffer(line.geom, 200),sn.geom);

-- shp2pgsql "C:\[...]\Karlsruhe_Germany_Shapefile\T2019_KAR_GERMANY\T2019_KAR_LAND_USE_A.shp" land_use_a_2019 | psql -U postgres -h localhost -p 5432 -d bdp_cw3
--7
UPDATE land_use_a_2019
SET geom = ST_SetSRID(geom,3068);

UPDATE poi_2019
SET geom = ST_SetSRID(geom,3068);

SELECT *
FROM land_use_a_2019 as lu
JOIN poi_2019 as poi
ON ST_DWithin(lu.geom, poi.geom, 300)
WHERE poi.type='Sporting Goods Store'
AND lu.type ilike '%park%';

-- shp2pgsql "C:\[...]\Karlsruhe_Germany_Shapefile\T2019_KAR_GERMANY\T2019_KAR_RAILWAYS.shp" railways_2019 | psql -U postgres -h localhost -p 5432 -d bdp_cw3
-- shp2pgsql "C:\[...]\Karlsruhe_Germany_Shapefile\T2019_KAR_GERMANY\T2019_KAR_WATER_LINES.shp" water_lines_2019 | psql -U postgres -h localhost -p 5432 -d bdp_cw3
--8
CREATE TABLE T2019_KAR_BRIDGES as 
	SELECT ST_Intersection(wl.geom, r.geom) as geom
	FROM railways_2019 as r
	JOIN water_lines_2019 as wl
	ON ST_Intersects(wl.geom, r.geom)
	
