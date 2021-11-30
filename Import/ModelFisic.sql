--Taula plena de localitzacions, tant les de person_review com localitzacions creades per nosaltres
DROP TABLE IF EXISTS Localitzacio CASCADE;
CREATE TABLE Localitzacio(
    ID_Localitzacio SERIAL,    
    adreça VARCHAR(255),
    ciutat VARCHAR(255),
    pais VARCHAR(255),  
    codi_postal VARCHAR(255),   

    PRIMARY KEY(ID_Localitzacio) 
);   
INSERT INTO Localitzacio(adreça, ciutat, pais, codi_postal)
SELECT address, city, country, postal_code
FROM Person_Review;

--Conductor 576(1000-1576)
INSERT INTO Localitzacio(adreça, ciutat, pais, codi_postal)
SELECT address, city, country, postal_code
FROM Vehicles_Drivers
WHERE driving_hours IS NOT NULL;
--Operador 424(1576-2000)
INSERT INTO Localitzacio(adreça, ciutat, pais, codi_postal)
SELECT address, city, country, postal_code
FROM Vehicles_Drivers
WHERE driving_hours IS  NULL; 

--Localitzacions creades per nosaltres(2000-3000)
DROP TABLE IF EXISTS Localitzacio_extra CASCADE; 
CREATE TABLE Localitzacio_extra( 
    adreça VARCHAR(255),
    ciutat VARCHAR(255),
    pais VARCHAR(255),
    codi_postal VARCHAR(255)
);
COPY Localitzacio_extra FROM 'C:\Users\Public\Taules_bbdd1\localitzacions_extra.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
INSERT INTO Localitzacio(adreça, ciutat, pais, codi_postal)
SELECT adreça, ciutat, pais, codi_postal
FROM Localitzacio_extra;

--Taula per omplir les dades de persona, enlleçant persona amb localitzacio
DROP TABLE IF EXISTS Data_local CASCADE;
CREATE TABLE Data_local(
    data_naixement DATE,
    ID_Localitzacio SERIAL
);
COPY Data_local FROM 'C:\Users\Public\Taules_bbdd1\Data_local.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
COPY Data_local FROM 'C:\Users\Public\Taules_bbdd1\Data_local2.csv' DELIMITER ',' QUOTE '"' CSV HEADER;

--Taules creades per poder complir els productes cartesians
DROP TABLE IF EXISTS OfertaFeina_rand CASCADE;
CREATE TABLE OfertaFeina_rand(
    ID_Persona SERIAL,
    data_naixement DATE,
    numero_telefon VARCHAR(255),
    ID_Localitzacio SERIAL,	
	ID_OfertaFeina SERIAL
);
COPY OfertaFeina_rand FROM 'C:\Users\Public\Taules_bbdd1\oferta_feina_rand.csv' DELIMITER ',' QUOTE '"' CSV HEADER;

--Taules creades per poder complir els productes cartesians
DROP TABLE IF EXISTS OfertaFeina_persona CASCADE;
CREATE TABLE OfertaFeina_persona(
    ID_Persona INTEGER,
    nom VARCHAR(255),
    cognom VARCHAR(255),
    data_naixement DATE,
    correu_electronic VARCHAR(255),
    numero_telefon VARCHAR(255),
    ID_Localitzacio SERIAL
);
INSERT INTO OfertaFeina_persona (ID_Persona, nom, cognom, data_naixement, correu_electronic, numero_telefon, ID_Localitzacio)
SELECT ofr.ID_Persona, eob.first_name, eob.last_name, ofr.data_naixement, eob.email, ofr.numero_telefon, ofr.ID_Localitzacio
FROM OfertaFeina_rand AS ofr, Employee_Offering_bo AS eob
WHERE ofr.ID_OfertaFeina = eob.id;

--Taules creades per poder complir els productes cartesians
DROP TABLE IF EXISTS Persona_aux CASCADE; 
CREATE TABLE Persona_aux(
    ID_Persona SERIAL,
    nom VARCHAR(255),
    cognom VARCHAR(255),
    data_naixement DATE,
    correu_electronic VARCHAR(255),
    numero_telefon VARCHAR(255),
    ID_Localitzacio SERIAL, 

    PRIMARY KEY(ID_Persona),
    FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
INSERT INTO Persona_aux(nom, cognom, correu_electronic, numero_telefon)
SELECT pr.first_name, pr.last_name, pr.email, pr.phone
FROM Person_Review AS pr;

--Conductor
INSERT INTO Persona_aux(nom, cognom, correu_electronic, numero_telefon)
SELECT vd.first_name, vd.last_name, vd.email, vd.phone
FROM Vehicles_Drivers as vd
WHERE driving_hours IS NOT NULL;
--Operador
INSERT INTO Persona_aux(nom, cognom, correu_electronic, numero_telefon)
SELECT vd.first_name, vd.last_name, vd.email, vd.phone
FROM Vehicles_Drivers as vd
WHERE driving_hours IS  NULL;

--Taula plena de persones, tant les de person_review com persones creades per nosaltres
DROP TABLE IF EXISTS Persona CASCADE; 
CREATE TABLE Persona(
    ID_Persona SERIAL,
    nom VARCHAR(255),
    cognom VARCHAR(255),
    data_naixement DATE,
    correu_electronic VARCHAR(255),
    numero_telefon VARCHAR(255),
    ID_Localitzacio INTEGER,

    PRIMARY KEY(ID_Persona),
    FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
INSERT INTO Persona(nom, cognom,data_naixement,correu_electronic, numero_telefon,ID_Localitzacio)
SELECT pa.nom, pa.cognom, d.data_naixement, pa.correu_electronic, pa.numero_telefon, pa.ID_Localitzacio
FROM Persona_aux AS pa, Data_local as d
WHERE pa.ID_Localitzacio = d.ID_Localitzacio;

--Persones creades per nosaltres
DROP TABLE IF EXISTS Persona2 CASCADE; 
CREATE TABLE Persona2(
    nom VARCHAR(255),
    cognom VARCHAR(255),
    data_naixement DATE,
    correu_electronic VARCHAR(255),
    numero_telefon VARCHAR(255),
    ID_Localitzacio INTEGER
);
COPY Persona2 FROM 'C:\Users\Public\Taules_bbdd1\mes_persones.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
INSERT INTO Persona(nom, cognom, data_naixement, correu_electronic, numero_telefon, ID_Localitzacio)
SELECT p2.nom, p2.cognom, p2.data_naixement, p2.correu_electronic, p2.numero_telefon, p2.ID_Localitzacio
FROM Persona2 AS p2;
INSERT INTO Persona(nom, cognom,data_naixement,correu_electronic, numero_telefon,ID_Localitzacio)
SELECT ofp.nom, ofp.cognom, ofp.data_naixement, ofp.correu_electronic, ofp.numero_telefon, ofp.ID_Localitzacio
FROM OfertaFeina_persona AS ofp;

DROP TABLE IF EXISTS Sou CASCADE;
CREATE TABLE Sou(
	ID_Sou SERIAL,
	quantitat FLOAT4,
	complements FLOAT4,
	data_inici DATE,
	sou_actual BOOLEAN, 
	
	PRIMARY KEY (ID_Sou)
);
COPY Sou FROM 'C:\Users\Public\Taules_bbdd1\sou.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Horari CASCADE;
CREATE TABLE Horari(
	ID_Horari SERIAL,
	nom VARCHAR(255),
	hora_inici TIME,
	hora_final TIME,
	
	PRIMARY KEY (ID_Horari)
);
COPY Horari FROM 'C:\Users\Public\Taules_bbdd1\horari.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Edifici CASCADE;
CREATE TABLE Edifici(
	ID_Edifici SERIAL,
	nom VARCHAR(255),
	superficie FLOAT4,
	ID_Localitzacio INTEGER,
	
	PRIMARY KEY (ID_Edifici),
	FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
COPY Edifici FROM 'C:\Users\Public\Taules_bbdd1\edifici.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Departament CASCADE;
CREATE TABLE Departament(
	ID_Departament SERIAL,
	nom VARCHAR(255),
	ID_Edifici SERIAL,
	
	PRIMARY KEY (ID_Departament),
	FOREIGN KEY (ID_Edifici) REFERENCES Edifici(ID_Edifici)
);
INSERT INTO Departament(nom)
SELECT eo.department
FROM Employee_Offering AS eo
WHERE eo.department IS NOT NULL
GROUP BY eo.department;
COPY Departament FROM 'C:\Users\Public\Taules_bbdd1\Departament.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Empleat CASCADE;
CREATE TABLE Empleat(
	ID_Empleat INTEGER,
	titol_treball VARCHAR(255),
	dies_vacances INTEGER,
	dies_malalties INTEGER,
	ID_Sou INTEGER,
	ID_Departament INTEGER,
	ID_Horari INTEGER,
	
	PRIMARY KEY(ID_Empleat),
	FOREIGN KEY (ID_Sou) REFERENCES Sou(ID_Sou),
	FOREIGN KEY (ID_Departament) REFERENCES Departament(ID_Departament),
	FOREIGN KEY (ID_Horari) REFERENCES Horari(ID_Horari)
);
COPY Empleat FROM 'C:\Users\Public\Taules_bbdd1\Empleat.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
COPY Empleat FROM 'C:\Users\Public\Taules_bbdd1\Empleat2.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
COPY Empleat FROM 'C:\Users\Public\Taules_bbdd1\Empleat3.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS OfertaFeina CASCADE; 
CREATE TABLE OfertaFeina(
	ID_OfertaFeina SERIAL,
	departament VARCHAR(255),
	descripcio TEXT,
	estat VARCHAR(255),
	data_publicacio DATE,
	ID_Persona INTEGER,
	
	PRIMARY KEY (ID_OfertaFeina),
	FOREIGN KEY (ID_Persona) REFERENCES Persona(ID_Persona)
);
INSERT INTO OfertaFeina (departament, descripcio, estat, data_publicacio, ID_Persona)
SELECT eob.department, eob.job_offering, eob.jo_status, eob.jo_date, p.ID_Persona
FROM Persona AS p, Employee_Offering_bo AS eob
WHERE eob.first_name = p.nom
AND eob.last_name = p.cognom
AND job_offering IS NOT NULL;


DROP TABLE IF EXISTS Client CASCADE;
CREATE TABLE Client(
	ID_Client INTEGER,
	
	PRIMARY KEY(ID_Client)
);
COPY Client FROM 'C:\Users\Public\Taules_bbdd1\Client.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Botiga CASCADE;
CREATE TABLE Botiga(
	ID_Botiga SERIAL,
	nom VARCHAR(255),
	superficie FLOAT,
	ID_Localitzacio INTEGER,
	
	PRIMARY KEY (ID_Botiga),
	FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
COPY Botiga FROM 'C:\Users\Public\Taules_bbdd1\botiga.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Venedor CASCADE;
CREATE TABLE Venedor(
	ID_Venedor INTEGER,
	bonificacio_vendes INTEGER,
	import_total FLOAT4,
	ID_Botiga INTEGER,
	
	PRIMARY KEY (ID_Venedor),
	FOREIGN KEY (ID_Botiga) REFERENCES Botiga(ID_Botiga)
);
COPY Venedor FROM 'C:\Users\Public\Taules_bbdd1\Venedor.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Targeta CASCADE;
CREATE TABLE Targeta(
	ID_targeta SERIAL,
	numero VARCHAR(255),
	tipus VARCHAR(255),
	mes_caducitat INTEGER,
	any_caducitat INTEGER,
	
	PRIMARY KEY (numero)
);
INSERT INTO Targeta (numero, tipus,mes_caducitat,any_caducitat)
SELECT pr.credit_card, pr.credit_card_type, pr.month, pr.year
FROM Person_Review AS pr;


DROP TABLE IF EXISTS Comanda_aux CASCADE;
CREATE TABLE Comanda_aux (
	ID_Comanda INTEGER,
	estat VARCHAR(255),
	impostos FLOAT4,
	preu_final FLOAT4,
	data_realitzacio DATE,
	ID_Client SERIAL,
	ID_Venedor INTEGER,
	ID_Localitzacio SERIAL,
	
	FOREIGN KEY (ID_Client) REFERENCES Client(ID_Client),
	FOREIGN KEY (ID_Venedor) REFERENCES Venedor(ID_Venedor),
	FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
COPY Comanda_aux FROM 'C:\Users\Public\Taules_bbdd1\Comanda_aux.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Comanda CASCADE;
CREATE TABLE Comanda(
	ID_Comanda INTEGER, 
	estat VARCHAR(255),
	impostos FLOAT4,
	preu_final FLOAT4,
	data_realitzacio DATE, 
	ID_Client SERIAL,  
	ID_Venedor INTEGER,
	ID_Localitzacio SERIAL,
	
	PRIMARY KEY (ID_Comanda),
	FOREIGN KEY (ID_Client) REFERENCES Client(ID_Client),
	FOREIGN KEY (ID_Venedor) REFERENCES Venedor(ID_Venedor),
	FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
INSERT INTO Comanda (ID_Comanda, estat, impostos, preu_final, data_realitzacio, ID_Client, ID_Venedor, ID_Localitzacio)
SELECT pr.orderItemID, c.estat, c.impostos, c.preu_final, c.data_realitzacio, c.ID_Client, c.ID_Venedor, c.ID_Localitzacio
FROM Person_Review AS pr, Comanda_aux AS c, Persona as p
WHERE c.ID_Client = p.ID_Persona 
AND p.nom = pr.first_name 
AND p.cognom = pr.last_name
AND pr.orderItemID IS NOT NULL;
--Informacio extra que afegim per millorar el funcionament de les queries
INSERT INTO Comanda (ID_Comanda, estat, impostos, preu_final, data_realitzacio, ID_Client, ID_Venedor, ID_Localitzacio)
VALUES (3000,'o',5,1202,'2020-2-20',1,2051,2848),(3001,'o',5,1202,'2020-3-20',1,2051,2789),(3002,'o',5,1229,'2020-4-20',1,2051,2978),
(3003,'o',5,1202,'2020-5-20',1,2051,2915),(3004,'o',5,1202,'2020-6-20',1,2051,2574),(3005,'o',5,1202,'2020-7-20',1,2051,2901),
(3006,'o',5,1202,'2020-8-20',1,2051,2892),(3007,'o',5,1202,'2020-9-20',1,2051,2896),(3008,'o',5,1202,'2020-10-20',1,2051,2749),
(3009,'o',5,1202,'2020-11-20',1,2051,2663);
COPY Comanda FROM 'C:\Users\Public\Taules_bbdd1\comanda_query.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


--Impolut taula que relaciona tot-inclus amb comanda amb la data_compra
DROP TABLE IF EXISTS Operacio CASCADE;
CREATE TABLE Operacio(
	numero_targeta VARCHAR(255),
	ID_Client INTEGER,
	ID_Botiga INTEGER,
	data_compra DATE,
	
	PRIMARY KEY (numero_targeta, ID_Botiga, data_compra),
	FOREIGN KEY (numero_targeta) REFERENCES Targeta(numero),
	FOREIGN KEY (ID_Client) REFERENCES Client(ID_Client),
	FOREIGN KEY (ID_Botiga) REFERENCES Botiga(ID_Botiga) 
);
INSERT INTO Operacio(numero_targeta, ID_Client, ID_Botiga, data_compra)
SELECT pr.credit_card, p.ID_Persona, v.ID_Botiga, c.data_realitzacio
FROM Person_review AS pr, Persona AS p, Comanda AS c, Venedor AS v
WHERE p.nom = pr.first_name
AND p.cognom = pr.last_name
AND p.ID_Persona = c.ID_Client
AND v.ID_Venedor = c.ID_Venedor;   
COPY Operacio FROM 'C:\Users\Public\Taules_bbdd1\operacio.csv' DELIMITER ',' QUOTE '"' CSV HEADER; 


DROP TABLE IF EXISTS Fabrica CASCADE;
CREATE TABLE Fabrica( 
	ID_Fabrica SERIAL,
	nom VARCHAR(255),
	superficie FLOAT4,
	linies_muntatge INTEGER,
	ID_Localitzacio INTEGER,
	
	PRIMARY KEY (ID_Fabrica),
	FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
COPY Fabrica FROM 'C:\Users\Public\Taules_bbdd1\Fabrica.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
--Informacio extra que afegim per millorar el funcionament de les queries
INSERT INTO Fabrica(ID_Fabrica, nom, superficie, linies_muntatge, ID_Localitzacio)
VALUES(51, 'Postilaso S.L', 1450.63, 56, 1541), (52, 'Cisquella S.A', 1600.56, 86, 1547), 
(53, 'Llobets Factory', 1300.54, 85, 1590), (54, 'Gumby S.L', 1686.32, 55, 1634),
(55, 'Albert_Lyon SP', 233.3, 34, 1);


--Aqui guardem tots els articles disponibles per comprar
DROP TABLE IF EXISTS Article_aux CASCADE;
CREATE TABLE Article_aux(
	ID_Article SERIAL,
	preu FLOAT4,
	descompte INTEGER,
	
	PRIMARY KEY (ID_Article)
);
COPY Article_aux FROM 'C:\Users\Public\Taules_bbdd1\Article1.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
COPY Article_aux FROM 'C:\Users\Public\Taules_bbdd1\Article2.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
COPY Article_aux FROM 'C:\Users\Public\Taules_bbdd1\Article3.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
SELECT*FROM Article_aux;


--Aqui guardem els articles ja comprats
DROP TABLE IF EXISTS Article CASCADE;
CREATE TABLE Article(
	ID_Article SERIAL,
	preu FLOAT4,
	descompte INTEGER,
	ID_Client INTEGER,
	ID_Comanda INTEGER,
	review TEXT,
	estrelles VARCHAR(255),
	ID_ArticleClient SERIAL,
	
	PRIMARY KEY (ID_Article),
	FOREIGN KEY (ID_Client) REFERENCES Client(ID_Client),
	FOREIGN KEY (ID_Comanda) REFERENCES Comanda(ID_Comanda)
);
INSERT INTO Article (ID_Article, preu, descompte, ID_Client, ID_Comanda, review, estrelles)
SELECT aa.ID_Article, aa.preu, aa.descompte, p.ID_Persona, aa.ID_Article, pr.review, pr.score
FROM Article_aux AS aa, Person_Review AS pr, Persona AS p
WHERE p.nom = pr.first_name 
AND p.cognom = pr.last_name 
AND pr.orderItemID = aa.ID_Article;
--Informacio extra que afegim per millorar el funcionament de les queries
INSERT INTO Client (ID_Client)
VALUES(3021), (3046), (3098), (3099), (3091), (3117), (3172), (3006), (3010), (3019);
INSERT INTO Article (ID_Article, preu, descompte, ID_Client, ID_Comanda, review, estrelles)
VALUES (1, 456.78, 2, 3021, null, 'Todo mal', 2), (2, 46.78, 21, 3046, null, 'Todo mal', 1), 
(3, 126.78, 11, 3098, null, 'Todo mal', 0), (5, 126.78, 11, 3099, null, 'Todo mal', 1),
(6, 60.74, 11, 3091, null, 'Todo mal', 2), (8, 26.8, 11, 3117, null, 'Todo mal', 1),
(9, 126.78, 11, 3172, null, 'Todo mal', 2), (10, 5.78, 11, 3006, null, 'Todo mal', 1),
(11, 126.38, 11, 3010, null, 'Todo mal', 1), (12, 23.78, 11, 3019, null, 'Todo mal', 1);
COPY Article FROM 'C:\Users\Public\Taules_bbdd1\article_query.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Pregunta CASCADE;
CREATE TABLE Pregunta(
	ID_Pregunta SERIAL,
	data DATE,
	hora TIME,
	ID_Client INTEGER,
	ID_Article INTEGER,
	
	PRIMARY KEY (ID_Pregunta),
	FOREIGN KEY (ID_Client) REFERENCES Client(ID_Client),
	FOREIGN KEY (ID_Article) REFERENCES Article_aux(ID_Article)
);
COPY Pregunta FROM 'C:\Users\Public\Taules_bbdd1\pregunta.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Resposta_aux CASCADE;
CREATE TABLE Resposta_aux(
	ID_Resposta SERIAL,
	data DATE,
	hora TIME,
	ID_Client INTEGER,
	ID_Pregunta INTEGER
);
COPY Resposta_aux FROM 'C:\Users\Public\Taules_bbdd1\resposta.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Resposta CASCADE;
CREATE TABLE Resposta(
	ID_Resposta SERIAL,
	data DATE,
	hora TIME,
	ID_Client INTEGER,
	ID_Article INTEGER,
	ID_Pregunta INTEGER,
	
	PRIMARY KEY (ID_Resposta),
	FOREIGN KEY (ID_Client) REFERENCES Client(ID_Client),
	FOREIGN KEY (ID_Article) REFERENCES Article_aux(ID_Article),
	FOREIGN KEY (ID_Pregunta) REFERENCES Pregunta(ID_Pregunta)
);
INSERT INTO Resposta (data, hora, ID_Client, ID_Article, ID_Pregunta)
SELECT ra.data, ra.hora, ra.ID_Client, pre.ID_Article, ra.ID_Pregunta
FROM Resposta_aux AS ra, Pregunta AS pre
WHERE ra.ID_Pregunta = pre.ID_Pregunta;
select * from Resposta;


--2100 A 2300
DROP TABLE IF EXISTS Treballador CASCADE;
CREATE TABLE Treballador(
	ID_Treballador SERIAL,
	productes_muntats INTEGER,
	ID_producte_preferit INTEGER,
	ID_Fabrica INTEGER,
	
	PRIMARY KEY (ID_Treballador),
	FOREIGN KEY (ID_Fabrica) REFERENCES Fabrica(ID_Fabrica)
);
COPY Treballador FROM 'C:\Users\Public\Taules_bbdd1\treballador.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Documentacio_aux CASCADE;
CREATE TABLE Documentacio_aux(
	ID_Documentacio INTEGER,
	titol VARCHAR(255),
	descripcio TEXT,
	link TEXT, 
	data_creacio DATE,
	data_modificacio DATE,
	ID_Treballador INTEGER
);
INSERT INTO Documentacio_aux (ID_Documentacio, titol, descripcio, link, data_creacio)
SELECT ID, name, description, path, date
FROM Product_Document;


DROP TABLE IF EXISTS Documentacio2 CASCADE;
CREATE TABLE Documentacio2(
	ID_Documentacio INTEGER,
	data_modificacio DATE,
	ID_Treballador INTEGER
);
COPY Documentacio2 FROM 'C:\Users\Public\Taules_bbdd1\documentacio2.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Documentacio CASCADE;
CREATE TABLE Documentacio(
	ID_Documentacio SERIAL,
	titol VARCHAR(255),
	descripcio TEXT,
	link TEXT, 
	data_creacio DATE,
	data_modificacio DATE,
	ID_Treballador INTEGER,
	
	PRIMARY KEY (ID_Documentacio),
	FOREIGN KEY (ID_Treballador) REFERENCES Treballador(ID_Treballador)
);
INSERT INTO Documentacio (titol, descripcio, link, data_creacio, data_modificacio, ID_Treballador)
SELECT da.titol, da.descripcio, da.link, da.data_creacio, d2.data_modificacio, d2.ID_Treballador
FROM Documentacio_aux AS da, Documentacio2 AS d2
WHERE da.ID_Documentacio = d2.ID_Documentacio;


DROP TABLE IF EXISTS Categoria1 CASCADE; 
CREATE TABLE Categoria1(
	ID_Categoria SERIAL,
	nom VARCHAR(255),
	
	PRIMARY KEY (ID_Categoria)
);   
INSERT INTO Categoria1 (nom)
SELECT pc.Category1
FROM Product_Category AS pc
GROUP BY pc.Category1
ORDER BY pc.Category1 ASC;
INSERT INTO Categoria1 (ID_Categoria, nom)
VALUES (15, 'Slot Cars');


DROP TABLE IF EXISTS Categoria2 CASCADE; 
CREATE TABLE Categoria2(
	ID_Categoria2 SERIAL,
	nom2 VARCHAR(255),
	ID_Categoria INTEGER,
	
	PRIMARY KEY (ID_Categoria2), 
	FOREIGN KEY (ID_Categoria) REFERENCES Categoria1(ID_Categoria)
);   
INSERT INTO Categoria2 (nom2, ID_Categoria)
SELECT pc.Category2, c1.ID_Categoria
FROM Product_Category AS pc, Categoria1 AS c1
WHERE  c1.nom = pc.Category1
GROUP BY pc.Category2, c1.ID_Categoria
ORDER BY c1.ID_Categoria ASC;


DROP TABLE IF EXISTS Categoria3 CASCADE; 
CREATE TABLE Categoria3(
	ID_Categoria3 SERIAL,
	nom3 VARCHAR(255),
	ID_Categoria2 INTEGER,
	
	PRIMARY KEY (ID_Categoria3), 
	FOREIGN KEY (ID_Categoria2) REFERENCES Categoria2(ID_Categoria2)
);   
INSERT INTO Categoria3 (nom3, ID_Categoria2)
SELECT pc.Category3, c2.ID_Categoria2
FROM Product_Category AS pc, Categoria2 AS c2
WHERE  c2.nom2 = pc.Category2
GROUP BY pc.Category3, c2.ID_Categoria2
ORDER BY c2.ID_Categoria2 ASC;


DROP TABLE IF EXISTS Producte CASCADE;
CREATE TABLE Producte(
	codi SERIAL,
	nom VARCHAR(255),
	mida FLOAT4,
	pes FLOAT4,
	data_creacio DATE, 
	cost FLOAT4,
	ID_Fabrica INTEGER, 
	ID_Article INTEGER,
	ID_Categoria INTEGER,
	ID_Documentacio INTEGER, 
	
	PRIMARY KEY (codi),
	FOREIGN KEY (ID_Fabrica) REFERENCES Fabrica(ID_Fabrica),
	FOREIGN KEY (ID_Article) REFERENCES Article_aux(ID_Article),
	FOREIGN KEY (ID_Documentacio) REFERENCES Documentacio(ID_Documentacio),
	FOREIGN KEY (ID_Categoria) REFERENCES Categoria1(ID_Categoria)
);
COPY Producte FROM 'C:\Users\Public\Taules_bbdd1\producte.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Material CASCADE;
CREATE TABLE Material(
	ID_Material SERIAL,
	nom VARCHAR(255),
	cost FLOAT4,
	pes FLOAT4,
	quantitat FLOAT4,
	ID_Producte INTEGER,
	
	PRIMARY KEY (ID_Material),
	FOREIGN KEY (ID_Producte) REFERENCES Producte(codi)
); 
COPY Material FROM 'C:\Users\Public\Taules_bbdd1\material.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Composa CASCADE;
CREATE TABLE Composa(
	ID_Material1 INTEGER,
	ID_Material2 INTEGER,
	quantitat FLOAT4,
	
	PRIMARY KEY (ID_Material1), 
	FOREIGN KEY (ID_Material1) REFERENCES Material(ID_Material),
	FOREIGN KEY (ID_Material2) REFERENCES Material(ID_Material)
);
COPY Composa FROM 'C:\Users\Public\Taules_bbdd1\composa.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Instruccio CASCADE;
CREATE TABLE Instruccio(
	ID_Instruccio INTEGER,
	nombre_pagines INTEGER, 
	
	PRIMARY KEY (ID_Instruccio)
);
INSERT INTO Instruccio (ID_Instruccio, nombre_pagines)
SELECT ID, pages
FROM Product_Document
WHERE pages IS NOT NULL;


DROP TABLE IF EXISTS Imatge CASCADE;
CREATE TABLE Imatge(
	ID_Imatge INTEGER,
	resolucio VARCHAR(255), 
	
	PRIMARY KEY (ID_Imatge)
);
INSERT INTO Imatge (ID_Imatge, resolucio)
SELECT ID, resolution
FROM Product_Document
WHERE resolution IS NOT NULL;


DROP TABLE IF EXISTS Video CASCADE;
CREATE TABLE Video(
	ID_Video INTEGER,
	duracio INTEGER,  
	
	PRIMARY KEY (ID_Video)
);
INSERT INTO Video (ID_Video, duracio)
SELECT ID, duration
FROM Product_Document
WHERE duration IS NOT NULL;
--Informacio extra que afegim per millorar el funcionament de les queries
INSERT INTO Video(ID_Video, duracio)
VALUES (511, 28), (512, 30), (513, 26), (514, 36), (515, 28),
(521, 45), (517, 36), (518, 33), (519, 55), (520, 26);


DROP TABLE IF EXISTS Candidat CASCADE;
CREATE TABLE Candidat( 
	ID_Candidat INTEGER,
	curriculum TEXT,
	ID_OfertaFeina INTEGER,
	
	PRIMARY KEY (ID_Candidat),
	FOREIGN KEY (ID_OfertaFeina) REFERENCES OfertaFeina(ID_OfertaFeina)
);
COPY Candidat FROM 'C:\Users\Public\Taules_bbdd1\candidat.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Magatzem CASCADE;
CREATE TABLE Magatzem(
	ID_Magatzem SERIAL,
	nom VARCHAR(255), 
	superficice FLOAT4,
	ID_Fabrica INTEGER,
	ID_Localitzacio INTEGER, 
	
	PRIMARY KEY (ID_Magatzem), 
	FOREIGN KEY (ID_Fabrica) REFERENCES Fabrica(ID_Fabrica),
	FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
COPY Magatzem FROM 'C:\Users\Public\Taules_bbdd1\magatzem.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
--Informacio extra que afegim per millorar el funcionament de les queries
INSERT INTO Magatzem(ID_Magatzem, nom,superficice,ID_Fabrica,ID_Localitzacio)
VALUES (31,'pepe',10200.01,30,2030);


DROP TABLE IF EXISTS Habitacio CASCADE;
CREATE TABLE Habitacio(
	codi SERIAL,
	numero_estants INTEGER, 
	numero_contenidors INTEGER, 
	ID_Producte INTEGER, 
	ID_Magatzem INTEGER, 
	
	PRIMARY KEY (codi), 
	FOREIGN KEY (ID_Producte) REFERENCES Producte(codi),
	FOREIGN KEY (ID_Magatzem) REFERENCES Magatzem(ID_Magatzem)
);
COPY Habitacio FROM 'C:\Users\Public\Taules_bbdd1\habitacio.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Conductor CASCADE;
CREATE TABLE Conductor(
	ID_Conductor INTEGER,
	hores_conduccio FLOAT4,
	
	PRIMARY KEY (ID_Conductor)
);
INSERT INTO Conductor(ID_Conductor, hores_conduccio)
SELECT p.ID_Persona, vd.driving_hours
FROM Vehicles_Drivers AS vd, Persona AS p
WHERE vd.driving_hours IS NOT NULL
AND vd.first_name = p.nom
AND vd.last_name = p.cognom;


DROP TABLE IF EXISTS Operador_aux CASCADE;
CREATE TABLE Operador_aux(
	ID_Operador INTEGER,
	ID_Magatzem INTEGER
);
COPY Operador_aux FROM 'C:\Users\Public\Taules_bbdd1\operador.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Operador CASCADE;
CREATE TABLE Operador(
	ID_Operador INTEGER,
	comandes_enviades INTEGER, 
	ID_Magatzem INTEGER, 
	
	PRIMARY KEY (ID_Operador),
	FOREIGN KEY (ID_Magatzem) REFERENCES Magatzem(ID_Magatzem)
);
INSERT INTO Operador(ID_Operador, comandes_enviades, ID_Magatzem)
SELECT p.ID_Persona, vd.orders, oa.ID_Magatzem
FROM Vehicles_Drivers AS vd, Persona AS p, Operador_aux AS oa
WHERE vd.driving_hours IS NULL
AND vd.first_name = p.nom
AND vd.last_name = p.cognom
AND p.ID_Persona = oa.ID_Operador;


DROP TABLE IF EXISTS Vehicle_aux CASCADE;
CREATE TABLE Vehicle_aux(
	ID_Vehicle SERIAL,
	ID_Magatzem INTEGER, 
	ID_Localitzacio INTEGER
);
COPY Vehicle_aux FROM 'C:\Users\Public\Taules_bbdd1\vehicle_aux.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Vehicle2 CASCADE;
CREATE TABLE Vehicle2(
	ID_Vehicle SERIAL,
	model VARCHAR(255), 
	estat VARCHAR(255),
	capacitat_carrega FLOAT4,
	ID_Magatzem INTEGER, 
	ID_Conductor INTEGER,
	ID_Localitzacio INTEGER
);
INSERT INTO Vehicle2 (model, estat, capacitat_carrega, ID_Conductor)
SELECT vd.model_status, vd.status, vd.cargo, p.ID_Persona
FROM Vehicles_Drivers AS vd, Persona AS p
WHERE p.nom = vd.first_name 
AND p.cognom = vd.last_name
AND vd.model_status IS NOT NULL;


DROP TABLE IF EXISTS Vehicle CASCADE;
CREATE TABLE Vehicle(
	ID_Vehicle SERIAL,
	model VARCHAR(255), 
	estat VARCHAR(255),
	capacitat_carrega FLOAT4,
	ID_Magatzem INTEGER, 
	ID_Conductor INTEGER,
	ID_Localitzacio INTEGER,  
	
	PRIMARY KEY (ID_Vehicle),
	FOREIGN KEY (ID_Magatzem) REFERENCES Magatzem(ID_Magatzem),
	FOREIGN KEY (ID_Conductor) REFERENCES Conductor(ID_Conductor),
	FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
INSERT INTO Vehicle (model, estat, capacitat_carrega, ID_Magatzem, ID_Conductor, ID_Localitzacio)
SELECT v2.model, v2.estat, v2.capacitat_carrega, va.ID_Magatzem, v2.ID_Conductor, va.ID_Localitzacio
FROM Vehicle2 AS v2, Vehicle_aux AS va 
WHERE va.ID_Vehicle = v2.ID_Vehicle;


DROP TABLE IF EXISTS Seguiment CASCADE;
CREATE TABLE Seguiment(
	ID_Conductor INTEGER,
	ID_Vehicle INTEGER,
	ID_Localitzacio INTEGER,
	durada INTEGER,
	
	PRIMARY KEY (ID_Conductor,ID_Vehicle,ID_Localitzacio),
	FOREIGN KEY (ID_Conductor) REFERENCES Conductor(ID_Conductor),
	FOREIGN KEY (ID_Vehicle) REFERENCES Vehicle(ID_Vehicle),
	FOREIGN KEY (ID_Localitzacio) REFERENCES Localitzacio(ID_Localitzacio)
);
COPY Seguiment FROM 'C:\Users\Public\Taules_bbdd1\seguiment.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
COPY Seguiment FROM 'C:\Users\Public\Taules_bbdd1\seguiment2.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Patinet CASCADE;
CREATE TABLE Patinet(
	ID_Patinet INTEGER,
	capacitat_bateria INTEGER,
	
	PRIMARY KEY (ID_Patinet)
);
INSERT INTO Patinet (ID_Patinet, capacitat_bateria)
SELECT v.ID_Vehicle, vd.battery
FROM Vehicle AS v, Vehicles_Drivers AS vd
WHERE v.model = vd.model_status
AND v.estat = vd.status
AND v.capacitat_carrega = vd.cargo
AND vd.battery IS NOT NULL
AND vd.model_status IS NOT NULL;



DROP TABLE IF EXISTS Camio CASCADE;
CREATE TABLE Camio(
	ID_Camio INTEGER,
	matricula VARCHAR(255),
	potencia_motor INTEGER,
	
	PRIMARY KEY (ID_Camio)
);
INSERT INTO Camio (ID_Camio, matricula, potencia_motor)
SELECT v.ID_Vehicle, vd.license_plate, vd.engine_power
FROM Vehicle AS v, Vehicles_Drivers AS vd
WHERE v.model = vd.model_status
AND v.estat = vd.status
AND v.capacitat_carrega = vd.cargo
AND vd.engine_power IS NOT NULL
AND vd.model_status IS NOT NULL;


DROP TABLE IF EXISTS Manteniment CASCADE;
CREATE TABLE Manteniment(
	ID_Manteniment INTEGER,
	ID_Vehicle INTEGER,
	descripcio TEXT,
	any_manteniment INTEGER,
	
	PRIMARY KEY (ID_Manteniment),
	FOREIGN KEY (ID_Vehicle) REFERENCES Vehicle(ID_Vehicle)
);
COPY Manteniment FROM 'C:\Users\Public\Taules_bbdd1\manteniment.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Reporta CASCADE;
CREATE TABLE Reporta(
	ID_Empleat1 INTEGER,
	ID_Empleat2 INTEGER,
	
	PRIMARY KEY (ID_Empleat1, ID_Empleat2),
	FOREIGN KEY (ID_Empleat1) REFERENCES Empleat(ID_Empleat),
	FOREIGN KEY (ID_Empleat2) REFERENCES Empleat(ID_Empleat)
);
COPY Reporta FROM 'C:\Users\Public\Taules_bbdd1\reporta.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Telefon_aux CASCADE;
CREATE TABLE Telefon_aux(
	ID_Telefon INTEGER,
	tipus VARCHAR(255)
);
COPY Telefon_aux FROM 'C:\Users\Public\Taules_bbdd1\telefon.csv' DELIMITER ',' QUOTE '"' CSV HEADER;

--Telefons dels empleats, treballadors + venedors
DROP TABLE IF EXISTS Telefon_tv CASCADE;
CREATE TABLE Telefon_tv(
	ID_Telefon INTEGER,
	numero VARCHAR(255),
	tipus VARCHAR(255)
);
COPY Telefon_tv FROM 'C:\Users\Public\Taules_bbdd1\telefon2.csv' DELIMITER ',' QUOTE '"' CSV HEADER;


DROP TABLE IF EXISTS Telefon2 CASCADE;
CREATE TABLE Telefon2(
	ID_Telefon SERIAL,
	numero VARCHAR(255)
);
INSERT INTO Telefon2 (numero)
SELECT phone
FROM Vehicles_Drivers
WHERE driving_hours IS NOT NULL;
INSERT INTO Telefon2 (numero)
SELECT phone
FROM Vehicles_Drivers
WHERE driving_hours IS  NULL;


DROP TABLE IF EXISTS Telefon CASCADE;
CREATE TABLE Telefon(
	ID_Telefon SERIAL,
	numero VARCHAR(255),
	tipus VARCHAR(255),
	
	PRIMARY KEY (ID_Telefon)
);
INSERT INTO Telefon (numero, tipus)
SELECT t2.numero, ta.tipus
FROM Telefon2 AS t2, Telefon_aux AS ta
WHERE ta.ID_Telefon = t2.ID_Telefon;
INSERT INTO Telefon (numero, tipus)
SELECT numero, tipus
FROM Telefon_tv; 


DROP TABLE IF EXISTS Disposa CASCADE; 
CREATE TABLE Disposa(
	ID_Empleat INTEGER,
	ID_Telefon INTEGER,
	
	PRIMARY KEY (ID_Empleat, ID_Telefon),
	FOREIGN KEY (ID_Empleat) REFERENCES Empleat(ID_Empleat),
	FOREIGN KEY (ID_Telefon) REFERENCES Telefon(ID_Telefon)
);
COPY Disposa FROM 'C:\Users\Public\Taules_bbdd1\disposa.csv' DELIMITER ',' QUOTE '"' CSV HEADER;
COPY Disposa FROM 'C:\Users\Public\Taules_bbdd1\disposa2.csv' DELIMITER ',' QUOTE '"' CSV HEADER;