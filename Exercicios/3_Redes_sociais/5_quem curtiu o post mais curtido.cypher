// 1️⃣ Identifica o post mais curtido
MATCH (p:Post)<-[:LIKED]-(u:User)
WITH p, count(u) AS likes
ORDER BY likes DESC
LIMIT 1

// 2️⃣ Busca novamente o post e os usuários que curtiram
MATCH (p)<-[:LIKED]-(u:User)
WITH p, collect(u) AS likers

// 3️⃣ Encontra conexões de amizade entre quem curtiu
UNWIND likers AS u
OPTIONAL MATCH (u)-[:FRIENDS]-(other)
WHERE other IN likers

// 4️⃣ Retorna informações dos usuários e contagem de amigos
RETURN 
  p.post_id AS post_id,
  u.user_id AS user_id,
  u.name AS user_name,
  COUNT { (u)-[:FRIENDS]-() } AS total_friends,
  count(DISTINCT other) AS friends_who_liked_same_post
ORDER BY friends_who_liked_same_post DESC
LIMIT 50;