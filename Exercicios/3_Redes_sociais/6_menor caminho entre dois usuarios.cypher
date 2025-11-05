MATCH (a:User {user_id:'u8'})
MATCH (b:User {user_id:'u17'})
CALL apoc.algo.dijkstra(a, b, 'FRIENDS', 'strength') YIELD path, weight
RETURN path, weight
LIMIT 1;