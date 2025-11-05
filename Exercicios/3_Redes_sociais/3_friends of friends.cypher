MATCH (me:User {user_id: 'u1'})-[:FRIENDS]-(f)-[:FRIENDS]-(fof)
WHERE NOT (me)-[:FRIENDS]-(fof) AND me <> fof
WITH
  fof,
  COLLECT(DISTINCT f.user_id) AS bridge_ids,
  COLLECT(DISTINCT f.name) AS friends
RETURN
  fof.user_id AS friend_of_friend,
  fof.name AS name,
  bridge_ids,
  friends
ORDER BY size(friends) DESC, name ASC;