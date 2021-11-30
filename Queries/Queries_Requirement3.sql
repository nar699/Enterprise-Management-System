--3.3.1 
SELECT p.nom, p.cognom, c.hores_conduccio
FROM Persona AS p, Conductor AS c, Localitzacio AS l1, Seguiment AS s, Localitzacio AS l2
WHERE c.ID_Conductor = p.ID_Persona
AND p.ID_localitzacio = l1.ID_Localitzacio    
AND l1.pais <> l2.pais
AND l2.ID_Localitzacio = s.ID_Localitzacio
AND s.ID_Conductor = c.ID_Conductor 
GROUP BY p.nom, p.cognom, c.hores_conduccio 
ORDER BY c.hores_conduccio DESC
LIMIT 6;
--Validacio 3.3.1
--Mostrem els mateixos atributs que a la query principal juntament amb el pais on resideix el treballador i un dels països on ha estat de servei, així podem comprovar que el conductor ha estat realment en un país diferent a on viu. A diferència de la query principal mostrem tots els conductors, així tambe comprovem que estem ensenyant els 6 amb més hores de conducció i podem veure que el resultat és correcte.
SELECT p.nom, p.cognom, c.hores_conduccio, l1.pais AS "Pais on viu el treballador", l2.pais AS "Pais on ha estat"
FROM Persona AS p, Conductor AS c, Localitzacio AS l1, Seguiment AS s, Localitzacio AS l2
WHERE c.ID_Conductor = p.ID_Persona
AND p.ID_localitzacio = l1.ID_Localitzacio   
AND l1.pais <> l2.pais
AND l2.ID_Localitzacio = s.ID_Localitzacio
AND s.ID_Conductor = c.ID_Conductor 
GROUP BY p.nom, p.cognom, c.hores_conduccio, l1.pais, l2.pais
ORDER BY c.hores_conduccio DESC; 

--3.3.2 
SELECT m.nom, m.superficice, COUNT(h.ID_Magatzem) AS "Numero d habitacions"
FROM Magatzem AS m, Habitacio AS h
WHERE m.ID_Magatzem = h.ID_Magatzem
GROUP BY m.nom, m.superficice, h.ID_Magatzem
HAVING COUNT(h.ID_Magatzem) BETWEEN 2 AND 4;
--Validacio 3.3.2
--En aquest cas, mostrem els mateixos atributs que a la query principal pero sense la condició que sigui un magatzem que tingui de 2 a 4 habitacions, com podem veure hi ha 30, si afegim la condició, en canvi només ens mostra 10, els que tenen entre 2 i 4 magatzem.
SELECT m.nom, m.superficice, COUNT(h.ID_Magatzem) AS "Numero d habitacions"
FROM Magatzem AS m, Habitacio AS h
WHERE m.ID_Magatzem = h.ID_Magatzem
GROUP BY m.nom, m.superficice, h.ID_Magatzem
ORDER BY COUNT(h.ID_Magatzem) ASC;
 
--3.3.3 
SELECT v.ID_Vehicle, v.estat, v.capacitat_carrega, vd.battery, vd.engine_power
FROM Vehicle AS v, Manteniment AS m, Vehicles_Drivers AS vd, Persona AS p
WHERE p.nom = vd.first_name 
AND p.cognom = vd.last_name
AND vd.model_status IS NOT NULL
AND v.ID_Conductor = p.ID_Persona
AND m.ID_Vehicle = v.ID_Vehicle
AND m.any_manteniment = '2020';
--Validacio 3.3.3 


---3.3.4 Aquesta creiem que no es pot fer
SELECT m.nom, m.superficice, ROUND(AVG(p.capacitat_bateria)),l.pais
FROM Magatzem AS M, Vehicle as v, Patinet as p, Localitzacio as l
WHERE v.ID_Vehicle = p.ID_Patinet
AND V.ID_Magatzem = m.ID_Magatzem
AND m.ID_Localitzacio = l.ID_Localitzacio
--AND l.pais = 'France'
AND p.capacitat_bateria = 10
GROUP BY m.nom, m.superficice, l.pais;
 

---3.3.5 
SELECT p.nom, p.cognom, e.titol_treball, dies_malalties
FROM Persona AS p, Magatzem AS M, Operador AS o, Empleat AS e
WHERE o.comandes_enviades >= 10
AND o.ID_Operador = e.ID_Empleat
AND e.ID_Empleat = p.ID_Persona
AND o.ID_Magatzem = m.ID_Magatzem
AND m.superficice > 10000;
--Validacio 3.3.5
--Mostrem els mateixos atributs que en la query principal, hem afegit el número de comandes enviades i la superficie del magatzem on treballen, així podem fer les dues comprovacions, que treballi en un magatzem de més de 10000 metres quadrats, en aquest cas els 4 treballadors treballen en el mateix magatzem, i que tingui més de 10 comandes enviades. El resultat coincideix.
SELECT p.nom, p.cognom, e.titol_treball, dies_malalties, o.comandes_enviades, m.superficice
FROM Persona AS p, Magatzem AS M, Operador AS o, Empleat AS e
WHERE o.comandes_enviades >= 10
AND o.ID_Operador = e.ID_Empleat
AND e.ID_Empleat = p.ID_Persona
AND o.ID_Magatzem = m.ID_Magatzem 
AND m.superficice > 10000;