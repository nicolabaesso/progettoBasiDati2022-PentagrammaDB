/*Creazione Tabelle*/

CREATE TABLE "Persona" (
    "CF" CHAR(16) NOT NULL PRIMARY KEY,
    "Nome" VARCHAR(30) NOT NULL,
    "Cognome" VARCHAR(30) NOT NULL,
    "DataNascita" date NOT NULL,
    "Telefono" CHAR(10) NOT NULL,
    "Email" VARCHAR(50) NOT NULL
);

CREATE TABLE "Audizione" (
    "DataAudizione" date NOT NULL PRIMARY KEY
);

CREATE TABLE "Brano" (
    "NomeBrano" VARCHAR(50) NOT NULL,
    "Artista" VARCHAR(50) NOT NULL,
    "GenereBrano" VARCHAR(20) NOT NULL,
	PRIMARY KEY ("NomeBrano", "Artista")
);

CREATE TABLE "Corso" (
    "NomeCorso" VARCHAR(30) NOT NULL PRIMARY KEY,
    "DurataLezione" integer NOT NULL,
    "LezioneMese" integer NOT NULL,
    "TipologiaCorso" CHAR(1) NOT NULL,
    "Descrizione" VARCHAR(50),
	CONSTRAINT "Corso_check" CHECK (((("TipologiaCorso" = 'I') AND ("Descrizione" IS NULL)) OR (("TipologiaCorso" = 'C') AND ("Descrizione" IS NOT NULL)))),
	CONSTRAINT "Corso_DurataLezione_check" CHECK ("DurataLezione" >= 30 AND "DurataLezione" <= 60),
	CONSTRAINT "Corso_DurataLezione_check" CHECK ("DurataLezione" >= 30 AND "DurataLezione" <= 60)
);

CREATE TABLE "Esame" (
    "LivelloAbilitazione" CHAR(1) NOT NULL,
    "DataEsame" date NOT NULL,
	PRIMARY KEY ("LivelloAbilitazione", "DataEsame")
);

CREATE TABLE "Sede" (
    "NomeSede" VARCHAR(50) NOT NULL PRIMARY KEY,
    "Utilizzo" CHAR(1) NOT NULL,
    "MaxPosti" integer,
    "Indirizzo" VARCHAR(50) NOT NULL,
    "Citta" VARCHAR(30) NOT NULL,
	CONSTRAINT "Sede_check" CHECK (((("Utilizzo" = 'L') AND ("MaxPosti" IS NULL)) OR (("Utilizzo" = 'E') AND ("MaxPosti" IS NOT NULL))))
);

CREATE TABLE "Associato" (
    "CodiceTessera" CHAR(10) NOT NULL PRIMARY KEY,
    "CF" CHAR(16) NOT NULL REFERENCES "Persona"("CF"),
    "DataIscrizione" date NOT NULL,
    "DataScadenza" date NOT NULL,
	UNIQUE ("CodiceTessera", "CF"),
    CONSTRAINT "Associato_check" CHECK (("DataScadenza" > "DataIscrizione"))
);

CREATE TABLE "Docente" (
    "CF" CHAR(16) NOT NULL PRIMARY KEY REFERENCES "Persona"("CF"),
    "Diploma" VARCHAR(30) NOT NULL,
    "DataDiploma" date NOT NULL,
    "InizioDocenza" date NOT NULL,
    "FineDocenza" date,
    "RuoloDirigente" VARCHAR(30),
    "InizioDirigenza" date,
    "FineDirigenza" date,
    CONSTRAINT "Docente_check" CHECK ((("FineDocenza" IS NULL) OR ("FineDocenza" > "InizioDocenza"))),
    CONSTRAINT "Docente_check1" CHECK (((("RuoloDirigente" IS NULL) AND ("InizioDirigenza" IS NULL) AND ("FineDirigenza" IS NULL)) OR (("RuoloDirigente" IS NOT NULL) AND ("InizioDirigenza" IS NOT NULL) AND ("FineDirigenza" IS NULL)) OR (("RuoloDirigente" IS NOT NULL) AND ("InizioDirigenza" IS NOT NULL) AND ("FineDirigenza" IS NOT NULL) AND ("FineDirigenza" > "InizioDirigenza"))))
);

CREATE TABLE "Studente" (
    "Tipologia" CHAR(1) NOT NULL,
    "Livello" CHAR(2),
    "InizioLezioni" date NOT NULL,
    "FineLezioni" date,
    "CF" CHAR(16) NOT NULL PRIMARY KEY REFERENCES "Persona"("CF")
	CONSTRAINT "Studente_check" CHECK ((("FineLezioni" IS NULL) OR ("FineLezioni" > "InizioLezioni")))
);

CREATE TABLE "Attivita" (
    "CodiceAttivita" CHAR(8) NOT NULL PRIMARY KEY,
    "NumStudenti" integer NOT NULL,
    "InizioAttivita" date NOT NULL,
    "FineAttivita" date,
    "Docente" CHAR(16) NOT NULL REFERENCES "Docente"("CF"),
    "Sede" VARCHAR(50) NOT NULL REFERENCES "Sede"("NomeSede"),
    "Corso" VARCHAR(30) NOT NULL REFERENCES "Corso"("NomeCorso"),
	UNIQUE ("InizioAttivita", "Docente", "Sede", "Corso"),
    CONSTRAINT "Attivita_check" CHECK ((("FineAttivita" IS NULL) OR ("FineAttivita" > "InizioAttivita")))
);

CREATE TABLE "Evento" (
    "NomeEvento" VARCHAR(50) NOT NULL PRIMARY KEY,
    "NumSpettatori" integer NOT NULL,
    "GenereEvento" VARCHAR(20) NOT NULL,
    "Organizzatore" VARCHAR(50),
    "CoOrganizzatore" VARCHAR(50),
    "TipoEvento" CHAR(1) NOT NULL,
    "LuogoEvento" VARCHAR(50) NOT NULL REFERENCES "Sede"("NomeSede")
	CONSTRAINT "Evento_check" CHECK (((("TipoEvento" = 'S'::bpchar) AND ("Organizzatore" IS NULL) AND ("CoOrganizzatore" IS NULL)) OR (("TipoEvento" = 'N'::bpchar) AND ((("Organizzatore" IS NOT NULL) AND ("CoOrganizzatore" IS NULL)) OR (("Organizzatore" IS NULL) AND ("CoOrganizzatore" IS NOT NULL))))))
);

CREATE TABLE "Accertamento" (
    "CF" CHAR(16) NOT NULL REFERENCES "Studente"("CF"),
    "DataAudizione" date NOT NULL REFERENCES "Audizione"("DataAudizione"),
	PRIMARY KEY ("CF", "DataAudizione")
);

CREATE TABLE "Apprendimento" (
    "CF" CHAR(16) NOT NULL REFERENCES "Studente"("CF"),
    "CodiceAttivita" CHAR(8) NOT NULL REFERENCES "Attivita"("CodiceAttivita"),
	PRIMARY KEY ("CF", "CodiceAttivita")
);

CREATE TABLE "Auditore" (
    "CF" CHAR(16) NOT NULL REFERENCES "Docente"("CF"),
    "DataAudizione" date NOT NULL REFERENCES "Audizione"("DataAudizione"),
	PRIMARY KEY ("CF", "DataAudizione")
);

CREATE TABLE "Scaletta" (
    "NomeEvento" VARCHAR(50) NOT NULL PRIMARY KEY REFERENCES "Evento"("NomeEvento")
);

CREATE TABLE "BranoEseguito" (
    "NomeBrano" VARCHAR(50) NOT NULL,
    "Artista" VARCHAR(50) NOT NULL,
    "NomeEvento" VARCHAR(50) NOT NULL REFERENCES "Scaletta"("NomeEvento"),
	PRIMARY KEY ("NomeBrano", "Artista", "NomeEvento"),
	FOREIGN KEY ("NomeBrano", "Artista") REFERENCES "Brano"("NomeBrano", "Artista")
);

CREATE TABLE "Esaminato" (
    "LivelloAbilitazione" CHAR(1) NOT NULL,
    "DataEsame" date NOT NULL,
    "CF" CHAR(16) NOT NULL REFERENCES "Persona"("CF"),
    "EsitoEsame" VARCHAR(11) NOT NULL,
	PRIMARY KEY ("LivelloAbilitazione", "DataEsame", "CF"),
	FOREIGN KEY ("LivelloAbilitazione", "DataEsame") REFERENCES "Esame"("LivelloAbilitazione", "DataEsame")
);

CREATE TABLE "Esaminatore" (
    "LivelloAbilitazione" CHAR(2) NOT NULL,
    "DataEsame" date NOT NULL,
    "CF" CHAR(16) NOT NULL REFERENCES "Docente"("CF"),
	PRIMARY KEY ("LivelloAbilitazione", "DataEsame", "CF"),
	FOREIGN KEY ("LivelloAbilitazione", "DataEsame") REFERENCES "Esame"("LivelloAbilitazione", "DataEsame")
);

CREATE TABLE "Performance" (
    "CF" CHAR(16) NOT NULL REFERENCES "Studente"("CF"),
    "NomeEvento" VARCHAR(50) NOT NULL REFERENCES "Scaletta"("NomeEvento"),
	PRIMARY KEY ("CF", "NomeEvento")
);

/*Indice sulla tabella Attivita*/

CREATE INDEX idx_attivita ON "Attivita" ("CodiceAttivita");

/*Inserimento dati nelle tabelle*/

INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SQWCVL07T14V013T', 'Quintessa', 'Jefferson', '2021-12-21', '1713295313', 'mauris@protonmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('KSJOTZ22E55Z770Y', 'Yoshio', 'Black', '2021-09-18', '8041912352', 'pede.cum.sociis@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('YRBFTO41P85S678F', 'Fatima', 'Stokes', '2022-03-15', '8171547896', 'eget@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('UEUSUN66I53C192Y', 'Chloe', 'Hunter', '2023-05-10', '5172934099', 'curabitur.egestas@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('CDXHLP66S72T962M', 'Holmes', 'Gardner', '2022-07-05', '8167324007', 'phasellus.fermentum.convallis@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('ZKEBBV68M41P924B', 'Lareina', 'Hartman', '2021-10-28', '5577982220', 'mus.proin@google.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('DVXLFG07O61R666O', 'Marny', 'Black', '2021-06-03', '1367375340', 'erat.nonummy.ultricies@google.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MEXUFF57E16C414G', 'Oren', 'Patterson', '2022-01-11', '7233541969', 'lectus@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('GBIXCO20E73A405E', 'Cherokee', 'Lucas', '2021-08-01', '9821381005', 'ridiculus.mus@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('RDJYBT19V65S364C', 'Fitzgerald', 'Mullen', '2022-01-30', '2143202742', 'mauris@libero.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('LFATQY34B29C170Y', 'Yeo', 'Griffith', '2022-09-28', '2738084303', 'commodo.tincidunt.nibh@google.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('LWRFZT87S35G953O', 'Gail', 'Garrison', '2022-03-21', '9568717462', 'eleifend.cras@icloud.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('UYMPWJ88P45W842F', 'Abbot', 'Ellison', '2022-01-14', '0447713906', 'ac.eleifend@aol.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('JOONGA31I75X737Q', 'Indigo', 'Harmon', '2023-01-17', '2760155869', 'malesuada@yahoo.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('BYQFWE28C16F466C', 'Alan', 'Dixon', '2022-08-20', '4912181147', 'duis@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IDRDCQ31G91P469H', 'Deacon', 'Ochoa', '2022-12-11', '5613532675', 'molestie.pharetra.nibh@google.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('CESWJE46T33D767Q', 'Shoshana', 'Garner', '2022-10-20', '1165217146', 'tristique.ac@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('UCFDGH22G61N948K', 'Paul', 'Henderson', '2022-05-13', '2871318301', 'augue.malesuada.malesuada@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('PTHXGM86E71W750V', 'Theodore', 'Barnett', '2022-04-06', '1527015606', 'id.blandit@aol.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MQQGPV25I85R152S', 'Sybill', 'Long', '2021-08-10', '2373295972', 'risus.nulla@aol.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('HDDFHK71Z27A648F', 'Amy', 'Cain', '2021-07-20', '4937094914', 'sem.magna@google.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('JFMEUH39V34V843K', 'Eric', 'Alford', '2023-01-10', '2785225846', 'egestas.urna.justo@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('HFIHEX12V34T688W', 'Robert', 'Castillo', '2023-03-08', '7447506571', 'lobortis@protonmail.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('HWVJKZ61K74G315T', 'Hiram', 'Mclean', '2023-01-04', '4565548483', 'tellus.imperdiet@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SVHVQQ77L61D434S', 'Uma', 'Murray', '2023-03-23', '2127708507', 'urna.suscipit@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('OGPXSH73C15J342A', 'Blake', 'Guzman', '2022-04-01', '4768161625', 'sed.id.risus@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MJNREV05A23R161N', 'Chancellor', 'Ford', '2022-05-23', '2523120785', 'arcu.nunc.mauris@yahoo.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('VYEIVZ54P38V871R', 'Fredericka', 'Downs', '2022-12-17', '6400256268', 'mauris.morbi.non@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('NGEULH83R26J728S', 'James', 'Reyes', '2021-10-23', '6447697755', 'phasellus@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('EFYOGD45J16Y252B', 'Octavius', 'Marsh', '2023-04-12', '0837541356', 'mi.ac@protonmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('VRFFGV31L63E843P', 'April', 'Espinoza', '2022-01-14', '6296191752', 'lorem.ipsum.dolor@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('XKTTFI58M92M284S', 'Reagan', 'Harrison', '2022-02-13', '1713696284', 'purus.gravida.sagittis@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('EUJTRX37S17Y602A', 'Brenna', 'Maxwell', '2021-05-29', '1602250650', 'erat.semper.rutrum@protonmail.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('WWTPPZ11R39H944P', 'Raymond', 'Langley', '2021-08-25', '1475573246', 'tincidunt.adipiscing@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('AZRGHS52C64P642V', 'Elijah', 'Harris', '2022-07-29', '2108226363', 'turpis@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('DXUNUA13F55I864L', 'Leonard', 'Martinez', '2022-04-21', '3514169053', 'ac.tellus.suspendisse@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('QCRNST98Y09K858Z', 'Elizabeth', 'Parks', '2021-08-25', '6151410482', 'sit.amet.lorem@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('HFXMNP35V71O311K', 'Sandra', 'Richard', '2023-05-21', '6670691966', 'semper.erat@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('CBDYML46Q74A636H', 'Maisie', 'Trevino', '2021-10-09', '1145122466', 'ligula@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('UBTYHM31R62E579M', 'Whilemina', 'Hicks', '2022-09-01', '5771329864', 'pellentesque.habitant@libero.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('PFHVRW81I66S118S', 'Imani', 'Mccullough', '2022-11-29', '1917212721', 'penatibus@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('UOHJMW72M41J243Q', 'Macy', 'Travis', '2023-04-16', '4416353727', 'vitae.sodales@icloud.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('BLMXHC76Q17T504S', 'Philip', 'Andrews', '2021-09-20', '0552116138', 'non.massa.non@icloud.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('CYDWAP23O44T538Y', 'Raphael', 'Parsons', '2021-12-14', '3485511577', 'suspendisse.non@outlook.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IQSZGI53B17E439K', 'Solomon', 'Martin', '2023-01-13', '6529278876', 'elit.elit@aol.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('TVGSGV81C69V784X', 'Craig', 'Gordon', '2022-02-08', '3428418606', 'vehicula@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SYJYSC68M75Q154P', 'Sara', 'Keith', '2021-10-08', '5581533976', 'velit.in@google.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('AHTQSX86Q75B864J', 'Phillip', 'Whitaker', '2023-03-29', '7031701318', 'etiam.laoreet.libero@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('HHJTAN11N26X862N', 'Rigel', 'Mooney', '2023-02-06', '9186262027', 'aliquet.diam@icloud.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('BVJVGJ81B52Y715S', 'Willa', 'Swanson', '2022-03-26', '6832372795', 'dictum.eleifend@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('WJETHR04J33X328H', 'Duncan', 'Valenzuela', '2022-01-20', '8538502330', 'vitae.dolor.donec@protonmail.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('ERBBCC81Q11K820Y', 'Germaine', 'Carson', '2021-11-20', '3063147350', 'nec.diam@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('XWXFMB00W65G682J', 'Buffy', 'Randall', '2023-02-23', '5117524111', 'sit.amet@google.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SDEEEO37M83K240Y', 'Sandra', 'Montgomery', '2023-02-26', '1296534458', 'penatibus.et@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('BXKHDO80E47M264X', 'John', 'Long', '2023-02-10', '2236213175', 'sapien.nunc.pulvinar@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('QGIXCF45I14K948U', 'Katelyn', 'Flynn', '2021-05-27', '7998196552', 'hendrerit@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('LCGRFF76G12E418W', 'Ainsley', 'Shields', '2021-10-25', '5611951645', 'sed.sapien@libero.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('NOVCKE56V97C602C', 'Quin', 'Bentley', '2022-12-10', '9306516847', 'erat@google.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IIBLWY36L35K836O', 'Jayme', 'Green', '2022-03-23', '5763880664', 'cursus.in.hendrerit@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('DQJJJQ44I65U319U', 'Cadman', 'Nielsen', '2022-12-06', '9745223655', 'massa@libero.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('EVHRMW73X28M255V', 'Lucas', 'O''Neill', '2022-11-22', '1318382355', 'nam.nulla.magna@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('TSLSRT99J91V270U', 'Charde', 'Stokes', '2022-10-28', '1896417986', 'mauris.sit@aol.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('EDUSOG33U56A146K', 'Dennis', 'Jefferson', '2022-12-24', '8042761863', 'sed.eu.nibh@google.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('LZIBHA24J15M733T', 'Simon', 'Cortez', '2021-10-28', '9697928861', 'vestibulum.ut@google.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('GLZEHC97H14V618E', 'Anika', 'Britt', '2022-06-13', '5821526610', 'et.malesuada@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('THASCT53S30H780X', 'Ciaran', 'Reynolds', '2021-10-29', '3979564655', 'eu.ultrices.sit@protonmail.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IOUZEK14E32T271X', 'Alisa', 'Clemons', '2021-07-03', '5675330571', 'nisl.elementum@google.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('JJIDXZ82K11V751E', 'Harrison', 'Schultz', '2022-07-20', '5923331963', 'semper@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('JQKKFP25Z66Q557R', 'Maris', 'Barnett', '2022-06-21', '4583661977', 'duis.elementum.dui@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SMKVVJ16L78W242F', 'Rashad', 'Nguyen', '2022-04-24', '0763606168', 'sed@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('TBTJIS52D11B709Y', 'Lucian', 'Crawford', '2022-12-14', '8312950675', 'suscipit.nonummy@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('FUYFLS79G63E301D', 'Fritz', 'Garza', '2021-12-03', '5386555540', 'libero@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IBQKVK86W87D848U', 'Knox', 'Scott', '2023-01-14', '6516740243', 'libero.nec@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SQXEPD47T76M463I', 'Joel', 'Dyer', '2023-01-15', '8524283146', 'leo.morbi.neque@google.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('YPNUQM26K92E237V', 'Tanek', 'Bullock', '2021-12-30', '3381576725', 'gravida.sit@libero.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MSGNDE33S24U351S', 'Heidi', 'Frederick', '2021-08-24', '6901437155', 'cursus@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('DWLDFO01X92Z705A', 'Colt', 'Levine', '2023-04-18', '6231981930', 'mauris@google.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IJIRFM17Y95P446R', 'Hamish', 'Taylor', '2022-11-21', '7811168446', 'id@protonmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MBYHEK71G35Q361S', 'Bell', 'Doyle', '2022-03-06', '8342245411', 'quis@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('OTHGKP43W99W988Q', 'Cedric', 'Evans', '2022-09-18', '2607811012', 'eget.massa@aol.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('QMVSDT18D14G833G', 'Neil', 'Levine', '2021-10-30', '2336529544', 'ornare@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MUJHBC56X73I174P', 'Reuben', 'Acosta', '2021-06-05', '2164844482', 'dis.parturient.montes@hotmail.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('LRUUCW52S71R304Q', 'Avye', 'Benton', '2021-09-15', '8104145823', 'torquent.per.conubia@libero.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MISHYR40P59Z356X', 'Vance', 'Mooney', '2022-07-25', '5163896144', 'suscipit.nonummy.fusce@protonmail.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SDWWQB03W01B295P', 'Geraldine', 'Herrera', '2022-02-17', '0661677022', 'lectus.cum.sociis@icloud.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('YQVPIG87Z65E231C', 'Hall', 'Hogan', '2022-08-08', '0169237280', 'nec@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('YTHWYE15J67J855V', 'Evan', 'Richards', '2022-01-22', '3949123232', 'non.sapien@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('UJDKJD73R77A614S', 'Emmanuel', 'Gutierrez', '2022-12-27', '6853316217', 'id.ante.dictum@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('YBIRSE92S82M623N', 'Tana', 'Patton', '2023-04-26', '0955748813', 'mollis.integer.tincidunt@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('VZIDWM21Q41D666Y', 'Jesse', 'Trevino', '2021-07-17', '0551551371', 'erat.vitae@aol.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('NVTXIG33R44F011C', 'Dahlia', 'Morales', '2022-08-18', '0361581454', 'ut@yahoo.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('ELQTXB74U12F637J', 'Amos', 'Diaz', '2022-12-17', '6897225675', 'orci@aol.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('GOCVFD29E33F513L', 'Alfonso', 'Riggs', '2021-09-05', '6054121562', 'mus.proin@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('FPMPDH66T38W789G', 'Sylvia', 'Mckenzie', '2023-03-24', '7223773823', 'bibendum@libero.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('GWUFUH47T25O260F', 'Kamal', 'Brock', '2022-05-26', '8816344631', 'dui.suspendisse@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('DMNBAW24F85J541W', 'Oren', 'Wagner', '2021-08-12', '4847648432', 'suspendisse.tristique@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('QZAEHY93O81I207G', 'Keith', 'Montoya', '2022-05-11', '6537645811', 'libero.dui@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('KFLCEC47R11P638I', 'Sebastian', 'Small', '2023-02-02', '7176358120', 'et.risus@outlook.org');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('YNEXRS35V84C113V', 'Geoffrey', 'Oliver', '2022-02-18', '4835592985', 'nisi@yahoo.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('BFLOIK20B57C278N', 'Wing', 'Bray', '2022-03-29', '9826280768', 'donec@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('CTBECF63I11B333T', 'Adara', 'Leblanc', '1974-07-31', '7223613529', 'adara-leblanc@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('YJYLZS66P77T641E', 'Keane', 'Kennedy', '1996-04-19', '4816610536', 'kennedy-keane5402@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('XVHXZE81H86U647H', 'Summer', 'Workman', '1989-12-07', '8690288779', 's-workman9725@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('FLQMSL06X75D245E', 'Wing', 'Henson', '1995-09-08', '4785738715', 'henson.wing1174@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('TYOPWT25N36K731N', 'Mona', 'Tyler', '2009-08-27', '7611582761', 'm-tyler@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('OIBPBN38G17K415C', 'Raven', 'Noble', '1993-04-05', '1251140197', 'noble.raven@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('LQAFOY65M45Q044R', 'Moses', 'Wilkerson', '1971-05-23', '3281856226', 'm-wilkerson873@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('GPNUJN67U68Q907V', 'Althea', 'Fowler', '2006-02-16', '6701765397', 'afowler@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('FEIEQP79H80T785O', 'Eaton', 'Tyson', '1995-09-07', '7758580774', 'tysoneaton1922@libero.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('LBSAFQ59M54B342J', 'Quinn', 'Horton', '2000-07-28', '3351595819', 'h.quinn2644@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IXUPNM20S13E584E', 'Macy', 'Walton', '1973-08-29', '1724877672', 'w_macy@google.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('XMYJAO70L78I240L', 'Phelan', 'Kelly', '1986-02-11', '4764027232', 'k.phelan@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('CNWYWL75H80E135T', 'Nicholas', 'Sparks', '1999-07-15', '0334469829', 'sparksnicholas5080@yahoo.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('NXAAOM07U43G754G', 'Jarrod', 'Case', '1978-10-25', '9465460891', 'c_jarrod@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IPVUDC98Q18L777K', 'Stephen', 'Savage', '1965-11-26', '4047642758', 's-savage2829@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('VPPMBC83L68W079L', 'Kenneth', 'Nieves', '1998-08-09', '9182671131', 'kennethnieves@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('YMYRAB54Q38R753B', 'Harper', 'Russell', '1976-07-29', '8650671118', 'russell-harper@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('XOBDPE63B34F268F', 'Jael', 'Tyson', '1996-04-02', '7321270749', 'jtyson@google.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('RCRMUY42B31E767A', 'Nero', 'Branch', '2013-06-14', '5932111860', 'b.nero@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IPNTHV11G47V858U', 'Leo', 'William', '2012-04-06', '6663752526', 'wleo@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('FCJFSE25C20V588J', 'Caldwell', 'Olson', '1995-07-28', '3616863594', 'ocaldwell2665@google.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('HKQOAW86G33S636B', 'Calista', 'Hampton', '2003-11-04', '3252158163', 'hampton_calista4134@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('OQPTLN96H08F286C', 'Harrison', 'Morrow', '2002-01-23', '2413443834', 'mharrison1276@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SAIXSL90V15U140S', 'Ava', 'Brewer', '1959-08-02', '5164163213', 'abrewer@yahoo.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IDDUFF42T85D961U', 'Knox', 'French', '2006-11-12', '7079861750', 'f_knox4301@yahoo.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('NPFWHQ71D02T713X', 'Hedley', 'Galloway', '1987-03-09', '1641086537', 'hedley_galloway@yahoo.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('DOUFSP75R38S925N', 'Daquan', 'Greene', '1963-10-02', '0927559137', 'd.greene@protonmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('QPLPAF20D54X648B', 'Roth', 'Moody', '1976-04-20', '9619893329', 'r.moody3753@icloud.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MRBLOO63U46J782N', 'Axel', 'Leon', '2001-03-28', '8654477784', 'leon-axel@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('BFUOJJ74G33V675S', 'Duncan', 'Hatfield', '1987-08-31', '8530818018', 'hatfield.duncan7279@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('UHEPKR56Y58E429C', 'Chadwick', 'Pugh', '1995-03-30', '2686801451', 'cpugh7549@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('PUJONZ68E31M317V', 'Carol', 'Schwartz', '2000-04-13', '2081793748', 'schwartzcarol@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('HXJMYS16G06V188Y', 'Kevyn', 'Best', '2005-11-07', '5726437518', 'bestkevyn2341@protonmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('GDGRFK66Y46U571X', 'Zia', 'Rios', '1965-08-10', '5436037527', 'zia.rios@libero.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('ZBFDBC65F93R481R', 'Irma', 'Livingston', '1998-10-05', '4584910298', 'livingstonirma4695@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('XBSYNY72X10T737S', 'Odessa', 'Cox', '1960-12-24', '8309439418', 'odessacox@icloud.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('JIQVBG65G55T820V', 'Devin', 'Hoover', '2013-08-17', '0378671213', 'hoover.devin@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MEFTIL72I80B815O', 'Hector', 'Daniels', '1972-03-28', '9037381037', 'daniels.hector7784@protonmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('NOVGBK38B22S594F', 'Alexis', 'Cameron', '1969-01-31', '7568288389', 'cameron_alexis8040@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('JQZLGJ38L89E153E', 'Fallon', 'Shields', '1958-01-12', '1218585146', 'f_shields@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('ESFXMJ79J19G686J', 'Julie', 'Walsh', '2013-08-25', '3536033556', 'j-walsh8132@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('PYDSWN72D37Y970M', 'Germaine', 'Gallegos', '1968-12-11', '9800611301', 'gallegosgermaine@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('STTWCL63T08O236O', 'Graham', 'Schroeder', '1974-10-14', '0268271727', 'grahamschroeder@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('NOOBLE34P45I612L', 'Keegan', 'Bailey', '1989-12-08', '6819332613', 'kbailey9804@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('OMAXAQ88H36X867Q', 'Kareem', 'Ford', '1985-01-30', '3642544127', 'f_kareem5039@google.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('NWYQYS34J81B675X', 'Brendan', 'Kennedy', '1976-03-05', '5431042326', 'bkennedy@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('RURIQS68S32B466W', 'Veda', 'Burch', '1957-05-26', '0431614332', 'burch_veda@protonmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('RQTDXX19H37X370X', 'James', 'Osborne', '2010-05-10', '6578814929', 'j_osborne@icloud.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('JQDBHY47L85N710L', 'Chelsea', 'Galloway', '1998-11-12', '4835540996', 'c.galloway9706@google.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('FUJYSO02X60D552V', 'Ferdinand', 'Peck', '1997-08-18', '5329638379', 'pferdinand1646@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('VDMWBH73M53Y714Y', 'Evelyn', 'Stafford', '1978-09-27', '8319070839', 'e_stafford713@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IOFOZZ50U82T741E', 'Vance', 'Benjamin', '1986-12-01', '6324596463', 'v_benjamin@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('HTMKIY72V46R455E', 'Nayda', 'Elliott', '1980-10-19', '8928428544', 'elliott.nayda@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('BROBEA95I13N812L', 'Vernon', 'Fernandez', '1986-10-01', '5237753176', 'vfernandez8980@yahoo.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('LQRYJX82X45I247S', 'Colby', 'Dickerson', '2005-10-04', '7230818818', 'dickersoncolby@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('WUHTHU73E59C484W', 'Emily', 'Davidson', '1999-09-17', '7507282532', 'davidsonemily@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('OWYSYT64W23B422G', 'Buffy', 'Marquez', '2006-10-27', '3623218918', 'buffymarquez@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('IPTEKK42V88C885F', 'Damian', 'Mckee', '1968-07-13', '5489423808', 'm_damian8290@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SYRMOO71V61V830U', 'Nyssa', 'Wilkins', '2004-10-30', '0194898124', 'wilkins.nyssa2288@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('KLWOUI71Z43K161A', 'Benjamin', 'Mercado', '1993-06-20', '8522114262', 'benjamin.mercado1989@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('ULFACU31X61B726L', 'James', 'Kelly', '1978-09-26', '8575157276', 'kelly-james3350@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('XVSFEJ10Y37P513P', 'Iona', 'Hubbard', '1979-09-22', '5608984182', 'hubbardiona2508@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('DBPGYC31R35B161T', 'Ali', 'Bridges', '1989-12-02', '7649353221', 'bridgesali@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MRBPFF47D22V133C', 'Odette', 'Mccullough', '1969-01-07', '2147126532', 'odette_mccullough1471@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('PIPEIL78L16N738F', 'Brent', 'Cox', '1982-06-18', '7552128339', 'b.cox@protonmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('PGYETF56W17M511H', 'Brianna', 'Hinton', '1963-11-22', '7361201237', 'b-hinton8427@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('BMUFNB38Y56O504C', 'Imogene', 'Molina', '1972-05-17', '3806881614', 'molinaimogene4466@libero.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('TMJPFK21S01L821F', 'Gregory', 'Mann', '1981-03-17', '2557234527', 'g-mann@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('PUAYOM06G23G327S', 'Lenore', 'Jensen', '1989-04-29', '0166687283', 'lenore.jensen@google.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('CQVLHL87W14S634A', 'Caldwell', 'Torres', '1965-07-13', '0839782864', 't.caldwell@hotmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MIIKKJ21C57Y754D', 'Adrian', 'Solis', '1981-08-27', '9339424876', 'adrian_solis685@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MWRLRY03L97T056S', 'Brenna', 'Saunders', '1984-03-19', '2804723452', 'b-saunders@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('FXBHWJ01J17W844J', 'Benedict', 'Manning', '1960-12-19', '8348135092', 'manning.benedict2217@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('XTQBJG46C36Z643H', 'Josephine', 'Navarro', '2002-05-14', '0921867951', 'navarro_josephine7647@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('REKCWF57A59Y128M', 'Brynn', 'Sears', '1994-07-31', '5485173823', 's-brynn@protonmail.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('NFYIYT44L87O297T', 'Daryl', 'Justice', '1959-07-26', '2312059282', 'justicedaryl@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('DYRBPQ99B36F365J', 'Herman', 'Lopez', '1971-01-07', '6246877758', 'lopez_herman@icloud.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('CDRBDE88V47R883L', 'Emmanuel', 'Baird', '1958-03-27', '1039152146', 'e_baird5713@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('HQRVSS87F23F612H', 'Rhona', 'Walters', '1964-01-13', '0751869251', 'waltersrhona@google.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('BKBVXZ86H47G627N', 'Anthony', 'Riggs', '2009-10-27', '7718564225', 'a.riggs@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('PAFOYS27Y65H362N', 'Stacey', 'Prince', '2011-05-06', '8761405273', 'stacey_prince2645@google.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('MVFTSK10F87C758G', 'Ray', 'Rogers', '1979-11-06', '3216725091', 'rogers-ray@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('WWECPG55C54Y515X', 'Elmo', 'Powell', '1969-07-25', '6680437665', 'e.powell3056@outlook.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('TCUYYW94X10P688O', 'Reagan', 'Dennis', '2006-12-10', '4064291628', 'r-dennis@protonmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('KUQTOY36I88E660Y', 'Acton', 'Meyer', '1963-03-22', '6622738898', 'acton.meyer4753@hotmail.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('SFLLSD78C76Z073K', 'Mark', 'Hogan', '1972-03-01', '1555573862', 'm-hogan9603@icloud.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('WHYKHG47P17U277Q', 'Zephania', 'Stark', '1969-06-18', '1428922188', 'z-stark@outlook.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('FPKOSH23L82S213P', 'Vincent', 'Parsons', '1971-11-12', '3885154261', 'parsonsvincent2187@libero.com');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('ZELEPP29G70R656F', 'Jennifer', 'Moon', '1984-06-05', '5628061757', 'j.moon@yahoo.it');
INSERT INTO "Persona" ("CF", "Nome", "Cognome", "DataNascita", "Telefono", "Email") VALUES ('FHDKYM01X94J747F', 'Alyssa', 'Bass', '2010-07-25', '8122682067', 'bass_alyssa@libero.com');

INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-01');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-02');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-03');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-04');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-05');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-06');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-07');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-08');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-09');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-10');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-11');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-12');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-13');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-14');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2021-04-15');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-08');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-09');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-10');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-11');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-12');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-13');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-14');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-15');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-16');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-17');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-18');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-19');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2022-04-20');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2000-04-01');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('1999-04-02');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2001-04-03');
INSERT INTO "Audizione" ("DataAudizione") VALUES ('2003-04-04');

INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Paranoid', 'Black Sabbath', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Paranoid', 'Megadeth', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Trust', 'Megadeth', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Enter Sandman', 'Metallica', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Disposable Heroes', 'Metallica', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Creeping Death', 'Metallica', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Holy Diver', 'Ronnie James Dio', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Technical Difficulties', 'Racer X', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Gold Digger', 'Forever Lost', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Faithless', 'Lining Redox', 'Metal');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Someone Like You', 'Adele', 'Pop');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Rumor has it', 'Adele', 'Pop');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('L''estate addosso', 'Jovanotti', 'Pop');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Brividi', 'Blanco, Mahmood', 'Pop');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('I wanna be your slave', 'Maneskin', 'Rock');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Back in Black', 'AC/DC', 'Rock');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('T.N.T.', 'AC/DC', 'Rock');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Fur Elise', 'Ludwig Van Beethoven', 'Classica');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('La danza della fata confetto', 'Pëtr Il''ič Čajkovskij', 'Classica');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Primavera', 'Antonio Vivaldi', 'Classica');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Inno alla Gioia', 'Ludwig Van Beethoven', 'Classica');
INSERT INTO "Brano" ("NomeBrano", "Artista", "GenereBrano") VALUES ('Toccata e Fuga', 'Johann Sebastian Bach', 'Classica');

INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Pianoforte', 45, 4, 'I', NULL);
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Chitarra Classica', 45, 4, 'I', NULL);
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Chitarra Elettrica', 45, 4, 'I', NULL);
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Basso', 45, 4, 'I', NULL);
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Batteria', 45, 4, 'I', NULL);
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Violino', 45, 4, 'I', NULL);
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Cornamusa', 45, 4, 'I', NULL);
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Canto', 45, 4, 'I', NULL);
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Musica D''Insieme Classica', 60, 2, 'C', 'Corso orientato ai musicisti classici');
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Musica D''Insieme Moderna', 60, 2, 'C', 'Corso orientato alla musica moderna');
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Teatro', 60, 2, 'C', 'Sviluppo della recitazione');
INSERT INTO "Corso" ("NomeCorso", "DurataLezione", "LezioneMese", "TipologiaCorso", "Descrizione") VALUES ('Propedeutica', 30, 2, 'C', 'Corso destinato ai bambini');

INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('1', '2022-06-01');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('3', '2022-06-01');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('2', '2022-06-08');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('4', '2022-06-08');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('1', '2022-06-08');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('3', '2022-06-15');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('4', '2022-06-22');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('1', '2021-06-02');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('3', '2021-06-02');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('2', '2021-06-02');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('1', '2021-06-09');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('4', '2021-06-16');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('3', '2021-06-23');
INSERT INTO "Esame" ("LivelloAbilitazione", "DataEsame") VALUES ('4', '2021-06-30');

INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Centro Parrocchiale Arino', 'L', NULL, 'Via Chiesa, 5', 'Arino');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Centro Parrocchiale Bagnoli di Sopra', 'L', NULL, 'Piazza Martiri d''Ungheria,27', 'Bagnoli di Sopra');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Centro Parrocchiale Camin', 'L', NULL, 'Via S. Salvatore, 78', 'Camin');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Dolo Centro', 'L', NULL, 'Via Dauli, 5', 'Dolo');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Fossò Centro', 'L', NULL, 'Via Roma, 63', 'Fossò');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Sala De Andrè Legnaro', 'L', NULL, 'Piazza Costituzione, 1', 'Legnaro');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Centro Parrocchiale San Michele Marghera', 'L', NULL, 'Via Fratelli Bandiera, 100', 'Marghera');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Centro Parrocchiale San Paolo Mestre', 'L', NULL, 'Via Cesare Cecchini', 'Venezia');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Centro Parrocchiale Cristo Re Padova', 'L', NULL, 'Via Sant''Osvaldo, 4', 'Padova');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Centro Parrocchiale Santa Croce Padova', 'L', NULL, 'Corso Vittorio Emanuele II, 166', 'Padova');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Teatro Dario Fo Camponogara', 'E', 800, 'Piazza Castellaro', 'Camponogara');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Villa Valier', 'E', 1600, 'Via G. Di Vittorio, 1', 'Mira');
INSERT INTO "Sede" ("NomeSede", "Utilizzo", "MaxPosti", "Indirizzo", "Citta") VALUES ('Teatro Villa dei Leoni', 'E', 900, 'Riviera S. Trentin, 3', 'Mira');

INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0001', 'RQTDXX19H37X370X', '2021-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0002', 'VDMWBH73M53Y714Y', '1997-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0003', 'HTMKIY72V46R455E', '1997-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0004', 'LQRYJX82X45I247S', '2021-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0005', 'WUHTHU73E59C484W', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0006', 'OWYSYT64W23B422G', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0007', 'IPTEKK42V88C885F', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0008', 'SYRMOO71V61V830U', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0009', 'ULFACU31X61B726L', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0010', 'XVSFEJ10Y37P513P', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0011', 'MRBPFF47D22V133C', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0012', 'PGYETF56W17M511H', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0013', 'BMUFNB38Y56O504C', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0014', 'CQVLHL87W14S634A', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0015', 'FXBHWJ01J17W844J', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0016', 'XTQBJG46C36Z643H', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0017', 'NFYIYT44L87O297T', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0018', 'DYRBPQ99B36F365J', '2018-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0019', 'CDRBDE88V47R883L', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0020', 'HQRVSS87F23F612H', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0021', 'BKBVXZ86H47G627N', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0022', 'PAFOYS27Y65H362N', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0023', 'MVFTSK10F87C758G', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0024', 'WWECPG55C54Y515X', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0025', 'TCUYYW94X10P688O', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0026', 'KUQTOY36I88E660Y', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0027', 'SFLLSD78C76Z073K', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0028', 'WHYKHG47P17U277Q', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0029', 'FPKOSH23L82S213P', '2019-09-01', '2022-06-30');
INSERT INTO "Associato" ("CodiceTessera", "CF", "DataIscrizione", "DataScadenza") VALUES ('2022GG0030', 'FHDKYM01X94J747F', '2019-09-01', '2022-06-30');

INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('RURIQS68S32B466W', 'Pianoforte', '1977-05-07', '1982-09-01', '2007-06-30', 'Presidente', '1982-09-01', '2007-06-30');
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('TMJPFK21S01L821F', 'Pianoforte', '2001-07-15', '2003-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('MIIKKJ21C57Y754D', 'Pianoforte', '2001-07-16', '2002-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('PIPEIL78L16N738F', 'Canto', '2002-11-21', '2003-09-01', '2006-06-30', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('MWRLRY03L97T056S', 'Violino', '2004-04-10', '2004-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('ZELEPP29G70R656F', 'Chitarra Elettrica', '2004-08-11', '2004-09-01', '2004-10-01', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('OMAXAQ88H36X867Q', 'Cornamusa', '2005-08-12', '2005-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('XMYJAO70L78I240L', 'Canto', '2006-08-13', '2006-09-01', NULL, 'Presidente', '1981-06-03', NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('BROBEA95I13N812L', 'Batteria', '2006-08-14', '2006-09-01', '2018-06-30', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('IOFOZZ50U82T741E', 'Batteria', '2006-08-15', '2006-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('NPFWHQ71D02T713X', 'Chitarra Classica', '2007-08-16', '2007-09-01', '2018-06-30', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('BFUOJJ74G33V675S', 'Chitarra Classica', '2007-08-17', '2007-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('PUAYOM06G23G327S', 'Pianoforte', '2009-08-18', '2009-09-01', NULL, 'Direttore Artistico', '1981-06-08', NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('DBPGYC31R35B161T', 'Violino', '2009-08-19', '2009-09-01', '2018-06-30', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('XVHXZE81H86U647H', 'Cornamusa', '2009-08-20', '2009-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('NOOBLE34P45I612L', 'Basso', '2009-08-21', '2009-09-01', NULL, 'Responsabile Musica d''Insieme', '2009-09-01', '2013-06-30');
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('OIBPBN38G17K415C', 'Chitarra Elettrica', '2013-08-22', '2013-09-01', NULL, 'Responsabile Musica d''Insieme', '2013-09-01', NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('KLWOUI71Z43K161A', 'Chitarra Elettrica', '2013-08-23', '2013-09-01', '2018-06-24', 'Responsabile Musica d''Insieme', '2013-09-01', NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('REKCWF57A59Y128M', 'Chitarra Classica', '2014-08-24', '2014-09-01', '2018-06-30', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('UHEPKR56Y58E429C', 'Violino', '2015-08-25', '2015-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('FCJFSE25C20V588J', 'Flauto', '2015-08-26', '2015-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('FEIEQP79H80T785O', 'Basso', '2015-08-27', '2015-09-01', '2019-06-30', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('FLQMSL06X75D245E', 'Violino', '2015-08-28', '2015-09-01', NULL, 'Segretario', '2015-09-01', NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('XOBDPE63B34F268F', 'Batteria', '2016-08-29', '2016-09-01', '2018-06-30', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('YJYLZS66P77T641E', 'Cornamusa', '2016-08-30', '2016-09-01', '2018-06-30', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('FUJYSO02X60D552V', 'Basso', '2017-08-31', '2017-09-01', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('VPPMBC83L68W079L', 'Chitarra Elettrica', '2018-09-01', '2019-09-02', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('ZBFDBC65F93R481R', 'Violino', '2018-09-02', '2019-09-03', '2020-06-30', NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('JQDBHY47L85N710L', 'Chitarra Classica', '2018-09-03', '2019-09-04', NULL, NULL, NULL, NULL);
INSERT INTO "Docente" ("CF", "Diploma", "DataDiploma", "InizioDocenza", "FineDocenza", "RuoloDirigente", "InizioDirigenza", "FineDirigenza") VALUES ('CNWYWL75H80E135T', 'Batteria', '2019-09-04', '2020-09-01', NULL, NULL, NULL, NULL);

INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '1984-09-01', '2022-06-30', 'CTBECF63I11B333T');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '2019-09-01', NULL, 'TYOPWT25N36K731N');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '1 ', '1995-09-01', '2022-06-30', 'LQAFOY65M45Q044R');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '2017-09-01', NULL, 'GPNUJN67U68Q907V');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '2010-09-01', '2022-06-30', 'LBSAFQ59M54B342J');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '2 ', '1998-09-01', NULL, 'IXUPNM20S13E584E');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '4 ', '1997-09-01', '2022-06-30', 'NXAAOM07U43G754G');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '1985-09-01', NULL, 'IPVUDC98Q18L777K');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '1997-09-01', NULL, 'YMYRAB54Q38R753B');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '3 ', '2015-09-01', '2022-06-30', 'RCRMUY42B31E767A');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '1 ', '2020-09-01', NULL, 'IPNTHV11G47V858U');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '1 ', '2018-09-01', '2022-06-30', 'HKQOAW86G33S636B');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '2010-09-01', NULL, 'OQPTLN96H08F286C');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '1982-09-01', '2005-06-30', 'SAIXSL90V15U140S');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '2 ', '2019-09-01', NULL, 'IDDUFF42T85D961U');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '1984-09-01', '2004-06-30', 'DOUFSP75R38S925N');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '1 ', '1995-09-01', '2022-06-30', 'QPLPAF20D54X648B');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '2010-09-01', '2022-06-30', 'MRBLOO63U46J782N');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '2007-09-01', NULL, 'PUJONZ68E31M317V');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '2020-09-01', '2022-06-30', 'HXJMYS16G06V188Y');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '2 ', '1984-09-01', NULL, 'GDGRFK66Y46U571X');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '4 ', '1984-09-01', '2008-04-01', 'XBSYNY72X10T737S');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '2020-09-01', '2022-06-30', 'JIQVBG65G55T820V');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '1984-09-01', NULL, 'MEFTIL72I80B815O');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '3 ', '1984-09-01', NULL, 'NOVGBK38B22S594F');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '1 ', '1984-09-01', '2000-06-30', 'JQZLGJ38L89E153E');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '2022-09-01', NULL, 'ESFXMJ79J19G686J');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('P', '2 ', '1984-09-01', '2003-06-30', 'PYDSWN72D37Y970M');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '1984-09-01', NULL, 'STTWCL63T08O236O');
INSERT INTO "Studente" ("Tipologia", "Livello", "InizioLezioni", "FineLezioni", "CF") VALUES ('A', NULL, '1997-09-01', NULL, 'NWYQYS34J81B675X');

INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('E83C2D26', 5, '2007-01-05', '2007-05-30', 'RURIQS68S32B466W', 'Centro Parrocchiale Arino', 'Pianoforte');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('0AF5D656', 3, '2022-03-30', NULL, 'MIIKKJ21C57Y754D', 'Centro Parrocchiale Bagnoli di Sopra', 'Pianoforte');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('25AE4A95', 3, '2021-09-23', '2022-05-04', 'MWRLRY03L97T056S', 'Centro Parrocchiale Camin', 'Violino');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('F15BBDB9', 2, '2021-10-09', '2022-02-26', 'OMAXAQ88H36X867Q', 'Dolo Centro', 'Cornamusa');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('BDDBC6AB', 1, '2022-01-03', NULL, 'XMYJAO70L78I240L', 'Fossò Centro', 'Canto');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('82EB2B2C', 1, '2021-09-06', '2022-04-20', 'IOFOZZ50U82T741E', 'Sala De Andrè Legnaro', 'Batteria');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('128E8218', 6, '2020-10-02', '2021-10-10', 'BFUOJJ74G33V675S', 'Centro Parrocchiale San Michele Marghera', 'Chitarra Classica');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('A81C2847', 4, '2021-03-09', '2021-10-20', 'PUAYOM06G23G327S', 'Centro Parrocchiale San Paolo Mestre', 'Pianoforte');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('768D6AD6', 3, '2020-08-03', '2021-03-26', 'XVHXZE81H86U647H', 'Centro Parrocchiale Cristo Re Padova', 'Cornamusa');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('2AD7E952', 1, '2021-12-13', NULL, 'NOOBLE34P45I612L', 'Centro Parrocchiale Santa Croce Padova', 'Basso');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('8E8DF5A2', 1, '2022-04-30', NULL, 'OIBPBN38G17K415C', 'Centro Parrocchiale San Paolo Mestre', 'Chitarra Elettrica');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('278EAA57', 1, '2022-01-06', '2022-02-28', 'UHEPKR56Y58E429C', 'Fossò Centro', 'Violino');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('3C7CACB7', 2, '2021-05-07', NULL, 'FCJFSE25C20V588J', 'Centro Parrocchiale Arino', 'Propedeutica');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('9C4EB625', 1, '2022-02-28', NULL, 'FLQMSL06X75D245E', 'Centro Parrocchiale Santa Croce Padova', 'Violino');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('65D3D1D1', 1, '2020-11-13', '2021-10-22', 'FUJYSO02X60D552V', 'Centro Parrocchiale Arino', 'Basso');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('E7E13971', 6, '2018-12-15', '2022-03-17', 'VPPMBC83L68W079L', 'Centro Parrocchiale San Michele Marghera', 'Chitarra Elettrica');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('969DA199', 5, '2020-02-24', '2021-03-04', 'JQDBHY47L85N710L', 'Dolo Centro', 'Teatro');
INSERT INTO "Attivita" ("CodiceAttivita", "NumStudenti", "InizioAttivita", "FineAttivita", "Docente", "Sede", "Corso") VALUES ('7D1EC974', 4, '2021-04-03', '2022-01-02', 'CNWYWL75H80E135T', 'Centro Parrocchiale Bagnoli di Sopra', 'Batteria');

INSERT INTO "Evento" ("NomeEvento", "NumSpettatori", "GenereEvento", "Organizzatore", "CoOrganizzatore", "TipoEvento", "LuogoEvento") VALUES ('Note Future 2020', 300, 'Classica', NULL, 'Conservatorio Pollini di Venezia', 'N', 'Teatro Dario Fo Camponogara');
INSERT INTO "Evento" ("NomeEvento", "NumSpettatori", "GenereEvento", "Organizzatore", "CoOrganizzatore", "TipoEvento", "LuogoEvento") VALUES ('Saggio al Dario Fo 2005', 20, 'Misto', NULL, NULL, 'S', 'Teatro Dario Fo Camponogara');
INSERT INTO "Evento" ("NomeEvento", "NumSpettatori", "GenereEvento", "Organizzatore", "CoOrganizzatore", "TipoEvento", "LuogoEvento") VALUES ('Saggio al Teatro Villa Dei Leoni 2021', 20, 'Misto', NULL, NULL, 'S', 'Teatro Villa dei Leoni');
INSERT INTO "Evento" ("NomeEvento", "NumSpettatori", "GenereEvento", "Organizzatore", "CoOrganizzatore", "TipoEvento", "LuogoEvento") VALUES ('Note Future 2015', 370, 'Classica', NULL, 'Conservatorio Pollini di Venezia', 'N', 'Teatro Dario Fo Camponogara');
INSERT INTO "Evento" ("NomeEvento", "NumSpettatori", "GenereEvento", "Organizzatore", "CoOrganizzatore", "TipoEvento", "LuogoEvento") VALUES ('Pentagramma Rock 2018', 650, 'Rock', 'Ruvido Barber Shop', NULL, 'N', 'Villa Valier');
INSERT INTO "Evento" ("NomeEvento", "NumSpettatori", "GenereEvento", "Organizzatore", "CoOrganizzatore", "TipoEvento", "LuogoEvento") VALUES ('Saggio in Villa Valier 2022', 15, 'Misto', NULL, NULL, 'S', 'Villa Valier');
INSERT INTO "Evento" ("NomeEvento", "NumSpettatori", "GenereEvento", "Organizzatore", "CoOrganizzatore", "TipoEvento", "LuogoEvento") VALUES ('Pentagramma Metal Fest 2022', 250, 'Metal', NULL, 'Radio Marilù', 'N', 'Teatro Dario Fo Camponogara');
INSERT INTO "Evento" ("NomeEvento", "NumSpettatori", "GenereEvento", "Organizzatore", "CoOrganizzatore", "TipoEvento", "LuogoEvento") VALUES ('Pop Fest 2022', 1000, 'Pop', 'Pop Events', NULL, 'N', 'Teatro Villa dei Leoni');

INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('CTBECF63I11B333T', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('CTBECF63I11B333T', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('CTBECF63I11B333T', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('CTBECF63I11B333T', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('CTBECF63I11B333T', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('CTBECF63I11B333T', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('TYOPWT25N36K731N', '2021-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('TYOPWT25N36K731N', '2022-04-10');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('LQAFOY65M45Q044R', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('LQAFOY65M45Q044R', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('LQAFOY65M45Q044R', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('LQAFOY65M45Q044R', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('LQAFOY65M45Q044R', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('LQAFOY65M45Q044R', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('GPNUJN67U68Q907V', '2021-04-14');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('GPNUJN67U68Q907V', '2022-04-10');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('LBSAFQ59M54B342J', '2021-04-14');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('LBSAFQ59M54B342J', '2022-04-10');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IXUPNM20S13E584E', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IXUPNM20S13E584E', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IXUPNM20S13E584E', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IXUPNM20S13E584E', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IXUPNM20S13E584E', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IXUPNM20S13E584E', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NXAAOM07U43G754G', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NXAAOM07U43G754G', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NXAAOM07U43G754G', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NXAAOM07U43G754G', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NXAAOM07U43G754G', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NXAAOM07U43G754G', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IPVUDC98Q18L777K', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IPVUDC98Q18L777K', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IPVUDC98Q18L777K', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IPVUDC98Q18L777K', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IPVUDC98Q18L777K', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IPVUDC98Q18L777K', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('YMYRAB54Q38R753B', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('YMYRAB54Q38R753B', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('YMYRAB54Q38R753B', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('YMYRAB54Q38R753B', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('YMYRAB54Q38R753B', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('YMYRAB54Q38R753B', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('RCRMUY42B31E767A', '2021-04-14');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('RCRMUY42B31E767A', '2022-04-09');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IPNTHV11G47V858U', '2021-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IPNTHV11G47V858U', '2022-04-15');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('HKQOAW86G33S636B', '2021-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('HKQOAW86G33S636B', '2022-04-09');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('OQPTLN96H08F286C', '2021-04-06');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('OQPTLN96H08F286C', '2022-04-18');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('SAIXSL90V15U140S', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('SAIXSL90V15U140S', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('SAIXSL90V15U140S', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('SAIXSL90V15U140S', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IDDUFF42T85D961U', '2021-04-15');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('IDDUFF42T85D961U', '2022-04-20');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('DOUFSP75R38S925N', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('DOUFSP75R38S925N', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('DOUFSP75R38S925N', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('DOUFSP75R38S925N', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('QPLPAF20D54X648B', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('QPLPAF20D54X648B', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('QPLPAF20D54X648B', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('QPLPAF20D54X648B', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('QPLPAF20D54X648B', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('QPLPAF20D54X648B', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('MRBLOO63U46J782N', '2021-04-08');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('MRBLOO63U46J782N', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('PUJONZ68E31M317V', '2021-04-15');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('PUJONZ68E31M317V', '2022-04-20');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('HXJMYS16G06V188Y', '2021-04-08');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('HXJMYS16G06V188Y', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('GDGRFK66Y46U571X', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('GDGRFK66Y46U571X', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('GDGRFK66Y46U571X', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('GDGRFK66Y46U571X', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('GDGRFK66Y46U571X', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('GDGRFK66Y46U571X', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('XBSYNY72X10T737S', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('XBSYNY72X10T737S', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('XBSYNY72X10T737S', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('XBSYNY72X10T737S', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('JIQVBG65G55T820V', '2021-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('JIQVBG65G55T820V', '2022-04-09');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('MEFTIL72I80B815O', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('MEFTIL72I80B815O', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('MEFTIL72I80B815O', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('MEFTIL72I80B815O', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('MEFTIL72I80B815O', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('MEFTIL72I80B815O', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NOVGBK38B22S594F', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NOVGBK38B22S594F', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NOVGBK38B22S594F', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NOVGBK38B22S594F', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NOVGBK38B22S594F', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NOVGBK38B22S594F', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('JQZLGJ38L89E153E', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('JQZLGJ38L89E153E', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('PYDSWN72D37Y970M', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('PYDSWN72D37Y970M', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('PYDSWN72D37Y970M', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('PYDSWN72D37Y970M', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('STTWCL63T08O236O', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('STTWCL63T08O236O', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('STTWCL63T08O236O', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('STTWCL63T08O236O', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('STTWCL63T08O236O', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('STTWCL63T08O236O', '2022-04-12');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NWYQYS34J81B675X', '1999-04-02');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NWYQYS34J81B675X', '2000-04-01');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NWYQYS34J81B675X', '2001-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NWYQYS34J81B675X', '2003-04-04');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NWYQYS34J81B675X', '2021-04-03');
INSERT INTO "Accertamento" ("CF", "DataAudizione") VALUES ('NWYQYS34J81B675X', '2022-04-12');

INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('CTBECF63I11B333T', 'E83C2D26');
INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('TYOPWT25N36K731N', '0AF5D656');
INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('LQAFOY65M45Q044R', '25AE4A95');
INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('GPNUJN67U68Q907V', 'BDDBC6AB');
INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('IXUPNM20S13E584E', '82EB2B2C');
INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('IPVUDC98Q18L777K', '2AD7E952');
INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('YMYRAB54Q38R753B', '8E8DF5A2');
INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('IPNTHV11G47V858U', '3C7CACB7');
INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('OQPTLN96H08F286C', '9C4EB625');
INSERT INTO "Apprendimento" ("CF", "CodiceAttivita") VALUES ('IDDUFF42T85D961U', 'E7E13971');

INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('RURIQS68S32B466W', '1999-04-02');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('RURIQS68S32B466W', '2000-04-01');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('RURIQS68S32B466W', '2001-04-03');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('RURIQS68S32B466W', '2003-04-04');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('MIIKKJ21C57Y754D', '2003-04-04');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('MIIKKJ21C57Y754D', '2021-04-03');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('MIIKKJ21C57Y754D', '2022-04-12');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('MWRLRY03L97T056S', '2021-04-14');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('MWRLRY03L97T056S', '2022-04-10');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('OMAXAQ88H36X867Q', '2021-04-14');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('OMAXAQ88H36X867Q', '2022-04-10');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('XMYJAO70L78I240L', '2021-04-03');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('XMYJAO70L78I240L', '2022-04-12');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('BROBEA95I13N812L', '2021-04-03');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('BROBEA95I13N812L', '2022-04-12');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('TMJPFK21S01L821F', '2021-04-03');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('TMJPFK21S01L821F', '2022-04-12');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('IOFOZZ50U82T741E', '2021-04-03');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('NPFWHQ71D02T713X', '2022-04-12');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('BFUOJJ74G33V675S', '2021-04-14');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('PUAYOM06G23G327S', '2022-04-09');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('DBPGYC31R35B161T', '2021-04-01');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('XVHXZE81H86U647H', '2022-04-15');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('NOOBLE34P45I612L', '2021-04-01');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('OIBPBN38G17K415C', '2022-04-09');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('KLWOUI71Z43K161A', '2021-04-06');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('REKCWF57A59Y128M', '2022-04-18');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('UHEPKR56Y58E429C', '2021-04-15');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('FCJFSE25C20V588J', '2022-04-20');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('PIPEIL78L16N738F', '2021-04-03');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('FEIEQP79H80T785O', '2022-04-12');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('FLQMSL06X75D245E', '2021-04-08');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('XOBDPE63B34F268F', '2022-04-12');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('YJYLZS66P77T641E', '2021-04-15');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('FUJYSO02X60D552V', '2022-04-20');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('VPPMBC83L68W079L', '2021-04-08');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('ZBFDBC65F93R481R', '2022-04-12');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('JQDBHY47L85N710L', '2021-04-03');
INSERT INTO "Auditore" ("CF", "DataAudizione") VALUES ('CNWYWL75H80E135T', '2022-04-12');

INSERT INTO "Scaletta" ("NomeEvento") VALUES ('Note Future 2020');
INSERT INTO "Scaletta" ("NomeEvento") VALUES ('Saggio al Dario Fo 2005');
INSERT INTO "Scaletta" ("NomeEvento") VALUES ('Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "Scaletta" ("NomeEvento") VALUES ('Note Future 2015');
INSERT INTO "Scaletta" ("NomeEvento") VALUES ('Pentagramma Rock 2018');
INSERT INTO "Scaletta" ("NomeEvento") VALUES ('Saggio in Villa Valier 2022');
INSERT INTO "Scaletta" ("NomeEvento") VALUES ('Pentagramma Metal Fest 2022');
INSERT INTO "Scaletta" ("NomeEvento") VALUES ('Pop Fest 2022');

INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Fur Elise', 'Ludwig Van Beethoven', 'Note Future 2020');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Primavera', 'Antonio Vivaldi', 'Note Future 2020');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Toccata e Fuga', 'Johann Sebastian Bach', 'Note Future 2020');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Fur Elise', 'Ludwig Van Beethoven', 'Note Future 2015');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('La danza della fata confetto', 'Pëtr Il''ič Čajkovskij', 'Note Future 2015');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Primavera', 'Antonio Vivaldi', 'Note Future 2015');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Inno alla Gioia', 'Ludwig Van Beethoven', 'Note Future 2015');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Toccata e Fuga', 'Johann Sebastian Bach', 'Note Future 2015');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Paranoid', 'Black Sabbath', 'Saggio al Dario Fo 2005');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Enter Sandman', 'Metallica', 'Saggio al Dario Fo 2005');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Holy Diver', 'Ronnie James Dio', 'Saggio al Dario Fo 2005');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Back in Black', 'AC/DC', 'Saggio al Dario Fo 2005');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('T.N.T.', 'AC/DC', 'Saggio al Dario Fo 2005');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Primavera', 'Antonio Vivaldi', 'Saggio al Dario Fo 2005');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Paranoid', 'Megadeth', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Disposable Heroes', 'Metallica', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Holy Diver', 'Ronnie James Dio', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Technical Difficulties', 'Racer X', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Fur Elise', 'Ludwig Van Beethoven', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('La danza della fata confetto', 'Pëtr Il''ič Čajkovskij', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Toccata e Fuga', 'Johann Sebastian Bach', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Someone Like You', 'Adele', 'Pop Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Rumor has it', 'Adele', 'Pop Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('L''estate addosso', 'Jovanotti', 'Pop Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Brividi', 'Blanco, Mahmood', 'Pop Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Paranoid', 'Black Sabbath', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Paranoid', 'Megadeth', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Trust', 'Megadeth', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Enter Sandman', 'Metallica', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Disposable Heroes', 'Metallica', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Creeping Death', 'Metallica', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Holy Diver', 'Ronnie James Dio', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Technical Difficulties', 'Racer X', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Gold Digger', 'Forever Lost', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Faithless', 'Lining Redox', 'Pentagramma Metal Fest 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Technical Difficulties', 'Racer X', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Gold Digger', 'Forever Lost', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Faithless', 'Lining Redox', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Someone Like You', 'Adele', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Brividi', 'Blanco, Mahmood', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('I wanna be your slave', 'Maneskin', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Back in Black', 'AC/DC', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('La danza della fata confetto', 'Pëtr Il''ič Čajkovskij', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Inno alla Gioia', 'Ludwig Van Beethoven', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Toccata e Fuga', 'Johann Sebastian Bach', 'Saggio in Villa Valier 2022');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('Back in Black', 'AC/DC', 'Pentagramma Rock 2018');
INSERT INTO "BranoEseguito" ("NomeBrano", "Artista", "NomeEvento") VALUES ('T.N.T.', 'AC/DC', 'Pentagramma Rock 2018');

INSERT INTO "Esaminato" ("LivelloAbilitazione", "DataEsame", "CF", "EsitoEsame") VALUES ('2', '2021-06-02', 'HKQOAW86G33S636B', 'Non Passato');
INSERT INTO "Esaminato" ("LivelloAbilitazione", "DataEsame", "CF", "EsitoEsame") VALUES ('2', '2022-06-08', 'IDDUFF42T85D961U', 'Passato');
INSERT INTO "Esaminato" ("LivelloAbilitazione", "DataEsame", "CF", "EsitoEsame") VALUES ('1', '2022-06-08', 'QPLPAF20D54X648B', 'Passato');
INSERT INTO "Esaminato" ("LivelloAbilitazione", "DataEsame", "CF", "EsitoEsame") VALUES ('3', '2021-06-02', 'GDGRFK66Y46U571X', 'Non Passato');
INSERT INTO "Esaminato" ("LivelloAbilitazione", "DataEsame", "CF", "EsitoEsame") VALUES ('3', '2022-06-01', 'NOVGBK38B22S594F', 'Passato');
INSERT INTO "Esaminato" ("LivelloAbilitazione", "DataEsame", "CF", "EsitoEsame") VALUES ('1', '2021-06-09', 'LQAFOY65M45Q044R', 'Passato');

INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('1 ', '2022-06-01', 'TMJPFK21S01L821F');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('3 ', '2022-06-01', 'MIIKKJ21C57Y754D');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('2 ', '2022-06-08', 'MWRLRY03L97T056S');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('4 ', '2022-06-08', 'OMAXAQ88H36X867Q');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('1 ', '2022-06-08', 'XMYJAO70L78I240L');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('3 ', '2022-06-15', 'IOFOZZ50U82T741E');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('4 ', '2022-06-22', 'BFUOJJ74G33V675S');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('1 ', '2021-06-02', 'PUAYOM06G23G327S');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('3 ', '2021-06-02', 'XVHXZE81H86U647H');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('2 ', '2021-06-02', 'NOOBLE34P45I612L');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('1 ', '2021-06-09', 'OIBPBN38G17K415C');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('4 ', '2021-06-16', 'UHEPKR56Y58E429C');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('3 ', '2021-06-23', 'FCJFSE25C20V588J');
INSERT INTO "Esaminatore" ("LivelloAbilitazione", "DataEsame", "CF") VALUES ('4 ', '2021-06-30', 'FLQMSL06X75D245E');

INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('CTBECF63I11B333T', 'Saggio al Dario Fo 2005');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('CTBECF63I11B333T', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('CTBECF63I11B333T', 'Pentagramma Rock 2018');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('TYOPWT25N36K731N', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('TYOPWT25N36K731N', 'Saggio in Villa Valier 2022');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('TYOPWT25N36K731N', 'Pentagramma Metal Fest 2022');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('LQAFOY65M45Q044R', 'Saggio al Dario Fo 2005');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('LQAFOY65M45Q044R', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('LQAFOY65M45Q044R', 'Pentagramma Rock 2018');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('LQAFOY65M45Q044R', 'Saggio in Villa Valier 2022');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('XBSYNY72X10T737S', 'Saggio al Dario Fo 2005');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('JIQVBG65G55T820V', 'Note Future 2020');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('JIQVBG65G55T820V', 'Saggio al Dario Fo 2005');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('JIQVBG65G55T820V', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('JIQVBG65G55T820V', 'Note Future 2015');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('MEFTIL72I80B815O', 'Saggio al Dario Fo 2005');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('MEFTIL72I80B815O', 'Saggio al Teatro Villa Dei Leoni 2021');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('MEFTIL72I80B815O', 'Saggio in Villa Valier 2022');
INSERT INTO "Performance" ("CF", "NomeEvento") VALUES ('MEFTIL72I80B815O', 'Pop Fest 2022');

/* Interrogazioni */

/*1) Trovare i nominativi degli studenti che attualmente frequentano il corso di Pianoforte.*/
SELECT "Nome", "Cognome"
FROM "Persona"
JOIN "Studente" ON "Persona"."CF"="Studente"."CF"
JOIN "Apprendimento" ON "Studente"."CF"="Apprendimento"."CF"
JOIN "Attivita" ON "Apprendimento"."CodiceAttivita"="Attivita"."CodiceAttivita"
WHERE "FineAttivita" IS NULL AND "Corso"='Pianoforte'

/*2) Fornire le generalità (nome, cognome e numero di telefono) degli associati iscritti dal 2018.*/
SELECT "Nome", "Cognome", "Telefono"
FROM "Persona", "Associato"
WHERE "Persona"."CF"="Associato"."CF" AND "Associato"."DataIscrizione">='2019-01-01'

/*3) Selezionare i docenti (con nome e cognome) che sono stati esaminatori almeno una volta.*/
SELECT "Nome","Cognome"
FROM "Docente", "Persona"
WHERE "Docente"."CF"="Persona"."CF" AND "Docente"."CF" IN
(SELECT "CF" FROM "Esaminatore" GROUP BY "CF")

/*4) Elencare i corsi che siano stati tenuti più di una volta*/
SELECT "Corso"
FROM "Docente", "Attivita"
WHERE "Docente"."CF"="Attivita"."Docente"
GROUP BY "Corso"
HAVING COUNT(*)>=2

/*5) Mostrare il numero di scalette in cui sia stato eseguito almeno una volta un brano dal genere "Metal".*/
SELECT "GenereBrano", COUNT(*)
FROM "Scaletta"
JOIN "BranoEseguito" ON "Scaletta"."NomeEvento"="BranoEseguito"."NomeEvento"
JOIN "Brano" ON "BranoEseguito"."NomeBrano"="Brano"."NomeBrano" AND "BranoEseguito"."Artista"="Brano"."Artista"
WHERE "GenereBrano"='Metal'
GROUP BY "GenereBrano"

/*6) Mostrare Indirizzo e Citta della sede con il maggior numero di spettatori in un singolo evento.*/
SELECT "Indirizzo", "Citta","NumSpettatori"
FROM "Evento"
JOIN "Sede" ON "Evento"."LuogoEvento"="Sede"."NomeSede"
WHERE "NumSpettatori"=(SELECT MAX("NumSpettatori") FROM "Evento")

/*7) Selezionare i docenti (è sufficiente CF) che insegnano dal 2010.*/
SELECT "CF"
FROM "Docente"
WHERE "InizioDocenza">='2010-01-01' AND "FineDocenza" IS NULL

/*8) Mostrare il nome di tutti gli eventi che NON sono saggi.*/
SELECT "NomeEvento"
FROM "Evento"
WHERE "TipoEvento"='N'

/*9) Contare tutte le occorrenze in cui la sede sia stata usata per evento (LuogoEvento).*/
SELECT "LuogoEvento", COUNT(*)
FROM "Evento"
GROUP BY "LuogoEvento"

/*10) Trovare per ogni brano (eseguito da qualunque artista) il numero di esecuzioni. Ordinare il risultato in ordine alfabetico.*/
SELECT "NomeBrano", COUNT(*) AS "NumEsecuzioni"
FROM "BranoEseguito"
GROUP BY "NomeBrano"
ORDER BY "NomeBrano"