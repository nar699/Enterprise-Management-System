--2.4.1 TOT OK
SELECT p.nom, p.correu_electronic, t.productes_muntats, p.nom, pr.cost
FROM Persona AS p, Treballador AS t, Producte AS pr, Fabrica AS f, Localitzacio AS l, Localitzacio AS l2
WHERE p.ID_Persona = t.ID_Treballador
AND t.ID_producte_preferit = pr.codi
AND t.ID_Fabrica = f.ID_Fabrica
AND f.ID_Localitzacio = l.ID_Localitzacio 
AND l2.ID_Localitzacio = p.ID_Localitzacio 
AND l.ciutat = l2.ciutat; 
--Validacio 2.4.1
--Mostrem els mateixos atributs que a la query principal, les ciutats on es troba la fàbrica i la ciutat on viu actualment el treballador, que és un dels requeriments de la query. Com podem comprovar els resultats d'ambdues queries son els mateixos.
SELECT p.nom, p.correu_electronic, t.productes_muntats, p.nom, pr.cost, l.ciutat AS "Ciutat Fabrica", l2.ciutat AS "Ciutat Treballador"
FROM Persona AS p, Treballador AS t, Producte AS pr, Fabrica AS f, Localitzacio AS l, Localitzacio AS l2
WHERE p.ID_Persona = t.ID_Treballador
AND t.ID_producte_preferit = pr.codi
AND t.ID_Fabrica = f.ID_Fabrica
AND f.ID_Localitzacio = l.ID_Localitzacio
AND l2.ID_Localitzacio = p.ID_Localitzacio
AND l.ciutat = l2.ciutat; 
 
--2.4.2 TOT OK
SELECT p.nom, p.pes, p.mida
FROM Producte AS p, Localitzacio AS l, Material AS m, Fabrica AS f
WHERE f.ID_Fabrica = p.ID_Fabrica 
AND f.ID_Localitzacio = l.ID_Localitzacio
AND m.ID_Producte = p.codi
AND l.pais = 'Spain'
GROUP BY p.nom, p.pes, p.mida 
ORDER BY COUNT(m.ID_Material) DESC
LIMIT 4;  
--Validacio 2.4.2
--Mostrem els mateixos atributs que a la query principal juntament amb un COUNT dels materials amb els que ha estat fet. A diferència de la query principal, aqui mostrem tots els productes fets a "Spain" així podem comprovar que realement els que mostrem son els 4 que estàn fets amb més materials que els altres. Primer executar els inserts!
--Inserts per afegir un altre material al nostre producte, així podem demostrar que realment mostrem els que més materials tenen.
INSERT INTO Material(ID_Material, nom, cost, pes, quantitat, ID_Producte)
VALUES(1010, 'Lemon', 3.04, 1.25, 21.08, 1000305);
INSERT INTO Material(ID_Material, nom, cost, pes, quantitat, ID_Producte)
VALUES(1011, 'Sugar', 2.56, 5.63, 188.25, 1000316);
INSERT INTO Material(ID_Material, nom, cost, pes, quantitat, ID_Producte)
VALUES(1012, 'Milk', 52.36, 6.35, 2.25, 1000597);
INSERT INTO Material(ID_Material, nom, cost, pes, quantitat, ID_Producte)
VALUES(1013, 'Ice', 50.56, 3.69, 3.58, 1000501);

SELECT p.nom, p.pes, p.mida, COUNT(m.ID_Material) AS "Quantitat materials"
FROM Producte AS p, Localitzacio AS l, Material AS m, Fabrica AS f
WHERE f.ID_Fabrica = p.ID_Fabrica 
AND f.ID_Localitzacio = l.ID_Localitzacio
AND m.ID_Producte = p.codi
AND l.pais = 'Spain'
GROUP BY p.nom, p.pes, p.mida
ORDER BY COUNT(m.ID_Material) DESC;   


--2.4.3 TOT OK
SELECT d.titol, d.data_creacio
FROM Documentacio AS d, Treballador AS t, Producte AS p, Fabrica AS f
WHERE t.ID_Fabrica = f.ID_Fabrica
AND f.ID_Fabrica = p.ID_Fabrica
AND p.ID_Documentacio = d.ID_Documentacio
AND t.productes_muntats > 1000
GROUP BY d.titol, d.data_creacio; 
--Validacio 2.4.3
--Mostrem els mateixos atributs que a la query principal, però, a més a més mostrem els productes que ha muntat el treballador, d'aquesta manera demostrem que realment ha muntat mes de 1000 productes. Com podem comprovar els resultats d'ambdues queries son els mateixos.
INSERT INTO Producte(codi, nom, mida, pes, data_creacio, cost, ID_Fabrica, ID_Article, ID_Categoria, ID_Documentacio)
VALUES (1001014, 'Postils - Product', 8.23, 5.67, '1999-03-27', 2.34, 12, 1302 , 9, 82);

SELECT d.titol, d.data_creacio, COUNT(d.data_modificacio), t.productes_muntats
FROM Documentacio AS d, Treballador AS t, Producte AS p, Fabrica AS f
WHERE t.ID_Fabrica = f.ID_Fabrica
AND f.ID_Fabrica = p.ID_Fabrica
AND p.ID_Documentacio = d.ID_Documentacio
AND t.productes_muntats > 1000
GROUP BY d.titol, d.data_creacio, t.productes_muntats
ORDER BY COUNT(d.data_modificacio) DESC; 

--2.4.4   TOT OK
SELECT d.titol, d.link, d.data_creacio
FROM Documentacio AS d, Video AS v, Material AS m, Categoria1 AS c1, Categoria2 AS c2, Producte AS p 
WHERE d.ID_Documentacio = v.ID_Video
AND d.ID_Documentacio = p.ID_Documentacio
AND p.codi = m.ID_Producte
AND p.ID_Categoria = c1.ID_Categoria
AND c2.ID_Categoria = c1.ID_Categoria 
AND v.duracio > 25
AND c2.nom2 = 'Printmaking'
AND m.nom LIKE 'Wood'; 
--Validacio 2.4.4
--Mostrem els mateixos atributs que a la query principal, a més a més, mostrem el material del procute realment és fusta, que té com a subcategoria "Printmaking" i que conté un video amb una duració superior a 25. Com podem comprovar els resultats d'ambdues queries son els mateixos. També, cal afegir, que vam haver d'afegir manualment amb INSERTs la informació necessària, perque hi haguessin productes amb aquestes dues categories.
SELECT d.titol, d.link, d.data_creacio, m.nom AS "Material del producte" ,c2.nom2 AS "Subcategoria", v.duracio AS "Duracio del video"
FROM Documentacio AS d, Video AS v, Material AS m, Categoria1 AS c1, Categoria2 AS c2, Producte AS p 
WHERE d.ID_Documentacio = v.ID_Video
AND d.ID_Documentacio = p.ID_Documentacio
AND p.codi = m.ID_Producte
AND p.ID_Categoria = c1.ID_Categoria
AND c2.ID_Categoria = c1.ID_Categoria 
AND v.duracio > 25
AND c2.nom2 = 'Printmaking'
AND m.nom LIKE 'Wood';    

--2.4.5 TOT OK
SELECT c3.nom3
FROM Producte AS p, Categoria1 AS c1, Categoria2 AS c2, Categoria3 AS c3
WHERE c3.ID_Categoria2 = c2.ID_Categoria2
AND c2.ID_Categoria = c1.ID_Categoria
AND p.ID_Categoria = c1.ID_Categoria 
AND p.cost > 111 
AND c3.nom3 = 'Dresses' 
GROUP BY c3.nom3;
--Validacio 2.4.5
--Mostrem els mateixos atributs que a la query principal, a més a més, mostrem el preu del producte, així podem comprovar que realment el preu és superior a 111, i la catgories superiors a la de dresses. En aquest cas, no coindideixen resultats entre les dues queries, ja que en la principal ens demanen que ho agrupem per categories, i com podem observar a la subquery tots els productes que compleixen els requisits de la query principal, pertanyen a la categoria "deresses".
SELECT c3.nom3, p.cost AS "Preu del producte", c1.nom, c2.nom2
FROM Producte AS p, Categoria1 AS c1, Categoria2 AS c2, Categoria3 AS c3
WHERE c3.ID_Categoria2 = c2.ID_Categoria2
AND c2.ID_Categoria = c1.ID_Categoria
AND p.ID_Categoria = c1.ID_Categoria
AND p.cost > 111
AND c3.nom3 = 'Dresses' 
GROUP BY c3.nom3, p.cost, c1.nom, c2.nom2;

-- A aquesta última query mostrem totes les categories sense codicions, així podem comprovar que hi ha moltes més categories i que el que mostrem està tot ben filtrat.
SELECT c3.nom3, p.cost AS "Preu del producte", c1.nom, c2.nom2
FROM Producte AS p, Categoria1 AS c1, Categoria2 AS c2, Categoria3 AS c3
WHERE c3.ID_Categoria2 = c2.ID_Categoria2
AND c2.ID_Categoria = c1.ID_Categoria
AND p.ID_Categoria = c1.ID_Categoria
GROUP BY c3.nom3, p.cost, c1.nom, c2.nom2;
