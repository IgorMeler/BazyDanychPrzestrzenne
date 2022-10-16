CREATE EXTENSION postgis;
CREATE SCHEMA miasto;
CREATE TABLE miasto.drogi(id INTEGER, name VARCHAR (50), geom GEOMETRY);
INSERT INTO miasto.drogi VALUES (1, 'roadx', ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)', 0));
INSERT INTO miasto.drogi VALUES (2, 'roady', ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)', 0))

CREATE TABLE miasto.budynki(id INTEGER, name VARCHAR (50), geom GEOMETRY);
INSERT INTO miasto.budynki VALUES (1, 'BuildingA', ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 0));
INSERT INTO miasto.budynki VALUES (2, 'BuildingB', ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))', 0));
INSERT INTO miasto.budynki VALUES (3, 'BuildingC', ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))', 0));
INSERT INTO miasto.budynki VALUES (4, 'BuildingD', ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8 , 9 9))', 0));
INSERT INTO miasto.budynki VALUES (5, 'BuildingE', ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))', 0));

CREATE TABLE miasto.pktinfo(id INTEGER, geom GEOMETRY, name VARCHAR(50), liczprac INTEGER);
INSERT INTO miasto.pktinfo VALUES(1,  ST_GeomFromText('POINT(1 3.5)'), 'G', 5);
INSERT INTO miasto.pktinfo VALUES(2,  ST_GeomFromText('POINT(5.5 1.5)'), 'H', 5);
INSERT INTO miasto.pktinfo VALUES(3,  ST_GeomFromText('POINT(9.5 6)'), 'I', 5);
INSERT INTO miasto.pktinfo VALUES(4,  ST_GeomFromText('POINT(6.5 6)'), 'J', 5);
INSERT INTO miasto.pktinfo VALUES(5,  ST_GeomFromText('POINT(6 9.5)'), 'K', 5);

-- 1

SELECT SUM(ST_Length(geom)) FROM miasto.drogi;

-- 2

SELECT ST_AsText(geom) AS WKT, ST_Area(geom) AS area, ST_Perimeter(geom) AS per FROM miasto.budynki
WHERE name = 'BuildingB'

-- 3

SELECT name, ST_Area(geom) AS area FROM miasto.budynki 
ORDER BY name 

-- 4

SELECT name, ST_Perimeter(geom) AS perim FROM miasto.budynki 
ORDER BY ST_Area(geom) DESC LIMIT 2 

-- 5 

SELECT ST_Distance(miasto.budynki.geom, miasto.pktinfo.geom) FROM (miasto.budynki
CROSS JOIN miasto.pktinfo) WHERE miasto.budynki.name = 'BuildingC' AND miasto.pktinfo.name = 'G'

-- 6 

SELECT ST_Area(ST_Difference((SELECT miasto.budynki.geom FROM miasto.budynki WHERE name = 'BuildingC'), 
                        ST_Buffer((SELECT miasto.budynki.geom FROM miasto.budynki WHERE name = 'BuildingB'), 0.5)));



-- 7

SELECT budynki.name FROM (miasto.budynki
CROSS JOIN miasto.drogi) WHERE ST_Y(ST_Centroid(miasto.budynki.geom)) > (ST_Y(ST_Centroid(miasto.drogi.geom))) AND drogi.name = 'roadx';
            
-- 8

SELECT ST_Area(ST_SymDifference((SELECT miasto.budynki.geom FROM miasto.budynki WHERE name = 'BuildingC'), 
                        (SELECT miasto.budynki.geom FROM miasto.budynki WHERE name = 'BuildingB')))