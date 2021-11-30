-- 4.4.1 
SELECT p.ID_Persona, p.nom, p.cognom, e.titol_treball, e.dies_malalties, s.quantitat
FROM Persona AS p, Empleat AS e, Sou AS s, Horari AS h
WHERE e.ID_Empleat = p.ID_Persona
AND e.ID_Sou = s.ID_Sou 
AND e.ID_Horari = h.ID_Horari  
AND s.complements IS NULL
AND s.sou_actual = 'true'
GROUP BY p.ID_Persona, p.nom, p.cognom, e.titol_treball, e.dies_malalties, s.quantitat, h.hora_final, h.hora_inici
ORDER BY h.hora_final - h.hora_inici DESC
LIMIT 10; 
--Validació--
--Mostra les dades amb hora inici i final i la seva diferència horària i complements Is Null ordenats per major horari
SELECT p.ID_Persona, p.nom, p.cognom, e.titol_treball, e.dies_malalties, s.quantitat,s.complements,h.hora_final-h.hora_inici as horas ,h.hora_inici,h.hora_final
FROM Persona AS p, Empleat AS e, Sou AS s, Horari AS h
WHERE e.ID_Empleat = p.ID_Persona
AND e.ID_Sou = s.ID_Sou
AND e.ID_Horari = h.ID_Horari
AND s.complements IS NULL
AND s.sou_actual = 'true'
GROUP BY p.ID_Persona, p.nom, p.cognom, e.titol_treball, e.dies_malalties, s.quantitat,s.complements, h.hora_final, h.hora_inici
ORDER BY h.hora_final - h.hora_inici DESC;

 
-- 4.4.2 
SELECT d.nom, COUNT(of.departament) 
FROM Departament AS d, OfertaFeina AS of, Empleat AS e
WHERE e.ID_Departament = d.ID_Departament
AND e.ID_Empleat = of.ID_Persona
AND d.nom=of.departament
AND of.estat = 'open'
AND e.dies_malalties < 10
GROUP BY d.nom 
ORDER BY COUNT(of.departament) DESC
LIMIT 1; 

--Validació--
--Primera query mostra les ofertes de feina dels departaments amb un count per validar la query a realitzar i en la segona mostrem totes les ofertes de feina amb el seu estat i dies_malaltia del treballador.
SELECT d.nom, COUNT(of.departament) 
FROM Departament AS d, OfertaFeina AS of, Empleat AS e
WHERE e.ID_Departament = d.ID_Departament
AND e.ID_Empleat = of.ID_Persona
AND d.nom = of.departament
GROUP BY d.nom 
ORDER BY COUNT(of.departament) DESC;


SELECT d.nom, e.ID_Empleat,e.dies_malalties,of.estat
FROM Departament AS d, OfertaFeina AS of, Empleat AS e
WHERE e.ID_Departament = d.ID_Departament
AND e.ID_Empleat = of.ID_Persona
AND d.nom = 'Marketing'
AND d.nom = of.departament;


--4.4.3 (IMPOLUT)
SELECT of.descripcio, of.estat, of.data_publicacio
FROM OfertaFeina AS of, Candidat AS c
WHERE of.ID_OfertaFeina = c.ID_OfertaFeina
AND c.curriculum LIKE '%SQL%'
AND c.curriculum LIKE '%Java%'
GROUP BY of.ID_OfertaFeina 
ORDER BY COUNT(of.ID_OfertaFeina) DESC
LIMIT 4;
--Validació--
--Aquesta query mostra totes les ofertes de feina sense SQL i JAVA en el seu currículum i les ordena de més a menys oferta de feina.
SELECT of.descripcio, of.estat, of.data_publicacio, c.curriculum
FROM OfertaFeina AS of, Candidat AS c
WHERE of.ID_OfertaFeina = c.ID_OfertaFeina
GROUP BY of.descripcio, of.estat, of.data_publicacio, c.ID_Candidat
ORDER BY COUNT(of.ID_OfertaFeina) DESC;


--4.4.4 IMPOLUT
SELECT DISTINCT p.nom, p.cognom, p.correu_electronic, e.titol_treball, e.dies_vacances, l1.ciutat
FROM Persona AS p, Empleat AS e, Localitzacio AS l1, Edifici AS ed, Localitzacio AS l2, Departament AS d
WHERE p.ID_Persona = e.ID_Empleat
AND p.ID_Localitzacio = l1.ID_Localitzacio
AND ed.ID_Localitzacio = l2.ID_Localitzacio
AND e.ID_Departament = d.ID_Departament
AND d.ID_Edifici = ed.ID_Edifici
AND l1.ciutat <> l2.ciutat
LIMIT 10; 
--Validacio--
--Query que mostra les ciutats on viuen i on treballen i la segona query mostra l'exemple d'un que viu i treballa a la mateixa.
SELECT DISTINCT p.nom, p.cognom, p.correu_electronic, e.titol_treball, e.dies_vacances, l1.ciutat as "on viu", l2.ciutat as "ciutat edifici"
FROM Persona AS p, Empleat AS e, Localitzacio AS l1, Edifici AS ed, Localitzacio AS l2, Departament AS d
WHERE p.ID_Persona = e.ID_Empleat
AND p.ID_Localitzacio = l1.ID_Localitzacio
AND ed.ID_Localitzacio = l2.ID_Localitzacio
AND e.ID_Departament = d.ID_Departament 
AND d.ID_Edifici = ed.ID_Edifici
AND l1.ciutat <> l2.ciutat;

SELECT DISTINCT p.nom, p.cognom, p.correu_electronic, e.titol_treball, e.dies_vacances, l1.ciutat as "on viu", l2.ciutat as "ciutat edifici"
FROM Persona AS p, Empleat AS e, Localitzacio AS l1, Edifici AS ed, Localitzacio AS l2, Departament AS d
WHERE p.ID_Persona = e.ID_Empleat
AND p.ID_Localitzacio = l1.ID_Localitzacio
AND ed.ID_Localitzacio = l2.ID_Localitzacio
AND e.ID_Departament = d.ID_Departament
AND d.ID_Edifici = ed.ID_Edifici
AND l1.ciutat = l2.ciutat;


--4.4.5 

