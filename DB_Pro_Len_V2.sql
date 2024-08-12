// Implementacion de usuario admin 
CREATE USER ADM IDENTIFIED BY adm;

GRANT SYSDBA TO ADM;
GRANT CONNECT TO ADM;
GRANT RESOURCE TO ADM;
ALTER USER ADM QUOTA UNLIMITED ON USERS;
GRANT UNLIMITED TABLESPACE TO ADM;

ALTER USER ADM QUOTA UNLIMITED ON USERS;

//cod  100





CREATE TABLE CENTRO_COSTOS(
    ID_CentroCosto number,
    Nombre varchar2(20));
// agregar el constraint
ALTER TABLE CENTRO_COSTOS ADD CONSTRAINT CC_PK PRIMARY KEY (ID_CentroCosto);

//cod 200
CREATE TABLE PRESUPUESTO (
    ID_Presupuesto varchar(100) DEFAULT TO_CHAR(seq_presupuesto.NEXTVAL),
    ID_CentroCosto number,
    saldoComprometido number,
    inicioPeriodo date,
    finPeriodo date,
    Total number
);

ALTER TABLE PRESUPUESTO ADD CONSTRAINT PR_PK PRIMARY KEY(ID_Presupuesto);
ALTER TABLE PRESUPUESTO ADD CONSTRAINT CCFK_fK FOREIGN KEY(ID_CentroCosto) REFERENCES CENTRO_COSTOS(ID_CentroCosto);

//300
Create table RUBROS (
    ID_Rubro varchar2(100) DEFAULT TO_CHAR(seq_rubro.NEXTVAL),
    Descripcion varchar2(20),
    Monto number);
//agregar constraint
ALTER TABLE RUBROS ADD CONSTRAINT RU_PK PRIMARY KEY (ID_Rubro);


//400
CREATE TABLE DESGLOSE_MENSUAL_PRESUPUESTO(
    ID_DesgloseMensual number DEFAULT seq_desglose_mensual.NEXTVAL,
    ID_Pesupuesto varchar2(3),
    PresupuestoAsignado number,
    ID_Rubro varchar2(5),
    Mes date,
    Total number,
    PresupuestoActual number);
//agregar constraints    
ALTER TABLE  DESGLOSE_MENSUAL_PRESUPUESTO ADD CONSTRAINT DM_PK PRIMARY KEY (ID_DesgloseMensual);
ALTER TABLE DESGLOSE_MENSUAL_PRESUPUESTO ADD CONSTRAINT PRE_FK FOREIGN KEY (ID_Pesupuesto) REFERENCES PRESUPUESTO (ID_Presupuesto);
ALTER TABLE DESGLOSE_MENSUAL_PRESUPUESTO ADD CONSTRAINT RUB_FK FOREIGN KEY (ID_Rubro) REFERENCES RUBROS (ID_Rubro);
    
//500   
CREATE TABLE COMPRA(
    Cod_Compra number DEFAULT seq_compra.NEXTVAL,
    ID_Permiso number,
    Fecha date,
    monto number);

//agregar constraint     

ALTER TABLE COMPRA ADD CONSTRAINT CO_PK PRIMARY KEY (Cod_Compra);
ALTER TABLE COMPRA ADD CONSTRAINT IDPermiso_FK FOREIGN KEY(ID_Permiso) references CENTRO_COSTOS(ID_CentroCosto);

//600
CREATE TABLE PERMISOS_COMPRA(
    ID_Permiso NUMBER DEFAULT seq_permiso.NEXTVAL,
    ID_CentroCosto number,
    ID_Rubro varchar2(3),
    Cod_Compa number,
    cantidad number,
    monto number,
    fecha date,
    Estado varchar2(4));
//agregar constraint
ALTER TABLE PERMISOS_COMPRA ADD CONSTRAINT PC_PK PRIMARY KEY (ID_Permiso);
ALTER TABLE PERMISOS_COMPRA ADD CONSTRAINT RUPC_FK FOREIGN KEY (ID_Rubro) REFERENCES RUBROS (ID_Rubro);



CREATE TABLE USUARIOS (
    ID_USER NUMBER,
    USER_NAME VARCHAR2(20),
    PASS VARCHAR2(12),
    ROL VARCHAR2(10),
    ID_CentroCosto number
);

ALTER TABLE USUARIOS ADD CONSTRAINT US_PK PRIMARY KEY (ID_USER);
ALTER TABLE USUARIOS ADD CONSTRAINT ID_CC_FK FOREIGN KEY (ID_CentroCosto) REFERENCES CENTRO_COSTOS (ID_CentroCosto);

---------------------------------------------------------------------------------------------------------------------------
-- Secuencias en funcion de (AutoIncrement) para los ID de las tablas
CREATE SEQUENCE usuario_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_centro_costo START WITH 101 INCREMENT BY 1;
CREATE SEQUENCE seq_presupuesto START WITH 201 INCREMENT BY 1;

CREATE SEQUENCE seq_rubro START WITH 301 INCREMENT BY 1;
CREATE SEQUENCE seq_desglose_mensual START WITH 401 INCREMENT BY 1;
CREATE SEQUENCE seq_compra START WITH 501 INCREMENT BY 1;
CREATE SEQUENCE seq_permiso START WITH 601 INCREMENT BY 1;

// Funciones

//Funcion de insertar centro de compras y presupuesto

SET SERVEROUTPUT ON;



-------------------------------------------------------------------

//Vistas

//Vista que muestra los centors de costo con los presupuestos

CREATE VIEW VISTA_CENTROS_CON_PRESUPUESTOS AS
SELECT 
    C.Nombre AS Nombre_CentroCosto,
    P.saldoComprometido,
    P.inicioPeriodo AS InicioPeriodo,
    P.finPeriodo AS FinPeriodo,
    P.Total AS Monto_de_Presupuesto
FROM CENTRO_COSTOS C
JOIN PRESUPUESTO P
ON CC.ID_CentroCosto = P.ID_CentroCosto;

//Vista de Rubros
    
CREATE VIEW VISTA_RUBROS_SIN_ID AS
SELECT
    Descripcion,
    Monto
FROM RUBROS;

//Permisos de compra 

CREATE VIEW VISTA_PERMISOS_COMPRA_SIN_ID AS
SELECT
    ID_CentroCosto,
    ID_Rubro,
    Cod_Compa,
    cantidad,
    monto,
    fecha,
    Estado
FROM PERMISOS_COMPRA;

// Vistas de Compra

CREATE VIEW VISTA_COMPRAS_SIN_ID AS
SELECT
    ID_Permiso,
    Fecha,
    monto
FROM COMPRA;

// Vistas de Presupuestos

CREATE VIEW VISTA_PRESUPUESTOS_SIN_ID AS
SELECT
    ID_CentroCosto,
    saldoComprometido,
    inicioPeriodo,
    finPeriodo,
    Total
FROM PRESUPUESTO;






-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION crear_centro_costo_y_presupuesto(
    p_nombre_centro_costo IN VARCHAR2,
    p_inicio_periodo IN DATE,
    p_fin_periodo IN DATE,
    p_total IN NUMBER
) RETURN VARCHAR2 IS
    v_id_centro_costo NUMBER;
    v_id_presupuesto VARCHAR2(100);
    v_mensaje VARCHAR2(100);
BEGIN
    -- Verificar si el centro de costo ya existe
    BEGIN
        SELECT ID_CentroCosto INTO v_id_centro_costo
        FROM CENTRO_COSTOS
        WHERE Nombre = p_nombre_centro_costo;
        
        v_mensaje := 'El centro de costo ya existe.';
        RETURN v_mensaje;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Crear un nuevo centro de costo
            v_id_centro_costo := seq_centro_costo.NEXTVAL;
            INSERT INTO CENTRO_COSTOS (ID_CentroCosto, Nombre) VALUES (v_id_centro_costo, p_nombre_centro_costo);
            
            -- Crear un nuevo presupuesto relacionado al centro de costo
            v_id_presupuesto := TO_CHAR(seq_presupuesto.NEXTVAL);
            INSERT INTO PRESUPUESTO (ID_Presupuesto, ID_CentroCosto, saldoComprometido, inicioPeriodo, finPeriodo, Total) 
            VALUES (v_id_presupuesto, v_id_centro_costo, 0, p_inicio_periodo, p_fin_periodo, p_total);
            
            v_mensaje := 'Centro de costo y presupuesto creado con éxito.';
            RETURN v_mensaje;
    END;
END;


    
DECLARE
    v_mensaje VARCHAR2(100);
BEGIN
    v_mensaje := crear_centro_costo_y_presupuesto('HHRR', DATE '2022-01-01', DATE '2022-01-31', 1000);
    DBMS_OUTPUT.PUT_LINE(v_mensaje);
END;



CREATE OR REPLACE FUNCTION insertar_usuario (
    p_user IN VARCHAR2,
    p_pass IN VARCHAR2,
    p_rol IN VARCHAR2,
    p_id_centroCosto IN NUMBER
) RETURN VARCHAR2
AS
    v_count NUMBER;
BEGIN
    -- Verificar si el usuario ya existe
    SELECT COUNT(*)
    INTO v_count
    FROM USUARIOS
    WHERE USER_NAME = p_user;

    -- Si el usuario no existe, proceder a insertar
    IF v_count = 0 THEN
        INSERT INTO USUARIOS (ID_USER, USER_NAME, PASS, ROL, ID_CentroCosto)
        VALUES (usuario_seq.NEXTVAL, p_user, p_pass, p_rol, p_id_centroCosto);

        RETURN 'Usuario insertado correctamente';
    ELSE
        RETURN 'El usuario ya existe';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al insertar el usuario';
END;
 
 
CREATE TYPE usuario AS OBJECT (
  id_user NUMBER,
  user_name VARCHAR2(50),
  pass VARCHAR2(50),
  rol VARCHAR2(50),
  id_centro_costo NUMBER,
  centro_costo_nombre VARCHAR2(100)
);

 
 
CREATE OR REPLACE FUNCTION validar_usuario(p_user IN VARCHAR2, p_pass IN VARCHAR2)
  RETURN NUMBER
AS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM USUARIOS
  WHERE USER_NAME = p_user AND PASS = p_pass;
  
  IF v_count = 1 THEN
    RETURN 1; -- usuario y contraseña válidos
  ELSE
    RETURN 0; -- usuario y contraseña no válidos
  END IF;
END




