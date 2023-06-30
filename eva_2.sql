-- Creación de la base de datos 'ProcesoSeleccion'
CREATE DATABASE ProcesoSeleccion;

-- Uso de la base de datos 'ProcesoSeleccion'
ALTER SESSION SET CURRENT_SCHEMA = ProcesoSeleccion;

-- Creación de la tabla 'Postulante'
CREATE TABLE Postulante (
    ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100),
    Apellido VARCHAR2(100),
    Nacionalidad VARCHAR2(100),
    ResidenciaDefinitiva NUMBER(1),
    FechaReconocimientoTitulo DATE,
    FechaRevalidacionTitulo DATE,
    CONSTRAINT Postulante_chk_1 CHECK ((Nacionalidad = 'Chilena') OR (Nacionalidad != 'Chilena' AND ResidenciaDefinitiva = 1))
);

-- Creación de la tabla 'TituloMedico'
CREATE TABLE TituloMedico (
    ID NUMBER PRIMARY KEY,
    PostulanteID NUMBER,
    Universidad VARCHAR2(100),
    CalificacionMediaNacional NUMBER(3, 1),
    CONSTRAINT FK_TituloMedico_Postulante FOREIGN KEY (PostulanteID) REFERENCES Postulante(ID)
);

-- Creación de la tabla 'ExamenMedicina'
CREATE TABLE ExamenMedicina (
    ID NUMBER PRIMARY KEY,
    PostulanteID NUMBER,
    FechaAprobacion DATE,
    CONSTRAINT FK_ExamenMedicina_Postulante FOREIGN KEY (PostulanteID) REFERENCES Postulante(ID)
);

-- Creación de la tabla 'ExperienciaLaboral'
CREATE TABLE ExperienciaLaboral (
    ID NUMBER PRIMARY KEY,
    PostulanteID NUMBER,
    ServicioSalud VARCHAR2(100),
    Establecimiento VARCHAR2(100),
    FechaInicio DATE,
    FechaFin DATE,
    CONSTRAINT FK_ExperienciaLaboral_Postulante FOREIGN KEY (PostulanteID) REFERENCES Postulante(ID)
);

-- Creación de la tabla 'Especialidad'
CREATE TABLE Especialidad (
    ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100),
    CONSTRAINT UQ_Especialidad_Nombre UNIQUE (Nombre)
);

-- Creación de la tabla 'Institucion'
CREATE TABLE Institucion (
    ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100),
    Pais VARCHAR2(100)
);

-- Creación de la tabla 'PostulacionEspecialidad'
CREATE TABLE PostulacionEspecialidad (
    ID NUMBER PRIMARY KEY,
    PostulanteID NUMBER,
    EspecialidadID NUMBER,
    InstitucionID NUMBER,
    FOREIGN KEY (PostulanteID) REFERENCES Postulante(ID),
    FOREIGN KEY (EspecialidadID) REFERENCES Especialidad(ID),
    FOREIGN KEY (InstitucionID) REFERENCES Institucion(ID)
);

-- Creación de la tabla 'FormularioPostulacion'
CREATE TABLE FormularioPostulacion (
    ID NUMBER PRIMARY KEY,
    PostulacionEspecialidadID NUMBER,
    Folio NUMBER,
    FechaRecepcion DATE,
    IdentificacionDesempenoID NUMBER,
    IdentificacionPersonalID NUMBER,
    FOREIGN KEY (PostulacionEspecialidadID) REFERENCES PostulacionEspecialidad(ID)
);

-- Creación de la tabla 'IdentificacionDesempeno'
CREATE TABLE IdentificacionDesempeno (
    ID NUMBER PRIMARY KEY,
    FormularioPostulacionID NUMBER,
    ServicioSaludMunicipalidad VARCHAR2(100),
    Establecimiento VARCHAR2(100),
    DireccionInstitucional VARCHAR2(100),
    CorreoInstitucional VARCHAR2(100),
    ContratoVigente VARCHAR2(20),
    CONSTRAINT FK_IdentificacionDesempeno_FormularioPostulacion FOREIGN KEY (FormularioPostulacionID) REFERENCES FormularioPostulacion(ID)
);

-- Creación de la tabla 'IdentificacionPersonal'
CREATE TABLE IdentificacionPersonal (
    ID NUMBER PRIMARY KEY,
    FormularioPostulacionID NUMBER,
    Nombre VARCHAR2(100),
    Apellido VARCHAR2(100),
    Rut VARCHAR2(20),
    FechaNacimiento DATE,
    Genero VARCHAR2(20),
    CONSTRAINT FK_IdentificacionPersonal_FormularioPostulacion FOREIGN KEY (FormularioPostulacionID) REFERENCES FormularioPostulacion(ID)
);

-- Creación de la tabla 'CriterioEvaluacion'
CREATE TABLE CriterioEvaluacion (
    ID NUMBER PRIMARY KEY,
    NombreCriterio VARCHAR2(100),
    Peso NUMBER(3, 2),
    CONSTRAINT CK_CriterioEvaluacion_Peso CHECK (Peso >= 0 AND Peso <= 1)
);

-- Creación de la tabla 'EvaluacionPostulante'
CREATE TABLE EvaluacionPostulante (
    ID NUMBER PRIMARY KEY,
    PostulacionEspecialidadID NUMBER,
    CriterioEvaluacionID NUMBER,
    Puntaje NUMBER(3, 1),
    CONSTRAINT FK_EvaluacionPostulante_PostulacionEspecialidad FOREIGN KEY (PostulacionEspecialidadID) REFERENCES PostulacionEspecialidad(ID),
    CONSTRAINT FK_EvaluacionPostulante_CriterioEvaluacion FOREIGN KEY (CriterioEvaluacionID) REFERENCES CriterioEvaluacion(ID),
    CONSTRAINT CK_EvaluacionPostulante_Puntaje CHECK (Puntaje >= 0 AND Puntaje <= 100)
);

-- Creación de la tabla 'AsignacionEspecialidad'
CREATE TABLE AsignacionEspecialidad (
    ID NUMBER PRIMARY KEY,
    PostulacionEspecialidadID NUMBER,
    EspecialidadAsignada VARCHAR2(100),
    InstitucionAsignada VARCHAR2(100),
    PaisInstitucion VARCHAR2(50),
    FechaAsignacion DATE,
    FOREIGN KEY (PostulacionEspecialidadID) REFERENCES PostulacionEspecialidad(ID)
);
