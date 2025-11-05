MATCH (author:User)-[:POSTED]->(p:Post)<-[:LIKED]-(u:User)
WHERE author <> u
RETURN author.user_id, author.name, count(*) AS total_likes
ORDER BY total_likes DESC
LIMIT 10;