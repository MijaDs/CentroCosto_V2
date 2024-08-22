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
    ID_USUARIO NUMBER,
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

//funcion para extaer datos centro_costo row%type;

CREATE OR REPLACE FUNCTION obtener_datos_Centro(
    p_id_centro IN NUMBER
) 
RETURN PRESUPUESTO%ROWTYPE
IS
    v_sql VARCHAR2(4000);
    Resultado PRESUPUESTO%ROWTYPE;
BEGIN
    v_sql := 'SELECT ID_Presupuesto,ID_CENTROCOSTO,Total,inicio_Periodo,fin_Periodo,saldo_Comprometido
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


CREATE OR REPLACE FUNCTION verificar_presupuesto(
    p_id_presupuesto IN VARCHAR2,
    p_valor IN NUMBER
) RETURN VARCHAR2 IS
    v_total NUMBER;
    v_saldo_comprometido NUMBER;
    resultado VARCHAR2(20);
BEGIN
    -- Obtener el Total y saldoComprometido del presupuesto
    SELECT Total, saldo_Comprometido
    INTO v_total, v_saldo_comprometido
    FROM PRESUPUESTO
    WHERE ID_CENTROCOSTO = p_id_presupuesto;

    -- Verificar las condiciones
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
        RETURN 'PRESUPUESTO NO ENCONTRADO';
    WHEN OTHERS THEN
        RETURN 'ERROR';
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

CREATE OR REPLACE FUNCTION FN_INFO_COMPRA(COD IN NUMBER)
RETURN COMPRA%ROWTYPE
AS
    v_sql VARCHAR2(4000);
    Resultado COMPRA%ROWTYPE;
BEGIN 
    V_SQL := 'SELECT COD_COMPRA,CANTIDAD,MONTO,ID_RUBRO,ID_USUARIO FROM COMPRA WHERE COD_COMPRA = :COD';
    EXECUTE IMMEDIATE V_SQL INTO RESULTADO USING COD;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No se encontraron datos de la compra ' || COD);
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al obtener datos de la compra: ' || SQLERRM);
    RETURN RESULTADO;
END;


SELECT FN_INFO_RUBRO('302') FROM DUAL;

DECLARE
    MENSAJE VARCHAR2(100);
BEGIN 
    MENSAJE := verificar_presupuesto(101, 30);
    DBMS_OUTPUT.PUT_LINE('Estado: ' || MENSAJE);
END;

CREATE OR REPLACE PROCEDURE REALIZAR_COMPRA(
    p_id_usuario NUMBER,
    p_id_rubro VARCHAR2,
    p_cantidad NUMBER,
    p_mensaje OUT VARCHAR2
)
AS
    v_usuario USUARIOS%ROWTYPE;
    v_rubro RUBROS%ROWTYPE;
    v_presupuesto PRESUPUESTO%ROWTYPE;
    v_monto NUMBER;
    v_estado VARCHAR2(20);
BEGIN
    v_usuario := FN_DATOS_USUARIO(p_id_usuario);
    v_rubro := FN_INFO_RUBRO(p_id_rubro);
    v_monto := v_rubro.MONTO * p_cantidad;
    v_estado := verificar_presupuesto(v_usuario.ID_CENTROCOSTO, v_monto);
    IF v_estado = 'ACEPTADO' THEN
        
        INSERT INTO COMPRA (COD_COMPRA, CANTIDAD, MONTO, ID_RUBRO, ID_USUARIO)
        VALUES (seq_compra.NEXTVAL, p_cantidad, v_monto, v_rubro.ID_RUBRO, p_id_usuario);
        
        p_mensaje := 'Compra realizada con éxito';
    ELSIF v_estado = 'EXCEDIDO' THEN
        INSERT INTO COMPRA (COD_COMPRA, CANTIDAD, MONTO, ID_RUBRO, ID_USUARIO)
            VALUES (seq_compra.NEXTVAL, p_cantidad, v_monto, v_rubro.ID_RUBRO, p_id_usuario);
        p_mensaje := 'Compra excedida, no se puede realizar';
    ELSE
        p_mensaje := 'Compra denegada, saldo comprometido insuficiente';
    END IF;
END;

DECLARE
    V_USUARIO USUARIOS%ROWTYPE;
    V_RUBRO RUBROS%ROWTYPE;
    V_PRESUPUESTO PRESUPUESTO%ROWTYPE;
    MENSAJE VARCHAR2(100);
BEGIN 
    V_USUARIO := FN_DATOS_USUARIO(7);
    DBMS_OUTPUT.PUT_LINE(V_USUARIO.ID_CENTROCOSTO);
    V_RUBRO := FN_INFO_RUBRO('302');
    DBMS_OUTPUT.PUT_LINE(V_RUBRO.MONTO);
    MENSAJE := verificar_presupuesto(V_USUARIO.ID_CENTROCOSTO, V_RUBRO.MONTO);
    DBMS_OUTPUT.PUT_LINE('Estado: ' || MENSAJE);
    REALIZAR_COMPRA(V_USUARIO.ID_USER,V_RUBRO.ID_RUBRO,3,MENSAJE);
END;







V_ESTADO := VERIFICAR_PRESUPUESTO(V_USUARIO.ID_CENTROCOSTO,V_MONTO);
    DBMS_OUTPUT.PUT_LINE('BRONCA '||V_ESTADO);
    IF V_ESTADO IN ('Aceptado','Excedido') THEN
        V_SQL := 'INSERT INTO COMPRA (COD_COMPRA, CANTIDAD,MONTO,ID_RUBRO,ID_USUARIO) VALUES (seq_compra.NEXTVAL,:CANTIDAD,:V_MONTO,:ID_RUBRO,:ID_USER)';
        EXECUTE IMMEDIATE V_SQL USING CANTIDAD, V_MONTO, V_RUBRO.ID_RUBRO, V_USUARIO.ID_USER;
    ELSE 
        p_mensaje := V_ESTADO;
    END IF;



 REALIZAR_COMPRA(1, '302',6,MENSAJE);
 //MS2 := VERIFICAR_PRESUPUESTO(102,500);

CREATE OR REPLACE TRIGGER TGR_COMPRA 
BEFORE INSERT ON COMPRA
FOR EACH ROW
DECLARE
    
BEGIN 
END;
    
    
    


   
    RETURN p_mensaje;
END;













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
    v_result := insertar_usuario('USER12','PASS','USER',123);
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
BEGIN
  v_usuario := FN_DATOS_USUARIO(5);
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_usuario.ID_USER) || ' - ' || v_usuario.USER_NAME || ' - ' || v_usuario.ROL || ' - ' || v_usuario.PASS || ' - ' || TO_CHAR(v_usuario.ID_CENTROCOSTO));
END;

DECLARE
  v_presupuesto PRESUPUESTO%ROWTYPE;
BEGIN
  v_presupuesto := obtener_datos_Centro(123);
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
    sp_insert_rubro('Labtop', 50000, v_mensaje);
    DBMS_OUTPUT.PUT_LINE(v_mensaje);
END;
 

SET SERVEROUTPUT ON;

select * from usuarios;


