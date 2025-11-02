LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/NizaoSilva/neo4j_dio.me/refs/heads/main/Exercicios/2_Algoritmo_de_recomendacao/Music%20Info.csv' AS row
WITH row
WHERE row.track_id IS NOT NULL AND trim(row.track_id) <> ''
CALL {
  WITH row
  MERGE (m:Musica {track_id: row.track_id})
  
  // propriedades condicionais
  FOREACH (_ IN CASE WHEN row.name IS NOT NULL AND trim(row.name) <> '' THEN [1] ELSE [] END |
    SET m.titulo = row.name
  )
  FOREACH (_ IN CASE WHEN row.duration_ms IS NOT NULL AND trim(row.duration_ms) <> '' THEN [1] ELSE [] END |
    SET m.duracao_ms = toInteger(row.duration_ms)
  )
  FOREACH (_ IN CASE WHEN row.energy IS NOT NULL AND trim(row.energy) <> '' THEN [1] ELSE [] END |
    SET m.energia = toFloat(row.energy)
  )
  FOREACH (_ IN CASE WHEN row.danceability IS NOT NULL AND trim(row.danceability) <> '' THEN [1] ELSE [] END |
    SET m.dancabilidade = toFloat(row.danceability)
  )
  FOREACH (_ IN CASE WHEN row.acousticness IS NOT NULL AND trim(row.acousticness) <> '' THEN [1] ELSE [] END |
    SET m.acustica = toFloat(row.acousticness)
  )
  FOREACH (_ IN CASE WHEN row.loudness IS NOT NULL AND trim(row.loudness) <> '' THEN [1] ELSE [] END |
    SET m.loudness = toFloat(row.loudness)
  )
  FOREACH (_ IN CASE WHEN row.instrumentalness IS NOT NULL AND trim(row.instrumentalness) <> '' THEN [1] ELSE [] END |
    SET m.instrumentalidade = toFloat(row.instrumentalness)
  )
  FOREACH (_ IN CASE WHEN row.valence IS NOT NULL AND trim(row.valence) <> '' THEN [1] ELSE [] END |
    SET m.valencia = toFloat(row.valence)
  )
  FOREACH (_ IN CASE WHEN row.tempo IS NOT NULL AND trim(row.tempo) <> '' THEN [1] ELSE [] END |
    SET m.tempo = toFloat(row.tempo)
  )
  FOREACH (_ IN CASE WHEN row.liveness IS NOT NULL AND trim(row.liveness) <> '' THEN [1] ELSE [] END |
    SET m.liveness = toFloat(row.liveness)
  )
  FOREACH (_ IN CASE WHEN row.mode IS NOT NULL AND trim(row.mode) <> '' THEN [1] ELSE [] END |
    SET m.modo = toInteger(row.mode)
  )
  FOREACH (_ IN CASE WHEN row.key IS NOT NULL AND trim(row.key) <> '' THEN [1] ELSE [] END |
    SET m.chave = toInteger(row.key)
  )
  FOREACH (_ IN CASE WHEN row.spotify_id IS NOT NULL AND trim(row.spotify_id) <> '' THEN [1] ELSE [] END |
    SET m.spotify_id = row.spotify_id
  )
  FOREACH (_ IN CASE WHEN row.spotify_preview_url IS NOT NULL AND trim(row.spotify_preview_url) <> '' THEN [1] ELSE [] END |
    SET m.spotify_preview_url = row.spotify_preview_url
  )

  // Artista
  FOREACH (_ IN CASE WHEN row.artist IS NOT NULL AND trim(row.artist) <> '' THEN [1] ELSE [] END |
    MERGE (a:Artista {nome: row.artist})
    MERGE (m)-[:CANTADA_POR]->(a)
  )

  // Gênero
  FOREACH (_ IN CASE WHEN row.genre IS NOT NULL AND trim(row.genre) <> '' THEN [1] ELSE [] END |
    MERGE (g:Genero {nome: row.genre})
    MERGE (m)-[:TEM_GENERO]->(g)
  )

  // Ano
  FOREACH (_ IN CASE WHEN row.year IS NOT NULL AND trim(row.year) <> '' THEN [1] ELSE [] END |
    MERGE (y:Ano {nome: toInteger(row.year)})
    MERGE (m)-[:DO_ANO_DE]->(y)
  )

  // Compasso
  FOREACH (_ IN CASE WHEN row.time_signature IS NOT NULL AND trim(row.time_signature) <> '' THEN [1] ELSE [] END |
    MERGE (c:Compasso {nome: toInteger(row.time_signature)})
    MERGE (m)-[:RITMO_TIPO]->(c)
  )

  // Tags
  FOREACH (_ IN CASE WHEN row.tags IS NOT NULL AND trim(row.tags) <> '' THEN [1] ELSE [] END |
    FOREACH (tagName IN split(row.tags, ',') |
      MERGE (t:Tag {nome: trim(tagName)})
      MERGE (m)-[:TEM_TAG]->(t)
    )
  )
} IN TRANSACTIONS OF 1000 ROWS