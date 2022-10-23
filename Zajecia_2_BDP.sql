SELECT * FROM public.popp




--4

SELECT * FROM public.popp

SELECT * FROM public.popp CROSS JOIN public.rivers WHERE ST_Distance(popp.geom, rivers.geom) < 1000 
                                                   AND popp.f_codedesc = 'Building';

CREATE TABLE tableB
AS(SELECT popp.gid, popp.cat, popp.f_codedesc, popp.f_code, popp.type, popp.geom FROM public.popp 
CROSS JOIN public.majrivers WHERE ST_Distance(popp.geom, majrivers.geom) < 1000 
                            AND popp.f_codedesc = 'Building' )
                                                   
--5

CREATE TABLE airportsNew
AS (SELECT name, geom, elev
    FROM public.airports);

SELECT * FROM airportsNew

--5a

SELECT * FROM airportsNew WHERE ST_X(geom) = (SELECT MIN(ST_X(geom)) FROM airportsNew) OR
                                ST_X(geom) = (SELECT MAX(ST_X(geom)) FROM airportsNew)

--5b

INSERT INTO airportsNew VALUES('airportB', ST_Centroid
 (ST_Makeline(
     (SELECT geom FROM airportsNew WHERE ST_X(geom) = (SELECT MIN(ST_X(geom)) FROM airportsNew)),
     (SELECT geom FROM airportsNew WHERE ST_X(geom) = (SELECT MAX(ST_X(geom)) FROM airportsNew))))
     ,14)
     
     SELECT * FROM airportsNew
     
--6 
     
SELECT ST_Area(ST_Buffer(ST_ShortestLine((SELECT geom FROM public.lakes WHERE names = 'Iliamna Lake'),
                                         (SELECT geom FROM public.airports WHERE name = 'AMBLER')),1000))
                                         
                                        
--7

SELECT * FROM public.trees
                                   
                               
                               
 SELECT SUM(ST_Area(ST_Intersection(trees.geom, swamp.geom)))+ 
        SUM(ST_Area(ST_Intersection(trees.geom, tundra.geom))), trees.vegdesc 
        FROM ((public.trees CROSS JOIN public.swamp)
              CROSS JOIN public.tundra) GROUP BY trees.vegdesc
              
             