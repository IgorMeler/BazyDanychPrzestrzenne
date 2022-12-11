--zad3

CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE',
'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM public.uk_250k;
----------------------------------------------
SELECT lo_export(loid, 'uk_250k.tiff') --> Save the file in a place
--where the user postgres have access. In windows a flash drive usualy works
--fine.
FROM tmp_out;
----------------------------------------------
select * FROM main_national_parks 
--zad6

CREATE TABLE uk_lake_district AS
SELECT ST_Clip(a.rast, b.geom, true)
FROM uk_250k AS a, main_national_parks AS b
WHERE ST_Intersects(a.rast, b.geom);

