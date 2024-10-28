--2
CREATE DATABASE bdp_cw2;

--3
CREATE EXTENSION postgis;

--4
CREATE TABLE buildings (
	id SERIAL PRIMARY KEY,
	geometry geometry,
	name VARCHAR(40)
);
CREATE TABLE roads (
	id SERIAL PRIMARY KEY,
	geometry geometry,
	name VARCHAR(40)
);
CREATE TABLE poi (
	id SERIAL PRIMARY KEY,
	geometry geometry,
	name VARCHAR(40)
);

--5
INSERT INTO buildings (geometry, name)
VALUES ('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 'BuildingA'),
	('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))', 'BuildingB'),
	('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))', 'BuildingC'),
	('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))', 'BuildingD'),
	('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))', 'BuildingF');

INSERT INTO roads (geometry, name)
VALUES ('LINESTRING(0 4.5, 12 4.5)', 'RoadX'),
	('LINESTRING(7.5 10.5, 7.5 0)', 'RoadY');

INSERT INTO poi(name, geometry) 
VALUES ('G', 'POINT(1 3.5)'),
	('H', 'POINT(5.5 1.5)'),
	('I', 'POINT(9.5 6)'),
	('J', 'POINT(6.5 6)'),
	('K', 'POINT(6 9.5)');

--6
--a
SELECT SUM(ST_LENGTH(geometry))
FROM roads;

--b
SELECT ST_ASTEXT(geometry) as wkt, 
	ST_AREA(geometry) as area, 
	ST_PERIMETER(geometry)as perimeter
FROM buildings
WHERE name = 'BuildingA';

--c
SELECT name, 
	ST_AREA(geometry) as area
FROM buildings
ORDER BY name ASC;

--d
SELECT name, 
	ST_PERIMETER(geometry) as perimeter
FROM buildings
ORDER BY ST_AREA(geometry) DESC
LIMIT 2;

--e
SELECT ST_DISTANCE(buildings.geometry, poi.geometry) 
FROM buildings, poi
WHERE buildings.name = 'BuildingC' AND poi.name = 'K';

--f
SELECT ST_Area(ST_Difference(c.geometry, ST_Buffer(b.geometry, 0.5)))
FROM buildings as c,buildings as b
WHERE c.name ='BuildingC' AND b.name='BuildingB';

--g
SELECT b.name 
FROM buildings as b, roads as r
WHERE r.name = 'RoadX' AND ST_Y(ST_CENTROID(b.geometry)) > ST_Y(ST_CENTROID(r.geometry));

--h
SELECT ST_AREA(ST_SYMDIFFERENCE(geometry, 'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))
FROM buildings
WHERE name = 'BuildingC';
