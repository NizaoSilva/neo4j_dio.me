MATCH (p:Post)<-[:LIKED]-(u:User)
RETURN p.post_id, p.content, count(*) AS likes
ORDER BY likes DESC LIMIT 5;