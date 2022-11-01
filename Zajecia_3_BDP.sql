CREATE EXTENSION postgis;

SELECT * FROM public.t2018_kar_buildings

--1

SELECT t2019_kar_buildings.* FROM public.t2019_kar_buildings LEFT JOIN public.t2018_kar_buildings 
ON t2019_kar_buildings.polygon_id = t2018_kar_buildings.polygon_id 
WHERE ST_Equals(t2019_kar_buildings.geom, t2018_kar_buildings.geom) != true
OR t2018_kar_buildings.polygon_id IS NULL;

CREATE TABLE pomocnicza AS(
SELECT t2019_kar_buildings.* FROM public.t2019_kar_buildings LEFT JOIN public.t2018_kar_buildings 
ON t2019_kar_buildings.polygon_id = t2018_kar_buildings.polygon_id 
WHERE ST_Equals(t2019_kar_buildings.geom, t2018_kar_buildings.geom) != true
OR t2018_kar_buildings.polygon_id IS NULL)

--2

SELECT ST_AsText(geom) FROM public.t2018_kar_poi_table;
SELECT * FROM public.t2019_kar_poi_table where type = 'Medical Service';



SELECT COUNT(*), t2019_kar_poi_table.type FROM public.t2019_kar_poi_table  LEFT JOIN public.t2018_kar_poi_table 
ON t2019_kar_poi_table.poi_id = t2018_kar_poi_table.poi_id 
WHERE t2018_kar_poi_table.poi_id IS NULL AND ST_Within(t2019_kar_poi_table.geom,ST_Buffer(ST_Union
(ARRAY(SELECT t2019_kar_buildings.geom FROM public.t2019_kar_buildings INNER JOIN public.t2018_kar_buildings 
ON t2019_kar_buildings.polygon_id = t2018_kar_buildings.polygon_id 
WHERE ST_Equals(t2019_kar_buildings.geom, t2018_kar_buildings.geom) != true)), 500)) GROUP BY t2019_kar_poi_table.type

SELECT COUNT(*), t2019_kar_poi_table.type FROM public.t2019_kar_poi_table  LEFT JOIN public.t2018_kar_poi_table 
ON t2019_kar_poi_table.poi_id = t2018_kar_poi_table.poi_id 
WHERE t2018_kar_poi_table.poi_id IS NULL AND ST_Within(t2019_kar_poi_table.geom,ST_Buffer(ST_Union
(ARRAY(SELECT geom FROM pomocnicza)), 500)) GROUP BY t2019_kar_poi_table.type


--3

SELECT * FROM spatial_ref_sys


CREATE TABLE streets_reprojected AS(
SELECT 
    gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l, dir_travel, ST_Transform(geom, 3068)
    FROM t2019_kar_streets)
    
    
--4

CREATE TABLE input_points (geom geometry, id integer);

INSERT INTO input_points VALUES( ST_GeomFromText('POINT(8.36093 49.03174)', 4326), 1);
INSERT INTO input_points VALUES( ST_GeomFromText('POINT(8.39876 49.00644)', 4326), 2)

SELECT * FROM input_points

--5

UPDATE input_points SET
geom = ST_Transform(geom,3068);
SELECT ST_AsText(geom) FROM input_points

--6

SELECT * FROM t2019_kar_street_node
WHERE ST_Within(ST_Transform(t2019_kar_street_node.geom, 3068), 
                ST_Buffer(ST_ShortestLine((SELECT geom FROM input_points WHERE id = 1),
                                          (SELECT geom FROM input_points WHERE id = 2)), 200));
--7

SELECT * FROM t2019_kar_poi_table WHERE t2019_kar_poi_table.type='Sporting Goods Store'

SELECT distinct poi_id, t2019_kar_poi_table.* FROM t2019_kar_poi_table CROSS JOIN t2019_kar_land_use_a WHERE t2019_kar_poi_table.type='Sporting Goods Store' AND
ST_Distance(t2019_kar_poi_table.geom,  t2019_kar_land_use_a.geom) <= 300

SELECT distinct poi_id, t2019_kar_poi_table.* FROM t2019_kar_poi_table CROSS JOIN t2019_kar_land_use_a WHERE t2019_kar_poi_table.type='Sporting Goods Store' AND
St_Within( t2019_kar_poi_table.geom, ST_Buffer(ST_Union(ARRAY(SELECT t2019_kar_land_use_a.geom FROM t2019_kar_land_use_a)), 300 ))


-- 8 

SELECT distinct ST_Intersection(t2019_kar_railways.geom,t2019_kar_water_lines.geom) INTO T2019_KAR_BRIDGES
	FROM t2019_kar_railways,t2019_kar_water_lines
    
    
SELECT * FROM t2019_KAR_BRIDGES