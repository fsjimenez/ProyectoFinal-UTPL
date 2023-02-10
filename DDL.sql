#------------------------------------------------------------------------------------
DROP DATABASE IF EXISTS movie_dataset;
CREATE DATABASE movie_dataset CHARACTER SET utf8mb4;
USE movie_dataset;
#--------------------------------------ENTIDADES-----------------------------
DROP TABLE IF EXISTS original_language;
CREATE TABLE original_language(
    idOringLang INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name_original_language VARCHAR(2) NOT NULL
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Status;
CREATE TABLE Status(
    idStatus INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nameStatus VARCHAR(15) NOT NULL
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Movie;
CREATE TABLE Movie(
    idMovie INT PRIMARY KEY NOT NULL,
    `index` INT NOT NULL ,
    budget BIGINT NOT NULL,
    homepage VARCHAR(255),
    keywords VARCHAR(255),
    idOrigLang INT NOT NULL,
    original_title VARCHAR(255) NOT NULL,
    overview TEXT,
    popularity DOUBLE NOT NULL,
    release_date DATE,
    revenue BIGINT NOT NULL,
    runtime DOUBLE,
    idStatus INT NOT NULL,
    tagline VARCHAR(255),
    title VARCHAR(255) NOT NULL,
    vote_average DOUBLE NOT NULL,
    vote_count INT NOT NULL,
    FOREIGN KEY (idOrigLang) REFERENCES original_language(idOringLang),
    FOREIGN KEY (idStatus) REFERENCES `Status`(idStatus)
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Genre;
CREATE TABLE Genre(
    nameGenre VARCHAR(100) PRIMARY KEY NOT NULL
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS production_countries;
CREATE TABLE production_countries(
    iso_3166_1 VARCHAR(10) PRIMARY KEY NOT NULL,
    pCountryName VARCHAR(255) NOT NULL
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS production_companies;
CREATE TABLE production_companies(
    pCompanyId INT PRIMARY KEY NOT NULL,
    pCountryName VARCHAR(255) NOT NULL
);

#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS spoken_language;
CREATE TABLE spoken_language(
    iso_639_1 VARCHAR(2) PRIMARY KEY NOT NULL,
    nameSLang VARCHAR(255) NOT NULL
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Persona;
CREATE TABLE Persona(
    idCrew INT PRIMARY KEY NOT NULL,
    name VARCHAR(255) NOT NULL,
    gender INT
);

#---------------------------------RELACIONES----------------------------------------
DROP TABLE IF EXISTS Movie_genres;
CREATE TABLE Movie_genres(
    idMovie INT NOT NULL,
    nameGenre VARCHAR(100) NOT NULL,
    PRIMARY KEY (idMovie, nameGenre),
    FOREIGN KEY (idMovie) REFERENCES Movie(idMovie),
    FOREIGN KEY (nameGenre) REFERENCES Genre(nameGenre)
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Movie_production_countries;
CREATE TABLE Movie_production_countries(
    idMovie INT NOT NULL,
    iso_3166_1 VARCHAR(255) NOT NULL,
    PRIMARY KEY (idMovie, iso_3166_1),
    FOREIGN KEY (idMovie) REFERENCES Movie(idMovie),
    FOREIGN KEY (iso_3166_1) REFERENCES production_countries(iso_3166_1)
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Movie_production_companies;
CREATE TABLE Movie_production_companies(
    idMovie INT NOT NULL,
    pCompanyId INT NOT NULL,
    PRIMARY KEY (idMovie, pCompanyId),
    FOREIGN KEY (idMovie) REFERENCES Movie(idMovie),
    FOREIGN KEY (pCompanyId) REFERENCES production_companies(pCompanyId)
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Movie_spoken_languages;
CREATE TABLE Movie_spoken_languages(
    idMovie INT NOT NULL,
    iso_639_1 VARCHAR(2) NOT NULL,
    PRIMARY KEY (idMovie, iso_639_1),
    FOREIGN KEY (idMovie) REFERENCES Movie(idMovie),
    FOREIGN KEY (iso_639_1) REFERENCES spoken_language(iso_639_1)
);
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Person;
CREATE TABLE Person(
    idPerson INT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    gender int NOT NULL
    );
    
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Cast;
CREATE TABLE `Cast`(
    idPerson INT NOT NULL,
    idMovie INT NOT NULL,
    FOREIGN KEY (idMovie) REFERENCES Movie(idMovie),
    FOREIGN KEY (idPerson) REFERENCES Person(idPerson)
    );
    
    #------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Director;
CREATE TABLE Director(
    idPerson INT NOT NULL,
    idMovie INT NOT NULL,
    FOREIGN KEY (idMovie) REFERENCES Movie(idMovie),
    FOREIGN KEY (idPerson) REFERENCES Person(idPerson)
    );
#------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Crew;
CREATE TABLE Crew(
    idPerson INT NOT NULL,
    idMovie INT NOT NULL,
    job VARCHAR(255) NOT NULL,
    department VARCHAR(255),
    credit_id VARCHAR(255),
    PRIMARY KEY (job),
    FOREIGN KEY (idMovie) REFERENCES Movie(idMovie),
    FOREIGN KEY (idCrew) REFERENCES Persona(idCrew)
);
         

         
         