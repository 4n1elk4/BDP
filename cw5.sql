CREATE EXTENSION postgis;

-- 1
CREATE TABLE objects (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30),
	geometry, geometry
);

INSERT INTO objects (name, geometry)
VALUES ('obiekt1', ST_Collect(
		ARRAY[ ST_GeomFromText('LINESTRING(0 1, 1 1)'),
			ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)'),
			ST_GeomFromText('CIRCULARSTRING(3 1, 4 2, 5 1)'),
			ST_GeomFromText('LINESTRING(5 1, 6 1)')] )),
	('obiekt2', ST_Collect(
		ARRAY[ ST_GeomFromText('LINESTRING(10 6, 14 6)'),
			ST_GeomFromText('CIRCULARSTRING(14 6, 16 4, 14 2)'),
			ST_GeomFromText('CIRCULARSTRING(14 2, 12 0, 10 2)'),
			ST_GeomFromText('LINESTRING(10 2, 10 6)'),
			ST_GeomFromText('CIRCULARSTRING(11 2, 13 2, 11 2)')] )),
	('obiekt3', ST_Collect(
		ARRAY[ ST_GeomFromText('LINESTRING(10 17, 12 13)'),
			ST_GeomFromText('LINESTRING(12 13, 7 15)'),
			ST_GeomFromText('LINESTRING(7 15, 10 17)')] )),
	('obiekt4', ST_Collect(
		ARRAY[ ST_GeomFromText('LINESTRING(20 20, 25 25)'),
			ST_GeomFromText('LINESTRING(25 25, 27 24)'),
			ST_GeomFromText('LINESTRING(27 24, 25 22)'),
			ST_GeomFromText('LINESTRING(25 22, 26 21)'),
			ST_GeomFromText('LINESTRING(26 21, 22 19)'),
			ST_GeomFromText('LINESTRING(22 19, 20.5 19.5)')] )),
	('obiekt5', ST_COLLECT(
		ARRAY[ ST_SetSRID(ST_MakePoint(30, 30, 59), 0),
			ST_SetSRID(ST_MakePoint(38, 32, 234), 0)] )),
	('obiekt6', ST_COLLECT(
		ARRAY[ ST_GeomFromText('LINESTRING(1 1, 3 2)'),
			ST_GeomFromText('POINT(5.5 1.5)' )]));

--2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(
                   (SELECT geometry FROM objects WHERE name = 'obiekt3'),
                   (SELECT geometry FROM objects WHERE name = 'obiekt4')) 
               ,5)) as buffer_area;

--3
UPDATE objects
SET geometry = ST_MakePolygon( ST_AddPoint(ST_LineMerge(geometry), ST_StartPoint(geometry)))
WHERE name = 'obiekt4';
-- obiekt nie był domknięty więc nie można było zrobić z niego polygonu

SELECT ST_CollectionExtract(geometry)
from objects
where name = 'obiekt4'

--4
INSERT INTO objects (name, geometry)
VALUES ('obiekt7', ST_Collect(
		(SELECT geometry FROM objects WHERE name = 'obiekt3'),
		(SELECT geometry FROM objects WHERE name = 'obiekt4')));

--5
SELECT sum(ST_Area(
			ST_Buffer(geometry, 5)))
FROM objects
WHERE not ST_HasArc(geometry);
