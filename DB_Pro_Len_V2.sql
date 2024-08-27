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
    ID_Usuario number,
    ID_RUBRO VARCHAR2(100),
    Cantidad number,
    monto number);

//agregar constraint     

ALTER TABLE COMPRA ADD CONSTRAINT CO_PK PRIMARY KEY (Cod_Compra);
alter table compra add conStraint fk_RUB FOREIGN KEY (ID_RUBRO) REFERENCES RUBROS (ID_RUBRO);
alter table compra add conStraint fk_USE FOREIGN KEY (ID_Usuario) REFERENCES USUARIOS (ID_USER);

//600
CREATE TABLE PERMISOS_COMPRA(
    ID_Permiso NUMBER DEFAULT seq_permiso.NEXTVAL,
    ID_CENTRO NUMBER,
    Cod_Compa number,
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


SELECT * FROM PRESUPUESTO;
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
    v_sql VARCHAR2(4000);
BEGIN
    
    v_sql := 'SELECT ID_CentroCosto FROM CENTRO_COSTOS WHERE Nombre = :nombre_centro_costo';
    BEGIN
        EXECUTE IMMEDIATE v_sql INTO v_id_centro_costo USING p_nombre_centro_costo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            v_sql := 'INSERT INTO CENTRO_COSTOS (ID_CentroCosto, Nombre) VALUES (seq_centro_costo.NEXTVAL, :nombre_centro_costo) RETURNING ID_CentroCosto INTO :id_centro_costo';
            EXECUTE IMMEDIATE v_sql USING p_nombre_centro_costo, OUT v_id_centro_costo;
            
           
            v_sql := 'INSERT INTO PRESUPUESTO (ID_Presupuesto, ID_CentroCosto, saldo_Comprometido, inicio_Periodo, fin_Periodo, Total) VALUES (TO_CHAR(seq_presupuesto.NEXTVAL), :id_centro_costo, 0, :inicio_periodo, :fin_periodo, :total)';
            EXECUTE IMMEDIATE v_sql USING v_id_centro_costo, p_inicio_periodo, p_fin_periodo, p_total;
            
            v_mensaje := 'Centro de costo y presupuesto creado con éxito.';
            RETURN v_mensaje;
    END;
    
    IF v_id_centro_costo IS NOT NULL THEN
        v_mensaje := 'El centro de costo ya existe.';
        RETURN v_mensaje;
    END IF;
END;

CREATE OR REPLACE FUNCTION insertar_usuario (
    p_user IN VARCHAR2,
    p_pass IN VARCHAR2,
    p_rol IN VARCHAR2,
    p_id_centroCosto IN NUMBER
) RETURN VARCHAR2
AS
    v_sql VARCHAR2(4000);
    v_count NUMBER;
BEGIN
    v_sql := 'SELECT COUNT(*) FROM USUARIOS WHERE USER_NAME = :p_user';
    EXECUTE IMMEDIATE v_sql INTO v_count USING p_user;

    IF v_count = 0 THEN
        v_sql := 'INSERT INTO USUARIOS (ID_USER, USER_NAME, PASS, ROL, ID_CentroCosto) VALUES (usuario_seq.NEXTVAL, :p_user, :p_pass, :p_rol, :p_id_centroCosto)';
        EXECUTE IMMEDIATE v_sql USING p_user, p_pass, p_rol, p_id_centroCosto;

        RETURN 'Usuario insertado correctamente';
    ELSE
        RETURN 'El usuario ya existe';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error al insertar el usuario';
END;


CREATE OR REPLACE FUNCTION obtener_datos_Centro(
    p_id_centro IN NUMBER
) 
RETURN PRESUPUESTO%ROWTYPE
IS
    v_sql VARCHAR2(4000);
    Resultado PRESUPUESTO%ROWTYPE;
BEGIN
    v_sql := 'SELECT ID_Presupuesto, ID_CENTROCOSTO, Total, inicio_Periodo, fin_Periodo, saldo_Comprometido, ID_CENTRO_COSTO

           FROM 
              PRESUPUESTO 
           WHERE 
              ID_CENTROCOSTO = :p_id_centro';
    BEGIN 
        EXECUTE IMMEDIATE v_sql INTO Resultado USING p_id_centro;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No se encontraron datos para el centro de costo ' || p_id_centro);
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al obtener datos del centro de costo: ' || SQLERRM);
    END; 
    RETURN Resultado;
END;

CREATE OR REPLACE FUNCTION validar_usuario(p_user IN VARCHAR2, p_pass IN VARCHAR2)
  RETURN NUMBER
AS
  v_sql VARCHAR2(4000);
  v_count NUMBER;
BEGIN
  v_sql := 'SELECT COUNT(*) FROM USUARIOS WHERE USER_NAME = :p_user AND PASS = :p_pass';
  EXECUTE IMMEDIATE v_sql INTO v_count USING p_user, p_pass;
  
  IF v_count = 1 THEN
    RETURN 1; 
  ELSE
    RETURN 0; 
  END IF;
END;

CREATE OR REPLACE FUNCTION FN_DATOS_USUARIO(V_user IN NUMBER)
  RETURN USUARIOS%ROWTYPE
AS
  v_usuario USUARIOS%ROWTYPE;
BEGIN
  SELECT ID_USER ,USER_NAME, ROL,PASS, ID_CENTROCOSTO INTO v_usuario
  FROM USUARIOS
  WHERE ID_USER = V_user;
  RETURN v_usuario;
END;

CREATE OR REPLACE FUNCTION verificar_presupuesto(
    p_id_presupuesto IN VARCHAR2,
    p_valor IN NUMBER
) RETURN VARCHAR2 IS
    v_total NUMBER;
    v_saldo_comprometido NUMBER;
    resultado VARCHAR2(120);
BEGIN

    SELECT Total, saldo_Comprometido
    INTO v_total, v_saldo_comprometido
    FROM PRESUPUESTO
    WHERE ID_CENTROCOSTO = p_id_presupuesto;
    IF v_total > 0 THEN
        IF p_valor <= v_total THEN
            resultado := 'ACEPTADO';
        ELSE
            resultado := 'EXCEDIDO';
        END IF;
    ELSE
        IF v_saldo_comprometido < 0 THEN
            resultado := 'DENEGADO';
        ELSE
            resultado := 'EXCEDIDO';
        END IF;
    END IF; 
    RETURN resultado;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        resultado := 'PRESUPUESTO NO ENCONTRADO';
        RETURN resultado;
    WHEN OTHERS THEN
        RETURN 'ERROR';
    RETURN resultado;
END;

CREATE OR REPLACE FUNCTION FN_INFO_RUBRO(ID_RUBRO VARCHAR2)
RETURN RUBROS%ROWTYPE
AS
    v_sql VARCHAR2(4000);
    Resultado RUBROS%ROWTYPE;
    v_id_rubro RUBROS.ID_RUBRO%TYPE := ID_RUBRO;
BEGIN
    v_sql := 'SELECT ID_RUBRO, DESCRIPCIÓN, MONTO FROM RUBROS WHERE ID_RUBRO = :ID_RUBRO';
    
    BEGIN 
         EXECUTE IMMEDIATE v_sql INTO Resultado USING v_id_rubro;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No se encontraron datos para el RUBRO ' || ID_RUBRO);
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al obtener datos del RUBRO: ' || SQLERRM);
    END;
   
    RETURN Resultado;
END;
-----------------------

CREATE OR REPLACE FUNCTION FN_INFO_COMPRA(COD IN NUMBER)
RETURN COMPRA%ROWTYPE
AS
    v_sql VARCHAR2(4000);
    RESULTADO COMPRA%ROWTYPE;
BEGIN 
    V_SQL := 'SELECT COD_COMPRA, CANTIDAD, MONTO, ID_RUBRO, ID_USUARIO FROM COMPRA WHERE COD_COMPRA = :COD';
    
    EXECUTE IMMEDIATE V_SQL 
        INTO RESULTADO.COD_COMPRA, RESULTADO.CANTIDAD, RESULTADO.MONTO, RESULTADO.ID_RUBRO, RESULTADO.ID_USUARIO 
        USING COD;
    
    RETURN RESULTADO;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se encontraron datos de la compra ' || COD);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error al obtener datos de la compra: ' || SQLERRM);
END;

CREATE OR REPLACE PROCEDURE sp_insert_rubro(
    p_descripción IN RUBROS.descripción%TYPE,
    p_monto IN RUBROS.monto%TYPE,
    p_mensaje OUT VARCHAR2
) AS
    v_sql VARCHAR2(200);
    v_count NUMBER;
    v_id_rubro RUBROS.id_rubro%TYPE;
BEGIN
    v_sql := 'SELECT COUNT(*) FROM RUBROS WHERE Descripción = :p_descripción';
    EXECUTE IMMEDIATE v_sql INTO v_count USING p_descripción;

    IF v_count > 0 THEN
        p_mensaje := 'No se puede agregar, la descripción ya existe';
    ELSE
        v_id_rubro := SEQ_RUBRO.NEXTVAL;
        v_sql := 'INSERT INTO RUBROS (ID_RUBRO, Descripción, Monto) VALUES (:v_id_rubro, :p_descripción, :p_monto)';
        EXECUTE IMMEDIATE v_sql USING v_id_rubro, p_descripción, p_monto;
        p_mensaje := 'Rubro agregado correctamente';
    END IF;
END;

CREATE OR REPLACE FUNCTION get_datos_rubro
  RETURN SYS_REFCURSOR
AS
  cur_datos SYS_REFCURSOR;
BEGIN
  OPEN cur_datos FOR
    SELECT id_rubro, descripción, monto
    FROM RUBROS;
  RETURN cur_datos;
END;

CREATE OR REPLACE PROCEDURE REALIZAR_COMPRA(
    p_id_usuario IN USUARIOS.ID_USER%TYPE,
    p_id_rubro IN RUBROS.id_rubro%TYPE,
    p_cantidad NUMBER,
    p_mensaje OUT VARCHAR2
)
AS 
    v_sql VARCHAR2(300);
    v_usuario Usuarios%rowtype;
    v_rubro RUBROS%ROWTYPE;
    codigo number;
    v_monto NUMBER;
    v_estado VARCHAR2(20);
   
BEGIN
    v_usuario := FN_DATOS_USUARIO(p_id_usuario);
    v_rubro := FN_INFO_RUBRO(p_id_rubro);
    v_monto := v_rubro.MONTO * p_cantidad;
    codigo  :=seq_compra.NEXTVAL;
    v_sql := 'INSERT INTO COMPRA (COD_COMPRA, MONTO, ID_RUBRO, ID_USUARIO,CANTIDAD) ' ||
             'VALUES (:codigo, :v_monto, :p_id_rubro, :p_id_usuario, :p_cantidad)' ;
    EXECUTE IMMEDIATE v_sql USING codigo,v_monto,p_id_rubro,p_id_usuario,p_cantidad;
    v_estado := verificar_presupuesto(v_usuario.ID_CENTROCOSTO, v_monto);
    DBMS_OUTPUT.PUT_LINE(v_estado);
    p_mensaje := v_estado;
END;

CREATE OR REPLACE FUNCTION actualizar_presupuesto(
    IdCentroCosto IN NUMBER,
    IniPeriodo IN DATE,
    FinPeriodo IN DATE,
    VTotal IN NUMBER
) RETURN VARCHAR2 IS
    v_mensaje VARCHAR2(100);
BEGIN
    UPDATE PRESUPUESTO
    SET inicio_Periodo = IniPeriodo,
        fin_Periodo = FinPeriodo,
        Total = VTotal
    WHERE ID_CentroCosto = IdCentroCosto;
    IF SQL%ROWCOUNT > 0 THEN
        v_mensaje := 'Presupuesto actualizado con éxito.';
    ELSE
        v_mensaje := 'Presupuesto no encontrado para el Centro de Costo especificado.';
    END IF;
    RETURN v_mensaje;
END;


CREATE OR REPLACE FUNCTION mostrar_permisos_compra
RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT ID_Permiso,Cod_Compra,fecha,ID_Centro, Estado
        FROM PERMISOS_COMPRA;
    RETURN v_cursor;
END;

CREATE OR REPLACE PROCEDURE MOSTRAR_PERMISOS IS
    v_cursor SYS_REFCURSOR;
    v_id_permiso NUMBER;
    v_id_centro NUMBER;
    v_cod_compra NUMBER;
    v_fecha DATE;
    v_estado VARCHAR2(4);
BEGIN
    v_cursor := mostrar_permisos_compra;
    LOOP
        FETCH v_cursor INTO v_id_permiso, v_id_centro, v_cod_compra, v_fecha, v_estado;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID Permiso: ' || v_id_permiso || ', ID Centro: ' || v_id_centro || ', Cod Compra: ' || v_cod_compra || ', Fecha: ' || v_fecha || ', Estado: ' || v_estado);
    END LOOP;
    CLOSE v_cursor;
END;

CREATE OR REPLACE FUNCTION mostrar_desglose_mensual_presupuesto
RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT ID_DesgloseMensual, ID_Pesupuesto, PresupuestoAsignado, ID_Rubro, Mes, Total, PresupuestoActual
        FROM DESGLOSE_MENSUAL_PRESUPUESTO;
    RETURN v_cursor;
END;


CREATE OR REPLACE PROCEDURE MOSTRAR_DESGLOSE IS
    v_cursor SYS_REFCURSOR;
    v_id_desglose_mensual NUMBER;
    v_id_presupuesto VARCHAR2(100);
    v_presupuesto_asignado NUMBER;
    v_id_rubro VARCHAR2(100);
    v_mes DATE;
    v_total NUMBER;
    v_presupuesto_actual NUMBER;
BEGIN
    v_cursor := mostrar_desglose_mensual_presupuesto;
    LOOP
        FETCH v_cursor INTO v_id_desglose_mensual, v_id_presupuesto, v_presupuesto_asignado, v_id_rubro, v_mes, v_total, v_presupuesto_actual;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID Desglose Mensual: ' || v_id_desglose_mensual || ', ID Presupuesto: ' || v_id_presupuesto || ', Presupuesto Asignado: ' || v_presupuesto_asignado || ', ID Rubro: ' || v_id_rubro || ', Mes: ' || v_mes || ', Total: ' || v_total || ', Presupuesto Actual: ' || v_presupuesto_actual);
    END LOOP;
    CLOSE v_cursor;
END;




CREATE OR REPLACE TRIGGER TGR_COMPRA 
AFTER INSERT ON COMPRA
FOR EACH ROW
DECLARE
    V_ESTADO VARCHAR2(120);
    V_CENTRO USUARIOS%ROWTYPE;
    V_COMPRA COMPRA%ROWTYPE;
    V_PRESUPUESTO PRESUPUESTO%ROWTYPE;
    V_SEQ NUMBER;
    VRES NUMBER;
BEGIN 
    V_CENTRO := FN_DATOS_USUARIO(:NEW.ID_USUARIO);
    V_ESTADO := VERIFICAR_PRESUPUESTO(V_CENTRO.ID_CENTROCOSTO, :NEW.MONTO);
    V_PRESUPUESTO :=obtener_datos_Centro(V_CENTRO.ID_CENTROCOSTO);
    V_SEQ := seq_permiso.NEXTVAL;   
    
    INSERT INTO PERMISOS_COMPRA(ID_PERMISO,COD_COMPRA,FECHA,ID_CENTRO,ESTADO) 
    VALUES (V_SEQ,:NEW.COD_COMPRA,SYSTIMESTAMP,V_CENTRO.ID_CENTROCOSTO,V_ESTADO);
    IF V_ESTADO IN ('ACEPTADO','EXEDIDO')THEN
        INSERT INTO DESGLOSE_MENSUAL_PRESUPUESTO(ID_DESGLOSEMENSUAL,ID_PRESUPUESTO,PRESUPUESTOASIGNADO,ID_RUBRO,MES,TOTAL,PRESUPUESTOACTUAL)
        VALUES(seq_desglose_mensual.NEXTVAL,V_PRESUPUESTO.ID_PRESUPUESTO,V_PRESUPUESTO.TOTAL,:NEW.ID_RUBRO,SYSTIMESTAMP,:NEW.MONTO,V_PRESUPUESTO.TOTAL-:NEW.MONTO);
        VRES := V_PRESUPUESTO.TOTAL-:NEW.MONTO;
        IF VRES>0 THEN
            UPDATE PRESUPUESTO SET TOTAL =  VRES WHERE ID_PRESUPUESTO = V_PRESUPUESTO.ID_PRESUPUESTO;
        ELSE
            UPDATE PRESUPUESTO SET TOTAL = 0, SALDO_COMPROMETIDO = VRES WHERE ID_PRESUPUESTO = V_PRESUPUESTO.ID_PRESUPUESTO;
        END IF;
    END IF; 
END;


CREATE OR REPLACE TRIGGER TRG_BEFORE_INSERT_CENTRO_COSTO
BEFORE INSERT ON CENTRO_COSTOS
FOR EACH ROW
DECLARE
    SaldoComp NUMBER;
    PresTot NUMBER;
    IdPres VARCHAR2(100);
    MSJ VARCHAR2(100);
BEGIN
    BEGIN
        SELECT p.ID_Presupuesto, p.saldo_Comprometido, p.Total
        INTO IdPres, SaldoComp, PresTot
        FROM PRESUPUESTO p
        WHERE p.ID_CentroCosto = :NEW.ID_CentroCosto;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN;
    END;
 
    IF SaldoComp > 0 THEN
        UPDATE PRESUPUESTO
        SET Total = Total - SaldoComp,
            saldo_Comprometido = 0
        WHERE ID_Presupuesto = IdPres;
 
        MSJ := 'Saldo comprometido descontado del presupuesto antes de insertar el nuevo centro de costo.';
        DBMS_OUTPUT.PUT_LINE(MSJ);
    END IF;
END;



    

CREATE OR REPLACE PACKAGE gestion_presupuesto AS

    FUNCTION crear_centro_costo_y_presupuesto(
        p_nombre_centro_costo IN VARCHAR2,
        p_inicio_periodo IN DATE,
        p_fin_periodo IN DATE,
        p_total IN NUMBER
    ) RETURN VARCHAR2;

    FUNCTION insertar_usuario (
        p_user IN VARCHAR2,
        p_pass IN VARCHAR2,
        p_rol IN VARCHAR2,
        p_id_centroCosto IN NUMBER
    ) RETURN VARCHAR2;

    FUNCTION obtener_datos_Centro(
        p_id_centro IN NUMBER
    ) 
    RETURN PRESUPUESTO%ROWTYPE;

    FUNCTION validar_usuario(p_user IN VARCHAR2, p_pass IN VARCHAR2)
      RETURN NUMBER;

    FUNCTION FN_DATOS_USUARIO(V_user IN NUMBER)
      RETURN USUARIOS%ROWTYPE;

    FUNCTION verificar_presupuesto(
        p_id_presupuesto IN VARCHAR2,
        p_valor IN NUMBER
    ) RETURN VARCHAR2;

    FUNCTION FN_INFO_RUBRO(ID_RUBRO VARCHAR2)
    RETURN RUBROS%ROWTYPE;

    FUNCTION FN_INFO_COMPRA(COD IN NUMBER)
    RETURN COMPRA%ROWTYPE;

    FUNCTION get_datos_rubro
      RETURN SYS_REFCURSOR;

    FUNCTION actualizar_presupuesto(
        IdCentroCosto IN NUMBER,
        IniPeriodo IN DATE,
        FinPeriodo IN DATE,
        VTotal IN NUMBER
    ) RETURN VARCHAR2;

    FUNCTION mostrar_permisos_compra
    RETURN SYS_REFCURSOR;

    FUNCTION mostrar_desglose_mensual_presupuesto
    RETURN SYS_REFCURSOR;

    PROCEDURE sp_insert_rubro(
        p_descripción IN RUBROS.descripción%TYPE,
        p_monto IN RUBROS.monto%TYPE,
        p_mensaje OUT VARCHAR2
    );

    PROCEDURE REALIZAR_COMPRA(
        p_id_usuario IN USUARIOS.ID_USER%TYPE,
        p_id_rubro IN RUBROS.id_rubro%TYPE,
        p_cantidad NUMBER,
        p_mensaje OUT VARCHAR2
    );

    PROCEDURE MOSTRAR_PERMISOS;

    PROCEDURE MOSTRAR_DESGLOSE;

END;


CREATE OR REPLACE PACKAGE BODY gestion_presupuesto AS

    FUNCTION insertar_usuario (
    p_user IN VARCHAR2,
    p_pass IN VARCHAR2,
    p_rol IN VARCHAR2,
    p_id_centroCosto IN NUMBER
    ) RETURN VARCHAR2
    AS
        v_sql VARCHAR2(4000);
        v_count NUMBER;
    BEGIN
        v_sql := 'SELECT COUNT(*) FROM USUARIOS WHERE USER_NAME = :p_user';
        EXECUTE IMMEDIATE v_sql INTO v_count USING p_user;
    
        IF v_count = 0 THEN
            v_sql := 'INSERT INTO USUARIOS (ID_USER, USER_NAME, PASS, ROL, ID_CentroCosto) VALUES (usuario_seq.NEXTVAL, :p_user, :p_pass, :p_rol, :p_id_centroCosto)';
            EXECUTE IMMEDIATE v_sql USING p_user, p_pass, p_rol, p_id_centroCosto;
    
            RETURN 'Usuario insertado correctamente';
        ELSE
            RETURN 'El usuario ya existe';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error al insertar el usuario';
    END;

    FUNCTION obtener_datos_Centro(
    p_id_centro IN NUMBER
    ) 
    RETURN PRESUPUESTO%ROWTYPE
    IS
        v_sql VARCHAR2(4000);
        Resultado PRESUPUESTO%ROWTYPE;
    BEGIN
        v_sql := 'SELECT ID_Presupuesto, ID_CENTROCOSTO, Total, inicio_Periodo, fin_Periodo, saldo_Comprometido, ID_CENTRO_COSTO
    
               FROM 
                  PRESUPUESTO 
               WHERE 
                  ID_CENTROCOSTO = :p_id_centro';
        BEGIN 
            EXECUTE IMMEDIATE v_sql INTO Resultado USING p_id_centro;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'No se encontraron datos para el centro de costo ' || p_id_centro);
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20002, 'Error al obtener datos del centro de costo: ' || SQLERRM);
        END; 
        RETURN Resultado;
    END;

   FUNCTION validar_usuario(p_user IN VARCHAR2, p_pass IN VARCHAR2)
      RETURN NUMBER
    AS
      v_sql VARCHAR2(4000);
      v_count NUMBER;
    BEGIN
      v_sql := 'SELECT COUNT(*) FROM USUARIOS WHERE USER_NAME = :p_user AND PASS = :p_pass';
      EXECUTE IMMEDIATE v_sql INTO v_count USING p_user, p_pass;
      
      IF v_count = 1 THEN
        RETURN 1; 
      ELSE
        RETURN 0; 
      END IF;
    END;

    FUNCTION FN_DATOS_USUARIO(V_user IN NUMBER)
  RETURN USUARIOS%ROWTYPE
    AS
      v_usuario USUARIOS%ROWTYPE;
    BEGIN
      SELECT ID_USER ,USER_NAME, ROL,PASS, ID_CENTROCOSTO INTO v_usuario
      FROM USUARIOS
      WHERE ID_USER = V_user;
      RETURN v_usuario;
    END;
    FUNCTION verificar_presupuesto(
        p_id_presupuesto IN VARCHAR2,
        p_valor IN NUMBER
    ) RETURN VARCHAR2 IS
        v_total NUMBER;
        v_saldo_comprometido NUMBER;
        resultado VARCHAR2(120);
    BEGIN
    
        SELECT Total, saldo_Comprometido
        INTO v_total, v_saldo_comprometido
        FROM PRESUPUESTO
        WHERE ID_CENTROCOSTO = p_id_presupuesto;
        IF v_total > 0 THEN
            IF p_valor <= v_total THEN
                resultado := 'ACEPTADO';
            ELSE
                resultado := 'EXCEDIDO';
            END IF;
        ELSE
            IF v_saldo_comprometido < 0 THEN
                resultado := 'DENEGADO';
            ELSE
                resultado := 'EXCEDIDO';
            END IF;
        END IF; 
        RETURN resultado;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            resultado := 'PRESUPUESTO NO ENCONTRADO';
            RETURN resultado;
        WHEN OTHERS THEN
            RETURN 'ERROR';
        RETURN resultado;
    END;
    FUNCTION FN_INFO_RUBRO(ID_RUBRO VARCHAR2)
    RETURN RUBROS%ROWTYPE
    AS
        v_sql VARCHAR2(4000);
        Resultado RUBROS%ROWTYPE;
        v_id_rubro RUBROS.ID_RUBRO%TYPE := ID_RUBRO;
    BEGIN
        v_sql := 'SELECT ID_RUBRO, DESCRIPCIÓN, MONTO FROM RUBROS WHERE ID_RUBRO = :ID_RUBRO';
        
        BEGIN 
             EXECUTE IMMEDIATE v_sql INTO Resultado USING v_id_rubro;
             EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'No se encontraron datos para el RUBRO ' || ID_RUBRO);
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20002, 'Error al obtener datos del RUBRO: ' || SQLERRM);
        END;
       
        RETURN Resultado;
    END;
    FUNCTION FN_INFO_COMPRA(COD IN NUMBER)
    RETURN COMPRA%ROWTYPE
    AS
        v_sql VARCHAR2(4000);
        RESULTADO COMPRA%ROWTYPE;
    BEGIN 
        V_SQL := 'SELECT COD_COMPRA, CANTIDAD, MONTO, ID_RUBRO, ID_USUARIO FROM COMPRA WHERE COD_COMPRA = :COD';
        
        EXECUTE IMMEDIATE V_SQL 
            INTO RESULTADO.COD_COMPRA, RESULTADO.CANTIDAD, RESULTADO.MONTO, RESULTADO.ID_RUBRO, RESULTADO.ID_USUARIO 
            USING COD;
        
        RETURN RESULTADO;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No se encontraron datos de la compra ' || COD);
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al obtener datos de la compra: ' || SQLERRM);
    END;
    PROCEDURE sp_insert_rubro(
    p_descripción IN RUBROS.descripción%TYPE,
    p_monto IN RUBROS.monto%TYPE,
    p_mensaje OUT VARCHAR2
    ) AS
        v_sql VARCHAR2(200);
        v_count NUMBER;
        v_id_rubro RUBROS.id_rubro%TYPE;
    BEGIN
        v_sql := 'SELECT COUNT(*) FROM RUBROS WHERE Descripción = :p_descripción';
        EXECUTE IMMEDIATE v_sql INTO v_count USING p_descripción;
    
        IF v_count > 0 THEN
            p_mensaje := 'No se puede agregar, la descripción ya existe';
        ELSE
            v_id_rubro := SEQ_RUBRO.NEXTVAL;
            v_sql := 'INSERT INTO RUBROS (ID_RUBRO, Descripción, Monto) VALUES (:v_id_rubro, :p_descripción, :p_monto)';
            EXECUTE IMMEDIATE v_sql USING v_id_rubro, p_descripción, p_monto;
            p_mensaje := 'Rubro agregado correctamente';
        END IF;
    END;
    FUNCTION get_datos_rubro
    RETURN SYS_REFCURSOR
    AS
      cur_datos SYS_REFCURSOR;
    BEGIN
      OPEN cur_datos FOR
        SELECT id_rubro, descripción, monto
        FROM RUBROS;
      RETURN cur_datos;
    END;
    PROCEDURE REALIZAR_COMPRA(
    p_id_usuario IN USUARIOS.ID_USER%TYPE,
    p_id_rubro IN RUBROS.id_rubro%TYPE,
    p_cantidad NUMBER,
    p_mensaje OUT VARCHAR2
    )
    AS 
        v_sql VARCHAR2(300);
        v_usuario Usuarios%rowtype;
        v_rubro RUBROS%ROWTYPE;
        codigo number;
        v_monto NUMBER;
        v_estado VARCHAR2(20);
       
    BEGIN
        v_usuario := FN_DATOS_USUARIO(p_id_usuario);
        v_rubro := FN_INFO_RUBRO(p_id_rubro);
        v_monto := v_rubro.MONTO * p_cantidad;
        codigo  :=seq_compra.NEXTVAL;
        v_sql := 'INSERT INTO COMPRA (COD_COMPRA, MONTO, ID_RUBRO, ID_USUARIO,CANTIDAD) ' ||
                 'VALUES (:codigo, :v_monto, :p_id_rubro, :p_id_usuario, :p_cantidad)' ;
        EXECUTE IMMEDIATE v_sql USING codigo,v_monto,p_id_rubro,p_id_usuario,p_cantidad;
        v_estado := verificar_presupuesto(v_usuario.ID_CENTROCOSTO, v_monto);
        DBMS_OUTPUT.PUT_LINE(v_estado);
        p_mensaje := v_estado;
    END;
     FUNCTION actualizar_presupuesto(
        IdCentroCosto IN NUMBER,
        IniPeriodo IN DATE,
        FinPeriodo IN DATE,
        VTotal IN NUMBER
    ) RETURN VARCHAR2 IS
        v_mensaje VARCHAR2(100);
    BEGIN
        UPDATE PRESUPUESTO
        SET inicio_Periodo = IniPeriodo,
            fin_Periodo = FinPeriodo,
            Total = VTotal
        WHERE ID_CentroCosto = IdCentroCosto;
        IF SQL%ROWCOUNT > 0 THEN
            v_mensaje := 'Presupuesto actualizado con éxito.';
        ELSE
            v_mensaje := 'Presupuesto no encontrado para el Centro de Costo especificado.';
        END IF;
        RETURN v_mensaje;
    END;   
   FUNCTION mostrar_permisos_compra
    RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT ID_Permiso,Cod_Compra,fecha,ID_Centro, Estado
            FROM PERMISOS_COMPRA;
        RETURN v_cursor;
    END; 
        PROCEDURE MOSTRAR_PERMISOS IS
        v_cursor SYS_REFCURSOR;
        v_id_permiso NUMBER;
        v_id_centro NUMBER;
        v_cod_compra NUMBER;
        v_fecha DATE;
        v_estado VARCHAR2(4);
    BEGIN
        v_cursor := mostrar_permisos_compra;
        LOOP
            FETCH v_cursor INTO v_id_permiso, v_id_centro, v_cod_compra, v_fecha, v_estado;
            EXIT WHEN v_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('ID Permiso: ' || v_id_permiso || ', ID Centro: ' || v_id_centro || ', Cod Compra: ' || v_cod_compra || ', Fecha: ' || v_fecha || ', Estado: ' || v_estado);
        END LOOP;
        CLOSE v_cursor;
    END;
   FUNCTION mostrar_desglose_mensual_presupuesto
    RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT ID_DesgloseMensual, ID_Pesupuesto, PresupuestoAsignado, ID_Rubro, Mes, Total, PresupuestoActual
            FROM DESGLOSE_MENSUAL_PRESUPUESTO;
        RETURN v_cursor;
    END; 
      PROCEDURE MOSTRAR_DESGLOSE IS
        v_cursor SYS_REFCURSOR;
        v_id_desglose_mensual NUMBER;
        v_id_presupuesto VARCHAR2(100);
        v_presupuesto_asignado NUMBER;
        v_id_rubro VARCHAR2(100);
        v_mes DATE;
        v_total NUMBER;
        v_presupuesto_actual NUMBER;
    BEGIN
        v_cursor := mostrar_desglose_mensual_presupuesto;
        LOOP
            FETCH v_cursor INTO v_id_desglose_mensual, v_id_presupuesto, v_presupuesto_asignado, v_id_rubro, v_mes, v_total, v_presupuesto_actual;
            EXIT WHEN v_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('ID Desglose Mensual: ' || v_id_desglose_mensual || ', ID Presupuesto: ' || v_id_presupuesto || ', Presupuesto Asignado: ' || v_presupuesto_asignado || ', ID Rubro: ' || v_id_rubro || ', Mes: ' || v_mes || ', Total: ' || v_total || ', Presupuesto Actual: ' || v_presupuesto_actual);
        END LOOP;
        CLOSE v_cursor;
    END;    
END ;




    

DECLARE
    MENSAJE VARCHAR2(201);
BEGIN 
    REALIZAR_COMPRA(9, 302, 8, MENSAJE);
    DBMS_OUTPUT.PUT_LINE(MENSAJE);
END;





ID_PRESUPUESTO



 







----====----=====999990000000000098888888777666665544
    V_USUARIO USUARIOS%ROWTYPE;
    V_RUBRO RUBROS%ROWTYPE;
    V_PRESUPUESTO PRESUPUESTO%ROWTYPE;

V_USUARIO := FN_DATOS_USUARIO(7);
    DBMS_OUTPUT.PUT_LINE(V_USUARIO.ID_CENTROCOSTO);
    V_RUBRO := FN_INFO_RUBRO('302');
    DBMS_OUTPUT.PUT_LINE(V_RUBRO.MONTO);
    MENSAJE := verificar_presupuesto(V_USUARIO.ID_CENTROCOSTO, V_RUBRO.MONTO);
    DBMS_OUTPUT.PUT_LINE('Estado: ' || MENSAJE);
    REALIZAR_COMPRA(V_USUARIO.ID_USER,V_RUBRO.ID_RUBRO,3,MENSAJE);



 REALIZAR_COMPRA(1, '302',23,MENSAJE);
 //MS2 := VERIFICAR_PRESUPUESTO(102,500);


    
    
    


   
    RETURN p_mensaje;
END;





ALTER TABLE compra
MODIFY cantidad number;









--------------------------------------------------------------------------------
//pruebas
--------------------------------------------------------------------------------
DECLARE
    
    MENSAJE VARCHAR2(100);
BEGIN 
    MENSAJE := verificar_presupuesto(221,3);
    DBMS_OUTPUT.PUT_LINE('Estado: ' || MENSAJE);
    
END;

DECLARE
    v_result VARCHAR2(100);
BEGIN
    v_result := insertar_usuario('USER13','PASS','USER',123);
    DBMS_OUTPUT.PUT_LINE(v_result);
END;

select validar_usuario('Admin','Pass') from DUAL;

DECLARE
    v_mensaje VARCHAR2(100);
BEGIN
    v_mensaje := crear_centro_costo_y_presupuesto('RECTORIA', DATE '2022-01-01', DATE '2022-01-31', 1000);
    v_mensaje := crear_centro_costo_y_presupuesto('COMPUTO', DATE '2022-01-01', DATE '2022-01-31', 1000);
    v_mensaje := crear_centro_costo_y_presupuesto('LETRAS', DATE '2022-01-01', DATE '2022-01-31', 1000);
    
    DBMS_OUTPUT.PUT_LINE(v_mensaje);
END;

DECLARE

  v_usuario USUARIOS%ROWTYPE;

  V_CENTRO PRESUPUESTO%ROWTYPE;

BEGIN

  v_usuario := FN_DATOS_USUARIO(6);
  V_CENTRO := obtener_datos_Centro(v_usuario.ID_CENTROCOSTO);

  DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_usuario.ID_USER) || ' - ' || v_usuario.USER_NAME || ' - ' || v_usuario.ROL || ' - ' || v_usuario.PASS || ' - ' || TO_CHAR(v_usuario.ID_CENTROCOSTO));

  DBMS_OUTPUT.PUT_LINE(V_CENTRO.TOTAL);

END;


DECLARE
  v_presupuesto PRESUPUESTO%ROWTYPE;
BEGIN
  v_presupuesto := obtener_datos_Centro(101);
  DBMS_OUTPUT.PUT_LINE('ID_Presupuesto: ' || v_presupuesto.ID_Presupuesto);
  DBMS_OUTPUT.PUT_LINE('ID_CENTROCOSTO: ' || v_presupuesto.ID_CENTROCOSTO);
  DBMS_OUTPUT.PUT_LINE('inicio_Periodo: ' || v_presupuesto.inicio_Periodo);
  DBMS_OUTPUT.PUT_LINE('Total: ' || v_presupuesto.TOTAL);
  DBMS_OUTPUT.PUT_LINE('fin_Periodo: ' || v_presupuesto.fin_Periodo);
    DBMS_OUTPUT.PUT_LINE('saldo_Comprometido: ' || v_presupuesto.SALDO_COMPROMETIDO);
END;


DECLARE
    MENSAJE VARCHAR2(201);
BEGIN 
    REALIZAR_COMPRA(2, 302, 7, MENSAJE);
    
    DBMS_OUTPUT.PUT_LINE(MENSAJE);
END;

DECLARE
    v_mensaje VARCHAR2(200);
BEGIN
    sp_insert_rubro('Boligrafos', 1000, v_mensaje);
    sp_insert_rubro('Targetas', 10000, v_mensaje);
    sp_insert_rubro('Crayolas ', 14000, v_mensaje);
    sp_insert_rubro('Borradores', 4000, v_mensaje);
    sp_insert_rubro('Pizarras', 111000, v_mensaje);
    DBMS_OUTPUT.PUT_LINE(v_mensaje);
END;
 

SET SERVEROUTPUT ON;

select * from usuarios;


