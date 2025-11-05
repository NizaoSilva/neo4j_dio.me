// USERS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/NizaoSilva/neo4j_dio.me/refs/heads/main/Exercicios/3_Redes_sociais/users.csv' AS row
MERGE (u:User {user_id: row.user_id})
SET u.name = row.name, u.age = toInteger(row.age), u.city = row.city,
u.occupation = row.occupation, u.interests = row.interests;
// GROUPS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/NizaoSilva/neo4j_dio.me/refs/heads/main/Exercicios/3_Redes_sociais/groups.csv' AS row
MERGE (g:Group {group_id: row.group_id})
SET g.name = row.name, g.topic = row.topic, g.created_at = row.created_at;
// POSTS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/NizaoSilva/neo4j_dio.me/refs/heads/main/Exercicios/3_Redes_sociais/posts.csv' AS row
MERGE (p:Post {post_id: row.post_id})
SET p.content = row.content, p.created_at = row.created_at
WITH row, p
MATCH (u:User {user_id: row.author_id})
MERGE (u)-[:POSTED]->(p);
// COMMENTS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/NizaoSilva/neo4j_dio.me/refs/heads/main/Exercicios/3_Redes_sociais/comments.csv' AS row
MERGE (c:Comment {comment_id: row.comment_id})
SET c.content = row.content, c.created_at = row.created_at
WITH row, c
MATCH (u:User {user_id: row.author_id}), (p:Post {post_id: row.post_id})
MERGE (u)-[:COMMENTED]->(c)
MERGE (c)-[:ON_POST]->(p);
// LIKES (posts)
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/NizaoSilva/neo4j_dio.me/refs/heads/main/Exercicios/3_Redes_sociais/likes.csv' AS row
MATCH (u:User {user_id: row.user_id})
WITH row, u,
     CASE 
       WHEN row.target_id STARTS WITH 'p' THEN 'Post'
       WHEN row.target_id STARTS WITH 'c' THEN 'Comment'
       ELSE NULL
     END AS tipo
OPTIONAL MATCH (p:Post {post_id: row.target_id})
OPTIONAL MATCH (c:Comment {comment_id: row.target_id})
WITH u, tipo, p, c, row, coalesce(p, c) AS alvo
WHERE alvo IS NOT NULL 
  AND ((tipo = 'Post' AND p IS NOT NULL) OR (tipo = 'Comment' AND c IS NOT NULL))
MERGE (u)-[l:LIKED {like_id: row.like_id}]->(alvo)
SET l.created_at = row.created_at;
// FRIENDSHIPS -> cria relacionamento bidirecional
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/NizaoSilva/neo4j_dio.me/refs/heads/main/Exercicios/3_Redes_sociais/friendships.csv' AS row
MATCH (a:User {user_id: row.user_a})
MATCH (b:User {user_id: row.user_b})
WITH a, b, row
WHERE a <> b
MERGE (a)-[r:FRIENDS]-(b)
SET r.since = row.since,
    r.strength = toFloat(row.strength);
// MEMBERSHIPS
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/NizaoSilva/neo4j_dio.me/refs/heads/main/Exercicios/3_Redes_sociais/memberships.csv' AS row
MATCH (u:User {user_id: row.user_id})
MATCH (g:Group {group_id: row.group_id})
MERGE (u)-[m:MEMBER_OF]->(g)
SET m.role = row.role, m.joined_at = row.joined_at;