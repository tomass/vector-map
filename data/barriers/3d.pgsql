SELECT
  osm_id AS gid,
  st_asmvtgeom(way, !BBOX!) AS geom,
  barrier AS kind,
  cast(substring(height from '^[0-9]+(?:[.][0-9]+)?') AS real) AS height
FROM
  planet_osm_line
WHERE
  way && !BBOX! AND
  barrier IN ('fence', 'wall', 'city_wall', 'retaining_wall', 'hedge', 'guard_rail', 'jersey_barrier', 'handrail', 'cable_barrier', 'gate', 'lift_gate', 'swing_gate', 'sliding_gate', 'wicket_gate', 'entrance') AND
  (bridge IS NULL OR bridge = 'no') AND
  (tunnel IS NULL OR tunnel = 'no') AND
  (layer IS NULL OR layer NOT IN ('1', '2', '3', '4', '5'))

UNION ALL

SELECT
  osm_id,
  st_asmvtgeom(st_boundary(way), !BBOX!),
  barrier,
  cast(substring(height from '^[0-9]+(?:[.][0-9]+)?') AS real)
FROM
  planet_osm_polygon
WHERE
  way && !BBOX! AND
  barrier IN ('fence', 'wall', 'city_wall', 'retaining_wall', 'hedge', 'guard_rail', 'jersey_barrier', 'handrail', 'cable_barrier') AND
  (bridge IS NULL OR bridge = 'no') AND
  (layer IS NULL OR layer NOT IN ('1', '2', '3', '4', '5'))

UNION ALL

SELECT
  osm_id,
  st_asmvtgeom(way, !BBOX!),
  barrier,
  cast(substring(height from '^[0-9]+(?:[.][0-9]+)?') AS real)
FROM
  planet_osm_point
WHERE
  way && st_expand(!BBOX!, 30) AND
  barrier IN ('gate', 'lift_gate', 'swing_gate', 'sliding_gate', 'wicket_gate', 'entrance', 'kissing_gate', 'turnstile', 'full-height_turnstile', 'stile')
