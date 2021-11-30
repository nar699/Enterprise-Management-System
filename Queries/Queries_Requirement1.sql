--1.4.1 
SELECT t.numero, t.tipus
FROM Targeta AS t, Botiga AS b, Operacio AS o, Venedor AS v, Persona AS p, Localitzacio AS l
WHERE o.numero_targeta = t.numero
AND o.ID_Botiga = b.ID_Botiga
AND v.ID_Botiga = b.ID_Botiga  
AND p.ID_Persona = v.ID_Venedor
AND p.ID_Localitzacio = l.ID_Localitzacio  
AND l.pais = 'France' 
GROUP BY t.numero, t.tipus HAVING COUNT(b.ID_Botiga) > 3; 

--En la primera query de validació mostrem el count i observem com la primera targeta té 5 botigues
--Fem un insert a operació amb la mateixa targeta i a una altra botiga amb un dels seus venedors francès i observem el canvi.

SELECT t.numero, t.tipus,COUNT(b.ID_Botiga)
FROM Targeta AS t, Botiga AS b, Operacio AS o, Venedor AS v, Persona AS p, Localitzacio AS l
WHERE o.numero_targeta = t.numero 
AND o.ID_Botiga = b.ID_Botiga
AND v.ID_Botiga = b.ID_Botiga 
AND p.ID_Persona = v.ID_Venedor
AND p.ID_Localitzacio = l.ID_Localitzacio 
AND l.pais = 'France'
GROUP BY t.numero, t.tipus HAVING COUNT(b.ID_Botiga) > 3; 

INSERT INTO Operacio(numero_targeta, ID_Client, ID_Botiga, data_compra)
VALUES (3547874512093966, 6, 1,'2019/02/08');

SELECT t.numero, t.tipus,COUNT(b.ID_Botiga)
FROM Targeta AS t, Botiga AS b, Operacio AS o, Venedor AS v, Persona AS p, Localitzacio AS l
WHERE o.numero_targeta = t.numero
AND o.ID_Botiga = b.ID_Botiga
AND v.ID_Botiga = b.ID_Botiga 
AND p.ID_Persona = v.ID_Venedor
AND p.ID_Localitzacio = l.ID_Localitzacio 
AND l.pais = 'France'
GROUP BY t.numero, t.tipus HAVING COUNT(b.ID_Botiga) > 3; 

--1.4.3 TOT OK
SELECT l.pais
FROM Localitzacio AS l, Botiga AS b
WHERE l.ID_Localitzacio = b.ID_Localitzacio
AND b.superficie > 1300 
GROUP BY l.pais 
ORDER BY COUNT(b.ID_Botiga) DESC   
LIMIT 2;  
--Validació 1.4.3
-- Mostrem els mateixos atributs que a la query principal afegint el nombre de botigues que te cada país, així podem comprovar que el resultat de la query principal és correcte. En la validació, a diferència de la principal, mostrem tots els països amb el nombre de botigues (sense LIMIT), així podem veure tots el països i comprovar que realment mostrem els dos amb més botigues.
SELECT l.pais, COUNT(b.ID_Botiga) AS "Numero de botigues"
FROM Localitzacio AS l, Botiga AS b
WHERE l.ID_Localitzacio = b.ID_Localitzacio
AND b.superficie > 1300
GROUP BY l.pais ORDER BY COUNT(b.ID_Botiga) DESC;

SELECT l.pais, b.ID_Botiga, b.superficie
FROM Localitzacio AS l, Botiga AS b
WHERE l.ID_Localitzacio = b.ID_Localitzacio
AND l.pais = 'United States'
AND b.superficie > 1300;


--1.4.4 
SELECT p.cognom, p.nom, p.data_naixement
FROM Persona AS p, Client AS c, Article AS a
WHERE p.ID_Persona = c.ID_Client
AND a.ID_Client = c.ID_Client
AND a.review IS NOT NULL
GROUP BY p.cognom, p.nom, p.data_naixement
ORDER BY COUNT(a.review) DESC
LIMIT 3;

--Validacio 1.4.4
--En la primera query de validació mostrem el count i observem com la primera persona té 10 review la segona 2 i la tercera 1.
--Fem un insert al client 100 per exemple perquè passi d'1 review a 2 i quan tornem a executar la query ens mostra com a canviat donant per bona la validació.
SELECT p.cognom, p.nom, p.data_naixement, COUNT(a.review) AS "Numero de reviews",p.ID_Persona
FROM Persona AS p, Client AS c, Article AS a
WHERE p.ID_Persona = c.ID_Client
AND a.ID_Client = c.ID_Client
AND a.review IS NOT NULL
GROUP BY p.cognom, p.nom, p.data_naixement, p.ID_Persona, a.ID_Client
ORDER BY COUNT(a.review) DESC
LIMIT 3;

INSERT INTO Article(ID_Article, preu, descompte, ID_Client, ID_Comanda, review, estrelles, ID_ArticleClient)
VALUES (26, 52.13, 12,100, null, 'Bon producte', 4, 647);

SELECT p.cognom, p.nom, p.data_naixement, COUNT(a.review) AS "Numero de reviews",p.ID_Persona
FROM Persona AS p, Client AS c, Article AS a
WHERE p.ID_Persona = c.ID_Client
AND a.ID_Client = c.ID_Client
AND a.review IS NOT NULL
GROUP BY p.cognom, p.nom, p.data_naixement, p.ID_Persona, a.ID_Client
ORDER BY COUNT(a.review) DESC
LIMIT 3;

--1.4.5 
SELECT c.ID_Comanda, c.estat, c.preu_final
FROM Comanda AS c, Localitzacio AS l, Persona AS p, Article AS a, Resposta AS r, Pregunta AS pr
WHERE a.ID_Comanda = c.ID_Comanda
AND pr.ID_Article = a.ID_Article
AND pr.ID_Pregunta = r.ID_Pregunta
AND r.data = '2020-03-14'
AND p.ID_Localitzacio = l.ID_Localitzacio
AND c.ID_Client = p.ID_Persona 
AND l.pais = 'Italy';  
--Validacio 1.4.5
--Mostrem els mateixos atributs que a la query principal,el país del client i la data que es va publicar la resposta, així podem verificar que el client és Italià i que la data de la resposta és la que se'ns requereix, en aquest cas 14/03/2020. Finalment, veiem que els resultats coincideixen.
SELECT c.ID_Comanda, c.estat, c.preu_final, l.pais AS "País del client", r.data AS "Data publicacio resposta"
FROM Comanda AS c, Localitzacio AS l, Persona AS p, Article AS a, Resposta AS r, Pregunta AS pr
WHERE a.ID_Comanda = c.ID_Comanda
AND pr.ID_Article = a.ID_Article
AND pr.ID_Pregunta = r.ID_Pregunta 
AND r.data = '2020-03-14'
AND p.ID_Localitzacio = l.ID_Localitzacio
AND c.ID_Client = p.ID_Persona
AND l.pais = 'Italy';

SELECT c.ID_Comanda, c.estat, c.preu_final, l.pais AS "País del client", r.data AS "Data publicacio resposta"
FROM Comanda AS c, Localitzacio AS l, Persona AS p, Article AS a, Resposta AS r, Pregunta AS pr
WHERE a.ID_Comanda = c.ID_Comanda
AND pr.ID_Article = a.ID_Article
AND pr.ID_Pregunta = r.ID_Pregunta
AND p.ID_Localitzacio = l.ID_Localitzacio
AND c.ID_Client = p.ID_Persona
AND l.pais = 'Italy';

  