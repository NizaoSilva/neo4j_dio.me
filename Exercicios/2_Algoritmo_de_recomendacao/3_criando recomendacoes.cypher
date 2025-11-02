// === 1️⃣ Seleciona as top músicas de cada ouvinte com base em nota e vezes ===
MATCH (o:Ouvinte)-[r:ESCUTOU]->(m:Musica)
WITH o, m, (coalesce(r.nota, 0) * 2 + coalesce(r.vezes, 0)) AS peso
ORDER BY o, peso DESC
WITH o, collect(m)[0..3] AS top_musicas  // pega as 3 músicas principais

// === 2️⃣ Busca músicas semelhantes em Gênero, Tag ou Artista ===
UNWIND top_musicas AS musica_base
MATCH (musica_base)-[:TEM_GENERO|:TEM_TAG|:CANTADA_POR]->(x)<-[:TEM_GENERO|:TEM_TAG|:CANTADA_POR]-(m2:Musica)
WHERE musica_base <> m2
  AND NOT (o)-[:ESCUTOU]->(m2) // não recomendar o que já ouviu

// === 3️⃣ Soma pontuação de similaridade por ouvinte ===
WITH o, m2, count(DISTINCT x) AS pontos
ORDER BY o, pontos DESC
WITH o, collect(m2)[0..5] AS recomendadas

// === 4️⃣ Cria relacionamento RECOMENDADO ===
UNWIND recomendadas AS musica_recomendada
MERGE (o)-[:RECOMENDADO]->(musica_recomendada);
