-- Creamos las secuencias para los campos auto_increment en Oracle
CREATE SEQUENCE fabricante_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE motor_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE chasis_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ruedas_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE automovil_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE socio_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE reserva_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE aval_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE arriendo_seq START WITH 1 INCREMENT BY 1;

-- Creamos las tablas
CREATE TABLE Fabricante (
  id INT PRIMARY KEY DEFAULT fabricante_seq.NEXTVAL,
  nombre VARCHAR2(100) NOT NULL,
  ano_produccion DATE NOT NULL
);

CREATE TABLE Motor (
  id INT PRIMARY KEY DEFAULT motor_seq.NEXTVAL,
  fabricante_id INT NOT NULL,
  ano_produccion DATE NOT NULL,
  FOREIGN KEY (fabricante_id) REFERENCES Fabricante(id)
);

CREATE TABLE Chasis (
  id INT PRIMARY KEY DEFAULT chasis_seq.NEXTVAL,
  fabricante_id INT NOT NULL,
  ano_produccion DATE NOT NULL,
  FOREIGN KEY (fabricante_id) REFERENCES Fabricante(id)
);

CREATE TABLE Ruedas (
  id INT PRIMARY KEY DEFAULT ruedas_seq.NEXTVAL,
  fabricante_id INT NOT NULL,
  ano_produccion DATE NOT NULL,
  FOREIGN KEY (fabricante_id) REFERENCES Fabricante(id)
);

CREATE TABLE Automovil (
  id INT PRIMARY KEY DEFAULT automovil_seq.NEXTVAL,
  motor_id INT NOT NULL,
  chasis_id INT NOT NULL,
  ruedas_id INT NOT NULL,
  marca VARCHAR2(100) NOT NULL,
  patente VARCHAR2(10) NOT NULL,
  ano DATE NOT NULL,
  FOREIGN KEY (motor_id) REFERENCES Motor(id),
  FOREIGN KEY (chasis_id) REFERENCES Chasis(id),
  FOREIGN KEY (ruedas_id) REFERENCES Ruedas(id)
);

CREATE TABLE Socio (
  id INT NOT NULL PRIMARY KEY DEFAULT socio_seq.NEXTVAL,
  rut VARCHAR2(14),
  nombre VARCHAR2(100) NOT NULL,
  domicilio VARCHAR2(200) NOT NULL
);

CREATE TABLE Reserva (
  id INT NOT NULL PRIMARY KEY DEFAULT reserva_seq.NEXTVAL,
  socio_rut VARCHAR2(14),
  fecha_reserva DATE,
  FOREIGN KEY (socio_rut) REFERENCES Socio(rut)
);

CREATE TABLE Aval (
  id INT NOT NULL PRIMARY KEY DEFAULT aval_seq.NEXTVAL,
  socio_rut VARCHAR2(14),
  aval_rut VARCHAR2(14),
  FOREIGN KEY (socio_rut) REFERENCES Socio(rut),
  FOREIGN KEY (aval_rut) REFERENCES Socio(rut)
);

CREATE TABLE Arriendo (
  id INT NOT NULL PRIMARY KEY DEFAULT arriendo_seq.NEXTVAL,
  socio_rut VARCHAR2(14),
  automovil_id INT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_final DATE NOT NULL,
  FOREIGN KEY (socio_rut) REFERENCES Socio(rut),
  FOREIGN KEY (automovil_id) REFERENCES Automovil(id)
);

-- Creamos los triggers
CREATE OR REPLACE TRIGGER validar_formato_rut_socio
BEFORE INSERT ON Socio
FOR EACH ROW
BEGIN
  IF NOT REGEXP_LIKE(:NEW.rut, '^[0-9]{1,8}-[0-9Kk]$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'El formato del "rut" en la tabla Socio debe ser: 19999999-9');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER validar_formato_rut_reserva
BEFORE INSERT ON Reserva
FOR EACH ROW
BEGIN
  IF NOT REGEXP_LIKE(:NEW.socio_rut, '^[0-9]{1,8}-[0-9Kk]$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'El formato del "rut" en la tabla Reserva debe ser: 19999999-9');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER validar_formato_rut_aval
BEFORE INSERT ON Aval
FOR EACH ROW
BEGIN
  IF NOT REGEXP_LIKE(:NEW.socio_rut, '^[0-9]{1,8}-[0-9Kk]$') OR NOT REGEXP_LIKE(:NEW.aval_rut, '^[0-9]{1,8}-[0-9Kk]$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'El formato del "rut" en la tabla Aval debe ser: 19999999-9');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER validar_formato_rut_arriendo
BEFORE INSERT ON Arriendo
FOR EACH ROW
BEGIN
  IF NOT REGEXP_LIKE(:NEW.socio_rut, '^[0-9]{1,8}-[0-9Kk]$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'El formato del "rut" en la tabla Arriendo debe ser: 19999999-9');
  END IF;
END;
/
