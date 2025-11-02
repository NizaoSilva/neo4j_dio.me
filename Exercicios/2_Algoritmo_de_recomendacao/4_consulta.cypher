MATCH (o:Ouvinte)-[r:RECOMENDADO]->(m:Musica)
OPTIONAL MATCH (m)-[e:TEM_GENERO]->(g:Genero)
RETURN o, r, m, e, g
ORDER BY o;