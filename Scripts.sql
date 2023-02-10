-- ------------------------------------------ORIGINAL_LANGUAGE----------------------------------------------

USE movie_dataset;

DROP PROCEDURE IF EXISTS TablaOriginalLanguage;

DELIMITER $$
CREATE PROCEDURE TablaOriginalLanguage()
BEGIN

DECLARE done INT DEFAULT FALSE;
DECLARE nameOL VARCHAR(100);

 -- Declarar el cursor
DECLARE CursorOL CURSOR FOR
    SELECT DISTINCT `original_language` AS names from movie_dataset_crudo;
    
 -- Declarar el handler para NOT FOUND (esto es marcar cuando el cursor ha llegado a su fin)
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

 -- Abrir el cursor
OPEN CursorOL;
CursorOL_loop: LOOP
    FETCH CursorOL INTO nameOL;
    
-- Si alcanzo el final del cursor entonces salir del ciclo repetitivo
    IF done THEN
        LEAVE CursorOL_loop;
    END IF;
    IF nameOL IS NULL THEN
        SET nameOL = '';
    END IF;
    SET @_oStatement = CONCAT('INSERT INTO original_languageCURSOR (name) VALUES (\'',
	nameOL,'\');');
    PREPARE sent1 FROM @_oStatement;
    EXECUTE sent1;
    DEALLOCATE PREPARE sent1;

END LOOP;
CLOSE CursorOL;
END $$
DELIMITER ;



CALL TablaOriginalLanguage();

DROP TABLE IF EXISTS original_languageCURSOR;

CREATE TABLE original_languageCURSOR (
	name varchar(255) PRIMARY KEY
);

SELECT * FROM original_languageCURSOR;


-- ------------------------------------------STATUS----------------------------------------------

USE movie_dataset;

DROP PROCEDURE IF EXISTS TablaStatus;

DELIMITER $$
CREATE PROCEDURE TablaStatus()
BEGIN

DECLARE done INT DEFAULT FALSE;
DECLARE nameStatus VARCHAR(100);

 -- Declarar el cursor
DECLARE CursorStatus CURSOR FOR
    SELECT DISTINCT CONVERT(status USING UTF8MB4) AS names from movie_dataset_crudo;
    
 -- Declarar el handler para NOT FOUND (esto es marcar cuando el cursor ha llegado a su fin)
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

 -- Abrir el cursor
OPEN CursorStatus;
CursorStatus_loop: LOOP
    FETCH CursorStatus INTO nameStatus;
    
-- Si alcanzo el final del cursor entonces salir del ciclo repetitivo
    IF done THEN
        LEAVE CursorStatus_loop;
    END IF;
    IF nameStatus IS NULL THEN
        SET nameStatus = '';
    END IF;
    SET @_oStatement = CONCAT('INSERT INTO statusCURSOR (name) VALUES (\'',
	nameStatus,'\');');
    PREPARE sent1 FROM @_oStatement;
    EXECUTE sent1;
    DEALLOCATE PREPARE sent1;

END LOOP;
CLOSE CursorStatus;
END $$
DELIMITER ;

CALL TablaStatus();

DROP TABLE IF EXISTS statusCURSOR;

CREATE TABLE statusCURSOR (
	name varchar(255) PRIMARY KEY
);

SELECT * FROM statusCURSOR;


-- ------------------------------------MOVIE-----------------------------------------------

DROP PROCEDURE IF EXISTS TablaMovie;

DELIMITER $$
CREATE PROCEDURE TablaMovie()
BEGIN

DECLARE done INT DEFAULT FALSE;
DECLARE Movindex INT;
DECLARE Movbudget BIGINT;
DECLARE Movhomepage VARCHAR(1000);
DECLARE MovidMovie INT;
DECLARE Movkeywords TEXT;
DECLARE Movoriginal_language VARCHAR(255);
DECLARE Movoriginal_title VARCHAR(255) ;
DECLARE Movoverview TEXT;
DECLARE Movpopularity DOUBLE;
DECLARE Movrelease_date VARCHAR(255);
DECLARE Movrevenue BIGINT;
DECLARE Movruntime DOUBLE;
DECLARE Movstatus VARCHAR(255);
DECLARE Movtagline VARCHAR(255);
DECLARE Movtitle VARCHAR(255);
DECLARE Movvote_average DOUBLE;
DECLARE Movvote_count INT;
DECLARE nameDirector VARCHAR(255);

DECLARE Director_nameDirector varchar(255);
DECLARE Director_nameStatus varchar(255);
DECLARE Director_nameOriginal_language varchar(255);

 -- Declarar el cursor
DECLARE CursorMovie CURSOR FOR
    SELECT `index`,budget,homepage,id,keywords,original_language,original_title,overview,popularity,release_date,revenue,runtime, `status`,
		tagline,title,vote_average,vote_count,director FROM movie_dataset_crudo;
        
 -- Declarar el handler para NOT FOUND (esto es marcar cuando el cursor ha llegado a su fin)
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

 -- Abrir el cursor
OPEN CursorMovie;
CursorMovie_loop: LOOP
    FETCH CursorMovie INTO Movindex,Movbudget,Movhomepage,MovidMovie,Movkeywords,Movoriginal_language,Movoriginal_title,Movoverview,
    Movpopularity,Movrelease_date,Movrevenue,Movruntime,Movstatus,Movtagline,Movtitle,Movvote_average,Movvote_count,nameDirector;
    
    -- Si alcanzo el final del cursor entonces salir del ciclo repetitivo
    IF done THEN
        LEAVE CursorMovie_loop;
    END IF;
    IF nameDirector IS NULL THEN
    SET nameDirector = '';
    END IF;
    
    SELECT `name` INTO Director_nameDirector FROM directorCURSOR WHERE directorCURSOR.name = nameDirector;
    SELECT `name` INTO Director_nameStatus FROM statusCURSOR WHERE statusCURSOR.name = Movstatus;
    SELECT `name` INTO Director_nameOriginal_language FROM original_languageCURSOR WHERE original_languageCURSOR.name = Movoriginal_language;
    
    INSERT INTO MovieCURSOR (`index`,budget,homepage,id,keywords,original_language,original_title,overview,popularity,release_date,revenue,runtime, `status`,
		tagline,title,vote_average,vote_count,director)
    VALUES (Movindex,Movbudget,Movhomepage,MovidMovie,Movkeywords,Director_nameOriginal_language,Movoriginal_title,Movoverview,
    Movpopularity,Movrelease_date,Movrevenue,Movruntime,Director_nameStatus,Movtagline,Movtitle,Movvote_average,Movvote_count,Director_nameDirector);

END LOOP;
CLOSE CursorMovie;
END $$
DELIMITER ;

CALL TablaMovie ();

DROP TABLE IF EXISTS MovieCURSOR;

CREATE TABLE MovieCURSOR (
    `index` int,
    budget bigint,
    homepage varchar(1000),
    id int PRIMARY KEY,
    keywords TEXT,
    original_language varchar(255),
    original_title varchar(255),
    overview TEXT,
    popularity double,
    release_date varchar(255),
    revenue bigint,
    runtime double,
    `status` varchar(255),
    tagline varchar(255),
    title varchar(255),
    vote_average double,
    vote_count int,
    director varchar(255),
    FOREIGN KEY (original_language) REFERENCES original_languageCURSOR(name),
    FOREIGN KEY (status) REFERENCES statusCURSOR(name),
    FOREIGN KEY (director) REFERENCES directorCURSOR(name)
);

DROP TABLE IF EXISTS MovieCURSOR;

SELECT COUNT(*) FROM MovieCursor;
SELECT * FROM MovieCursor;




SELECT * FROM MovieCursor;

-- ------------------------------------PRODUCTION_COMPANIES-----------------------------------------------

USE movie_dataset;

DROP PROCEDURE IF EXISTS TablaMovie_production_companies;

DELIMITER $$
CREATE PROCEDURE TablaMovie_production_companies ()

BEGIN

 DECLARE done INT DEFAULT FALSE;
 DECLARE idMovie int;
 DECLARE idProdComp JSON;
 DECLARE idJSON text;
 DECLARE i INT;

 -- Declarar el cursor
 DECLARE myCursor
  CURSOR FOR
   SELECT id, production_companies FROM movie_dataset_crudo;

 -- Declarar el handler para NOT FOUND (esto es marcar cuando el cursor ha llegado a su fin)
 DECLARE CONTINUE HANDLER
  FOR NOT FOUND SET done = TRUE ;

 -- Abrir el cursor
 OPEN myCursor  ;

 drop table if exists MovieProdCompTemp;
    SET @sql_text = 'CREATE TABLE MovieProdCompTemp ( id int, idGenre int );';
    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

 cursorLoop: LOOP

     FETCH myCursor INTO idMovie, idProdComp;

  -- Controlador para buscar cada uno de los arrays
    SET i = 0;

  -- Si alcanzo el final del cursor entonces salir del ciclo repetitivo
  IF done THEN
   LEAVE  cursorLoop ;
  END IF ;

  WHILE(JSON_EXTRACT(idProdComp, CONCAT('$[', i, '].id')) IS NOT NULL) DO

  SET idJSON = JSON_EXTRACT(idProdComp,  CONCAT('$[', i, '].id')) ;
  SET i = i + 1;

  SET @sql_text = CONCAT('INSERT INTO MovieProdCompTemp VALUES (', idMovie, ', ', REPLACE(idJSON,'\'',''), '); ');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

  END WHILE;

 END LOOP ;

 select distinct * from MovieProdCompTemp;
    INSERT INTO Movie_production_companies
    SELECT DISTINCT id, idGenre
    FROM MovieProdCompTemp;
    drop table if exists MovieProdCompTemp;
 CLOSE myCursor ;

END$$
DELIMITER ;

call TablaMovie_production_companies();

-- ------------------------------------PRODUCTION_COMPANIES-----------------------------------------------

USE movie_dataset;

DROP PROCEDURE IF EXISTS TablaMovie_production_companies;

DELIMITER $$
CREATE PROCEDURE TablaMovie_production_companies ()

BEGIN

 DECLARE done INT DEFAULT FALSE;
 DECLARE idMovie int;
 DECLARE idProdComp JSON;
 DECLARE idJSON text;
 DECLARE i INT;

 -- Declarar el cursor
 DECLARE myCursor
  CURSOR FOR
   SELECT id, production_companies FROM movie_dataset_crudo;

 -- Declarar el handler para NOT FOUND (esto es marcar cuando el cursor ha llegado a su fin)
 DECLARE CONTINUE HANDLER
  FOR NOT FOUND SET done = TRUE ;

 -- Abrir el cursor
 OPEN myCursor  ;

 drop table if exists MovieProdCompTemp;
    SET @sql_text = 'CREATE TABLE MovieProdCompTemp ( id int, idGenre int );';
    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

 cursorLoop: LOOP

     FETCH myCursor INTO idMovie, idProdComp;

  -- Controlador para buscar cada uno de los arrays
    SET i = 0;

  -- Si alcanzo el final del cursor entonces salir del ciclo repetitivo
  IF done THEN
   LEAVE  cursorLoop ;
  END IF ;

  WHILE(JSON_EXTRACT(idProdComp, CONCAT('$[', i, '].id')) IS NOT NULL) DO

  SET idJSON = JSON_EXTRACT(idProdComp,  CONCAT('$[', i, '].id')) ;
  SET i = i + 1;

  SET @sql_text = CONCAT('INSERT INTO MovieProdCompTemp VALUES (', idMovie, ', ', REPLACE(idJSON,'\'',''), '); ');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

  END WHILE;

 END LOOP ;

 select distinct * from MovieProdCompTemp;
    INSERT INTO Movie_production_companies
    SELECT DISTINCT id, idGenre
    FROM MovieProdCompTemp;
    drop table if exists MovieProdCompTemp;
 CLOSE myCursor ;

END$$
DELIMITER ;

call TablaMovie_production_companies();

-- ------------------------------------PRODUCTION_COUNTRIES-----------------------------------------------

DROP PROCEDURE IF EXISTS TablaMovie_production_countries;

DELIMITER $$
CREATE PROCEDURE TablaMovie_production_countries ()

BEGIN

 DECLARE done INT DEFAULT FALSE;
 DECLARE idMovie int;
 DECLARE idProdCoun text;
 DECLARE idJSON text;
 DECLARE i INT;

 -- Declarar el cursor
 DECLARE myCursor
  CURSOR FOR
   SELECT id, production_countries FROM movie_dataset_crudo;

 -- Declarar el handler para NOT FOUND (esto es marcar cuando el cursor ha llegado a su fin)
 DECLARE CONTINUE HANDLER
  FOR NOT FOUND SET done = TRUE ;

 -- Abrir el cursor
 OPEN myCursor  ;

 drop table if exists MovieProdCompTemp;

    SET @sql_text = 'CREATE TABLE MovieProdCompTemp ( id int, idGenre varchar(255) );';
    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

 cursorLoop: LOOP

     FETCH myCursor INTO idMovie, idProdCoun;

  -- Controlador para buscar cada uno de los arrays
    SET i = 0;

  -- Si alcanzo el final del cursor entonces salir del ciclo repetitivo
  IF done THEN
   LEAVE  cursorLoop ;
  END IF ;

  WHILE(JSON_EXTRACT(idProdCoun, CONCAT('$[', i, '].iso_3166_1')) IS NOT NULL) DO

  SET idJSON = JSON_EXTRACT(idProdCoun,  CONCAT('$[', i, '].iso_3166_1')) ;
  SET i = i + 1;

  SET @sql_text = CONCAT('INSERT INTO MovieProdCompTemp VALUES (', idMovie, ', ', REPLACE(idJSON,'\'',''), '); ');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

  END WHILE;

 END LOOP ;

 select distinct * from MovieProdCompTemp;
    INSERT INTO Movie_production_countries
    SELECT DISTINCT id, idGenre
    FROM MovieProdCompTemp;
    drop table if exists MovieProdCompTemp;
 CLOSE myCursor ;

END$$
DELIMITER ;

call TablaMovie_production_countries();

-- ----------------------------------------------------CREW------------------------------------------------------------
-- Tabla Crew---
DROP PROCEDURE IF EXISTS TablaCrew;
DELIMITER $$
CREATE PROCEDURE TablaCrew ()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE idMovie int;
 DECLARE idCrew text;
 DECLARE idJSON text;
 DECLARE jobJSON text;
 DECLARE departmentJSON text;
 DECLARE credit_idJSON text;
 DECLARE i INT;
 -- Declarar el cursor
 DECLARE myCursor
  CURSOR FOR
   SELECT id, CONVERT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
       (REPLACE(crew, '"', '\''), '{\'', '{"'),
    '\': \'', '": "'),'\', \'', '", "'),'\': ', '": '),', \'', ', "')
    USING UTF8mb4 ) FROM movie_dataset_crudo;
 -- Declarar el handler para NOT FOUND (esto es marcar cuando el cursor ha llegado a su fin)
 DECLARE CONTINUE HANDLER
  FOR NOT FOUND SET done = TRUE ;
 -- Abrir el cursor
 OPEN myCursor  ;
 cursorLoop: LOOP
     FETCH myCursor INTO idMovie, idCrew;
  -- Controlador para buscar cada uno de los arrays
    SET i = 0;
  -- Si alcanzo el final del cursor entonces salir del ciclo repetitivo
  IF done THEN
   LEAVE  cursorLoop ;
  END IF ;
  WHILE(JSON_EXTRACT(idCrew, CONCAT('$[', i, '].id')) IS NOT NULL) DO
  SET jobJSON = JSON_EXTRACT(idCrew,  CONCAT('$[', i, '].job')) ;
  SET idJSON = JSON_EXTRACT(idCrew,  CONCAT('$[', i, '].id')) ;
  SET departmentJSON = JSON_EXTRACT(idCrew,  CONCAT('$[', i, '].department')) ;
  SET credit_idJSON = JSON_EXTRACT(idCrew,  CONCAT('$[', i, '].credit_id')) ;
  SET i = i + 1;
  SET @sql_text = CONCAT('INSERT Ignore INTO Crew VALUES (', idMovie, ', ',
      REPLACE(idJSON,'\'',''), ', ', REPLACE(idJSON,'\'',''), ', ',
      REPLACE(departmentJSON,'\'',''), ', ', REPLACE(credit_idJSON,'\'',''), '); ');
	PREPARE stmt FROM @sql_text;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
  END WHILE;
 END LOOP ;
 CLOSE myCursor ;
END$$
DELIMITER ;
call TablaCrew();

-- -------------------------------------------------------DIRECTOR-----------------------------------------------------

DROP PROCEDURE IF EXISTS TablaDirector;

DELIMITER $$
CREATE PROCEDURE TablaDirector()
BEGIN
DECLARE done INT DEFAULT FALSE ;
DECLARE idPersonas INT;
DECLARE Movid INT;
DECLARE MovDirector VARCHAR(100);

 -- Declarar el cursor
DECLARE CursorDirector CURSOR FOR
    SELECT id, director FROM movie_dataset;

 -- Declarar el handler para NOT FOUND (esto es marcar cuando el cursor ha llegado a su fin)
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

 -- Abrir el cursor
OPEN CursorDirector;
drop table if exists directorTemp;
    SET @sql_text = 'CREATE TABLE directorTemp ( idMov int, idPer int);';
    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

CursorMovie_loop: LOOP
    FETCH CursorDirector INTO Movid,MovDirector;

-- Si alcanzo el final del cursor entonces salir del ciclo repetitivo
    IF done THEN
        LEAVE CursorMovie_loop;
    END IF;

    SELECT idPerson INTO idPersonas FROM Persona WHERE Persona.name = MovDirector;
    INSERT INTO directorTemp VALUES (Movid, idPersonas);

    END LOOP;
CLOSE CursorDirector;
select distinct idMov,idPer from directorTemp;
INSERT  INTO Director
    SELECT DISTINCT  idMov,idPer
    FROM directorTemp;
drop table if exists directorTemp;
END $$
DELIMITER ;

CALL TablaDirector();