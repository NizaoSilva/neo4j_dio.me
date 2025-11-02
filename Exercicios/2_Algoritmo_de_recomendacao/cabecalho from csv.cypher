LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/NizaoSilva/neo4j_dio.me/refs/heads/main/Exercicios/2_Algoritmo_de_recomendacao/Music%20Info.csv' AS row
RETURN keys(row) LIMIT 1;