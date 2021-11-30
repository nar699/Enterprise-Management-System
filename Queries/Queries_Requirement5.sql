--5.1 
SELECT DISTINCT p.nom, p.cognom, p.correu_electronic
FROM Persona AS p, Candidat AS c, Article AS a, OfertaFeina AS of
WHERE c.ID_OfertaFeina = of.ID_OfertaFeina
AND of.ID_Persona = p.ID_Persona
AND a.ID_Client = p.ID_Persona
AND a.estrelles < '3';
 
--Validació--- 
--En aquesta query, comprovem que els candidats que han fet al menys una review que tingui una puntuació menor a 3.
INSERT INTO Article(ID_Article, preu, descompte, ID_Client, ID_Comanda, review, estrelles, ID_ArticleClient)
VALUES (1035, 56.32, 12, 3172, 4, 'All good', 4, 647);

SELECT p.nom, p.cognom, p.correu_electronic, a.estrelles
FROM Persona AS p, Candidat AS c, Article AS a, OfertaFeina AS of
WHERE c.ID_OfertaFeina = of.ID_OfertaFeina
AND of.ID_Persona = p.ID_Persona
AND a.ID_Client = p.ID_Persona
ORDER BY p.ID_Persona DESC;

SELECT p.nom, p.cognom, p.correu_electronic, a.estrelles
FROM Persona AS p, Candidat AS c, Article AS a, OfertaFeina AS of
WHERE c.ID_OfertaFeina = of.ID_OfertaFeina
AND of.ID_Persona = p.ID_Persona
AND a.ID_Client = p.ID_Persona
AND a.estrelles < '3'
ORDER BY p.ID_Persona DESC;


--5.2 
SELECT DISTINCT p.nom, p.cognom, p.correu_electronic, e.titol_treball, v.bonificacio_vendes, s.quantitat
FROM Persona AS p, Venedor AS v, Empleat AS e, Sou AS s
WHERE p.ID_Persona = e.ID_Empleat
AND e.ID_Empleat = v.ID_Venedor
AND e.ID_Sou = s.ID_Sou
AND v.bonificacio_vendes > 10 * s.quantitat
AND s.sou_actual = 'true';
--Validació--
--Mostrem tots el venedors amb sou actual = true
--I ordena amb el càlcul de v.bonificaio > 10 * s.quantitat i podem observar el resultat de la query és l'esperat.

SELECT p.nom, p.cognom, p.correu_electronic, e.titol_treball, v.bonificacio_vendes, s.quantitat, ROUND(v.bonificacio_vendes / s.quantitat)
FROM Persona AS p, Venedor AS v, Empleat AS e, Sou AS s
WHERE p.ID_Persona = e.ID_Empleat
AND e.ID_Empleat = v.ID_Venedor
AND e.ID_Sou = s.ID_Sou
AND s.sou_actual = 'true'
ORDER BY  v.bonificacio_vendes > 10 * s.quantitat DESC;


--5.3 
SELECT p.nom, p.cognom, p.correu_electronic, e.titol_treball, c.hores_conduccio, s.quantitat
FROM Persona AS p, Empleat AS e, Sou AS s, Conductor AS c, Horari AS h, Disposa as d, Telefon as t
WHERE p.ID_Persona = e.ID_Empleat
AND e.ID_Empleat = c.ID_Conductor
AND e.ID_Sou = s.ID_Sou
AND e.ID_Horari = h.ID_Horari
AND s.sou_actual = 'true'
AND e.ID_Empleat = d.ID_Empleat
AND d.ID_Telefon = t.ID_Telefon
GROUP BY p.nom, p.cognom, p.correu_electronic, e.titol_treball, c.hores_conduccio, s.quantitat, h.hora_final, h.hora_inici
HAVING h.hora_final - h.hora_inici = '07:00:00' 
ORDER BY COUNT(d.ID_Empleat)DESC --Mirem lo de que tingui més telefons amb el COUNT de disposa, ja que allà reflexa el numero de telefons que té
LIMIT 5;

--Validació--
--Nosaltres havíem assignat un telèfon per cada persona. Per aquesta raó per fer la comprovació inserim un telèfon més en un dels treballadors que té l'horari de 7 hores i en la query de validació es mostra com s'ordena per mòbils utilitzats
INSERT INTO Disposa(ID_Empleat,ID_Telefon)VALUES (1534,1);

SELECT p.nom, p.cognom, p.correu_electronic, e.titol_treball, c.hores_conduccio, s.quantitat, COUNT(d.ID_Empleat),d.ID_Empleat
FROM Persona AS p, Empleat AS e, Sou AS s, Conductor AS c, Horari AS h, Disposa as d, Telefon as t
WHERE p.ID_Persona = e.ID_Empleat
AND e.ID_Empleat = c.ID_Conductor
AND e.ID_Sou = s.ID_Sou
AND e.ID_Horari = h.ID_Horari
AND s.sou_actual = 'true'
AND e.ID_Empleat = d.ID_Empleat
AND d.ID_Telefon = t.ID_Telefon
GROUP BY p.nom, p.cognom, p.correu_electronic, e.titol_treball, c.hores_conduccio, s.quantitat, h.hora_final, h.hora_inici,d.ID_Empleat
HAVING h.hora_final - h.hora_inici = '07:00:00' 
ORDER BY COUNT(d.ID_Empleat) DESC;


--5.4 
SELECT DISTINCT e.nom, l.ciutat
FROM Edifici AS e, Localitzacio AS l, Departament AS d, Magatzem AS m,localitzacio AS l2
WHERE e.ID_Edifici = d.ID_Edifici
AND e.ID_Localitzacio = l.ID_Localitzacio
AND m.ID_Localitzacio = l2.ID_Localitzacio
AND l.ciutat = l2.ciutat
AND d.nom = 'Human Resources'
GROUP BY e.nom, l.ciutat, m.superficice HAVING (m.superficice) < 300;

--Validació--
--La primera query ens mostra els edificis que tinguin un magatzem a la mateixa ciutat 
SELECT DISTINCT e.nom, l.ciutat,l2.ciutat,d.nom
FROM Edifici AS e, Localitzacio AS l, Departament AS d, Magatzem AS m,localitzacio AS l2
WHERE e.ID_Edifici = d.ID_Edifici
AND e.ID_Localitzacio = l.ID_Localitzacio
AND m.ID_Localitzacio = l2.ID_Localitzacio
AND l.ciutat = l2.ciutat
AND d.nom = 'Human Resources';
--Ens mostra tots els edificis de Human Reosurces i observem com ID_Edifici 12 apareix aqui i no en l'anterior això vol dir que no te un magatzem en la mateixa ciutat
SELECT DISTINCT e.nom, l.ciutat,d.nom
FROM Edifici AS e, Localitzacio AS l, Departament AS d, Magatzem AS m,localitzacio AS l2
WHERE e.ID_Edifici = d.ID_Edifici
AND e.ID_Localitzacio = l.ID_Localitzacio
AND d.nom = 'Human Resources';

--Observem tots els magatzems més petits de 300 mestres que estan a la mateixa ciutat que un edifici. Un edifici pot tenir més d'un magatzem
SELECT  DISTINCT e.nom, l.ciutat,l2.ciutat,m.superficice
FROM Edifici AS e, Localitzacio AS l, Departament AS d, Magatzem AS m,localitzacio AS l2
WHERE e.ID_Edifici = d.ID_Edifici
AND e.ID_Localitzacio = l.ID_Localitzacio
AND m.ID_Localitzacio = l2.ID_Localitzacio
AND l.ciutat = l2.ciutat
AND d.nom = 'Human Resources'
GROUP BY e.nom, l.ciutat, m.superficice,l2.ciutat HAVING (m.superficice) < 300;

--Aquesta podem observar com 4 dels edificis també tenen diversos magatzems amb més de 300 m
SELECT  DISTINCT e.nom, l.ciutat,l2.ciutat,m.superficice
FROM Edifici AS e, Localitzacio AS l, Departament AS d, Magatzem AS m,localitzacio AS l2
WHERE e.ID_Edifici = d.ID_Edifici
AND e.ID_Localitzacio = l.ID_Localitzacio
AND m.ID_Localitzacio = l2.ID_Localitzacio
AND l.ciutat = l2.ciutat
AND d.nom = 'Human Resources'
GROUP BY e.nom, l.ciutat, m.superficice,l2.ciutat HAVING (m.superficice) > 300;

--5.5 
SELECT p.nom, p.cognom, p.correu_electronic, e.titol_treball, t.productes_muntats, s.quantitat
FROM Persona AS p, Empleat AS e, Treballador AS t, Sou AS s, Horari AS h, Fabrica AS f, Producte AS pr
WHERE p.ID_Persona = e.ID_Empleat
AND p.ID_Persona = t.ID_Treballador
AND t.ID_Fabrica = f.ID_Fabrica
AND e.ID_Sou = s.ID_Sou
AND t.ID_producte_preferit = pr.codi
AND e.ID_Horari = h.ID_Horari
AND f.linies_muntatge = 3
AND h.hora_final - h.hora_inici = '07:00:00'
GROUP BY p.nom, p.cognom, p.correu_electronic, e.titol_treball, t.productes_muntats, s.quantitat;
--Validació--
--Primera query mostra tots els treballadors amb les seves hores de inici i final amb lines muntatge =3
SELECT p.nom, p.cognom, p.correu_electronic, e.titol_treball, t.productes_muntats, s.quantitat, h.hora_inici, h.hora_final
FROM Persona AS p, Empleat AS e, Treballador AS t, Sou AS s, Horari AS h, Fabrica AS f, Producte AS pr
WHERE p.ID_Persona = e.ID_Empleat
AND p.ID_Persona = t.ID_Treballador
AND t.ID_Fabrica = f.ID_Fabrica
AND e.ID_Sou = s.ID_Sou
AND t.ID_producte_preferit = pr.codi
AND e.ID_Horari = h.ID_Horari
AND f.linies_muntatge = 3
GROUP BY p.nom, p.cognom, p.correu_electronic, e.titol_treball, t.productes_muntats, s.quantitat, h.hora_final, h.hora_inici;

--Segona query mostra els treballadors que treballen 7 hores i les línies de muntatge del seu producte preferit i observem que la nostra query funciona correctament, ja que no agafa aquest treballador amb nombre diferent de línies de muntatge.

SELECT p.nom, p.cognom, p.correu_electronic, e.titol_treball, t.productes_muntats, s.quantitat,f.linies_muntatge
FROM Persona AS p, Empleat AS e, Treballador AS t, Sou AS s, Horari AS h, Fabrica AS f, Producte AS pr
WHERE p.ID_Persona = e.ID_Empleat
AND p.ID_Persona = t.ID_Treballador
AND t.ID_Fabrica = f.ID_Fabrica
AND e.ID_Sou = s.ID_Sou
AND t.ID_producte_preferit = pr.codi
AND e.ID_Horari = h.ID_Horari
AND h.hora_final - h.hora_inici = '07:00:00'
GROUP BY p.nom, p.cognom, p.correu_electronic, e.titol_treball, t.productes_muntats, s.quantitat, f.linies_muntatge;

--5.7 
SELECT p.nom, p.mida, p.pes, p.cost
FROM Producte AS p, Article AS a, Categoria1 AS c1
WHERE p.ID_Categoria = c1.ID_Categoria
AND a.ID_Article = p.ID_Article
AND c1.nom = 'Slot Cars'
AND a.estrelles < '3';
--Validacio--
--només hi ha 10 opinions de productes Slot Cars per aquesta raó per comprovar que funciona bé hem fet una query que mostri valoració Estrelles inferiors a 3
SELECT p.nom, p.mida, p.pes, p.cost,a.estrelles
FROM Producte AS p, Article AS a, Categoria1 AS c1
WHERE p.ID_Categoria = c1.ID_Categoria
AND a.ID_Article = p.ID_Article
AND c1.nom = 'Slot Cars';
--On observem que la comprovació de les estrelles està ben feta
SELECT p.nom, p.mida, p.pes, p.cost,a.estrelles
FROM Producte AS p, Article AS a, Categoria1 AS c1
WHERE p.ID_Categoria = c1.ID_Categoria
AND a.ID_Article = p.ID_Article
AND c1.nom = 'Slot Cars'
AND a.estrelles < '2';
--Query amb valoració inferior a 3 però sense pertànyer exclusivament a Slot Cars
SELECT p.nom, p.mida, p.pes, p.cost,c1.nom,a.estrelles
FROM Producte AS p, Article AS a, Categoria1 AS c1
WHERE p.ID_Categoria = c1.ID_Categoria
AND a.ID_Article = p.ID_Article
AND a.estrelles < '3';

 
--5.8 
SELECT p.nom, p.cognom, p.correu_electronic, p.numero_telefon, l.ciutat
FROM Persona AS p, Localitzacio AS l, Producte AS po, Fabrica AS f, Localitzacio AS l1, Article AS a
WHERE po.ID_fabrica = f.ID_fabrica 
AND f.ID_Localitzacio = l1.ID_Localitzacio
AND po.ID_Article = a.ID_Article 
AND a.ID_Client = p.ID_Persona 
AND p.ID_Localitzacio = l.ID_Localitzacio
AND l.ciutat = l1.ciutat;

--Validacio
--En aquesta QUERY mostrem els productes comprats pels clients, el lloc on estan fabricats i el lloc on es compra siguin iguals
SELECT p.nom, p.ID_persona, l.ciutat, l1.ciutat
FROM Persona AS p, Localitzacio AS l, Producte AS po, Fabrica AS f, Localitzacio AS l1, Article AS a
WHERE po.ID_fabrica = f.ID_fabrica 
AND f.ID_Localitzacio = l1.ID_Localitzacio
AND po.ID_Article = a.ID_Article 
AND a.ID_Client = p.ID_Persona 
AND p.ID_Localitzacio = l.ID_Localitzacio
AND l.ciutat = l1.ciutat;

--En aquesta QUERY mostrem els productes comprats pels clients, el lloc on estan fabricats i on es compren siguin iguals o diferents
SELECT p.nom, p.ID_persona, l1.ciutat AS "Ciutat fabricacio", l.ciutat AS "Ciutat Compra producte"
FROM Persona AS p, Localitzacio AS l, Producte AS po, Fabrica AS f, Localitzacio AS l1, Article AS a
WHERE po.ID_fabrica = f.ID_fabrica 
AND f.ID_Localitzacio = l1.ID_Localitzacio
AND po.ID_Article = a.ID_Article 
AND a.ID_Client = p.ID_Persona 
AND p.ID_Localitzacio = l.ID_Localitzacio; 



--5.10 
SELECT t.ID_Treballador, p.nom, p.cognom, pr.nom
FROM Treballador as t, Producte as pr, Persona as p, Localitzacio as l, Fabrica as f, Magatzem AS m
WHERE t.ID_producte_preferit = pr.codi
ANd t.ID_Treballador = p.ID_Persona
AND t.ID_Fabrica = f.ID_Fabrica
AND f.ID_Localitzacio = l.ID_Localitzacio
AND l.pais = 'Italy'
AND m.ID_Fabrica = f.ID_Fabrica
AND m.superficice > 1100;

--Validació--
--En aquesta query mostrem tots els treballadors que treballen a Itàlia i es pot veure la superfície del magatzem on treballan.PD hi ha treballadors que treballan a 2 Magatzems diferents pero jobie i elli al no treballar en un magatzem de mes de 1100 no apareixen en la query a realitzar 
SELECT t.ID_Treballador, p.nom, p.cognom, pr.nom, m.superficice, l.pais, m.ID_Magatzem
FROM Treballador as t, Producte as pr, Persona as p, Localitzacio as l, Fabrica as f, Magatzem AS m
WHERE t.ID_producte_preferit = pr.codi
ANd t.ID_Treballador = p.ID_Persona
AND t.ID_Fabrica = f.ID_Fabrica
AND f.ID_Localitzacio = l.ID_Localitzacio
AND l.pais = 'Italy'
AND m.ID_Fabrica = f.ID_Fabrica
ORDER BY m.superficice DESC; 


--5.11 
SELECT DISTINCT p.nom, p.cognom
FROM Persona AS p, Vehicle AS v, Camio AS c, Seguiment AS s, Localitzacio AS l, Comanda AS co
WHERE p.ID_Persona = co.ID_Client
AND s.ID_Localitzacio = co.ID_localitzacio
AND v.ID_Vehicle = s.ID_Vehicle
AND v.ID_Vehicle = c.ID_Camio
AND c.matricula LIKE '%79';
 
--Validació--
--En aquesta query comprovem tots els camions que han transportat una comanda i ni hi ha 2 que no acaben amb 79 per aquesta raó està ben validada.
INSERT INTO Vehicle(ID_Vehicle, model, estat, capacitat_carrega, ID_Magatzem, ID_Conductor, ID_Localitzacio)
VALUES(577, 'Volkswagen', 'Delivering', 2500, 25, 1417, 2556);
INSERT INTO Camio(ID_Camio, matricula, potencia_motor)
VALUES(577, 'LGS 1179', 220);
INSERT INTO Seguiment(ID_Conductor, ID_Vehicle, ID_Localitzacio, durada)
VALUES(1417, 577, 56, 56);
--Camio que la matricula no acaba en 79
INSERT INTO Vehicle(ID_Vehicle, model, estat, capacitat_carrega, ID_Magatzem, ID_Conductor, ID_Localitzacio)
VALUES(578, 'Volkswagen', 'Delivering', 2500, 25, 1417, 2556);
INSERT INTO Camio(ID_Camio, matricula, potencia_motor)
VALUES(578, 'MPB 1180', 220);
INSERT INTO Seguiment(ID_Conductor, ID_Vehicle, ID_Localitzacio, durada)
VALUES(1417, 578, 56, 56);

SELECT  DISTINCT p.nom, c.matricula
FROM Persona AS p, Vehicle AS v, Camio AS c, Seguiment AS s, Localitzacio AS l, Comanda AS co
WHERE p.ID_Persona = co.ID_Client
AND s.ID_Localitzacio = co.ID_localitzacio
AND v.ID_Vehicle = s.ID_Vehicle
AND v.ID_Vehicle = c.ID_Camio; 

SELECT  DISTINCT p.nom, c.matricula
FROM Persona AS p, Vehicle AS v, Camio AS c, Seguiment AS s, Localitzacio AS l, Comanda AS co
WHERE p.ID_Persona = co.ID_Client
AND s.ID_Localitzacio = co.ID_localitzacio
AND v.ID_Vehicle = s.ID_Vehicle
AND v.ID_Vehicle = c.ID_Camio
AND c.matricula LIKE '%79';



--5.12 
SELECT p.ID_Patinet
FROM magatzem AS m, patinet AS p,vehicle AS v, localitzacio AS l,comanda AS c,seguiment AS s
WHERE p.ID_Patinet = v.ID_Vehicle
AND v.ID_Magatzem = m.ID_Magatzem
AND m.ID_Localitzacio = l.ID_Localitzacio
AND l.pais = 'Italy'
AND s.ID_Vehicle = v.ID_Vehicle
AND s.ID_Localitzacio = c.ID_Localitzacio
AND c.preu_final > 1000
ORDER BY c.preu_final DESC
LIMIT 5; 

--Validacio--
--En aquesta query mostrem tots els patinets que han entregat una comanda i en la query a realitzar volem que només siguin d'Itàlia per aquesta raó tant el patinet 21 com el 24 no estan seleccionades 
--i desprès ordenat pel preu_final dels productes entregats com podem comprobar en aquesta query de validació per tant la nostra query queda ben validada.
SELECT p.ID_Patinet,c.preu_final,l.pais
FROM magatzem AS m, patinet AS p,vehicle AS v, localitzacio AS l,comanda AS c,seguiment AS s
WHERE p.ID_Patinet = v.ID_Vehicle
AND v.ID_Magatzem = m.ID_Magatzem
AND m.ID_Localitzacio = l.ID_Localitzacio
AND s.ID_Vehicle = v.ID_Vehicle
AND s.ID_Localitzacio = c.ID_Localitzacio
ORDER BY c.preu_final DESC;  


