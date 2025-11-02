// === Criar 20 Ouvintes com nomes aleatórios brasileiros ===
WITH [  "João", "Maria", "Ana", "Carlos", "Paulo", "Fernanda", "Lucas", "Juliana",
  "Mariana", "Rafael", "Camila", "Bruno", "Patrícia", "Rodrigo", "Aline",
  "Felipe", "Larissa", "Gustavo", "Vanessa", "André"] AS primeiros,
[  "Silva", "Souza", "Oliveira", "Pereira", "Costa", "Santos", "Ferreira",
  "Rodrigues", "Almeida", "Nascimento", "Lima", "Araujo", "Carvalho",
  "Gomes", "Martins", "Ribeiro", "Barbosa", "Rocha", "Dias", "Melo"] AS sobrenomes
UNWIND range(1, 20) AS i
WITH i, primeiros, sobrenomes,
     apoc.coll.randomItem(primeiros) AS nome,
     apoc.coll.randomItem(sobrenomes) AS sobrenome
MERGE (o:Ouvinte {pessoa_id: i})
SET o.nome = nome + ' ' + sobrenome;

// 1) pega apenas artistas que ainda NÃO são ouvintes (evita sobrescrever)
MATCH (a:Artista)
WHERE NOT a:Ouvinte
WITH apoc.coll.shuffle(collect(a)) AS artistas_embaralhados

// 2) pega os 10 primeiros do array embaralhado
WITH artistas_embaralhados[0..10] AS artistas_sorteados

// 3) atribui label Ouvinte e pessoa_id sequencial 21..30
UNWIND range(0, size(artistas_sorteados)-1) AS idx
WITH artistas_sorteados[idx] AS artista, idx
SET artista:Ouvinte
SET artista.pessoa_id = 21 + idx
RETURN artista, artista.pessoa_id;

// === 3️⃣ Todas os 30 ouvintes escutam 5 músicas ===
MATCH (o:Ouvinte)
WITH collect(o) AS ouvintes
MATCH (m:Musica)
WITH ouvintes, collect(m) AS musicas
UNWIND ouvintes AS ouvinte
// Cria 5 músicas escutadas
WITH ouvinte, apoc.coll.shuffle(musicas)[0..5] AS musicas_aleatorias
UNWIND range(0, size(musicas_aleatorias)-1) AS idx
WITH ouvinte, musicas_aleatorias[idx] AS musica, idx
MERGE (ouvinte)-[r:ESCUTOU]->(musica)
SET r.vezes = toInteger(rand() * 20) + 1
// Marca aleatoriamente 2 dos 5 relacionamentos com nota
FOREACH (_ IN CASE WHEN idx IN apoc.coll.shuffle([0,1,2,3,4])[0..1] THEN [1] ELSE [] END |
  SET r.nota = toInteger(rand() * 10) + 1
);

// === 4️⃣ Criação dos nós Ano (1965–2015) e relacionamentos NASCIDO_EM ===
UNWIND range(1965, 2015) AS ano
MERGE (a:Ano {valor: ano});
MATCH (o:Ouvinte)
WITH o, toInteger(rand() * 51) + 1965 AS ano_nasc  // 1965 + 0..50 → 1965–2015
MATCH (a:Ano {valor: ano_nasc})
MERGE (o)-[:NASCIDO_EM]->(a);

// === 5️⃣ Cada Ouvinte segue 1 Artista aleatório ===
MATCH (o:Ouvinte)
WITH collect(o) AS ouvintes
MATCH (a:Artista)
WITH ouvintes, collect(a) AS artistas
UNWIND ouvintes AS ouvinte
WITH ouvinte, artistas[toInteger(rand() * size(artistas))] AS artista_aleatorio
MERGE (ouvinte)-[:SEGUINDO]->(artista_aleatorio);