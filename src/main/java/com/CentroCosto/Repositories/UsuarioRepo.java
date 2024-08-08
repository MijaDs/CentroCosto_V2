/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.Repositories;

import com.CentroCosto.domain.Usuario;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

/**
 *
 * @author mija2
 */
@SpringBootApplication
public interface UsuarioRepo extends JpaRepository<Usuario, Integer>{
    @Procedure(procedureName = "VALIDAR_USUARIO")
    Integer validarUsuario(@Param("username") String username, @Param("password") String password);
}


//DECLARE
//    v_resultado VARCHAR2(100);
//BEGIN
//    v_resultado := insertar_presupuesto(
//        p_nombre_centro_costo => 'Nuevo Centro',
 //       p_inicio_periodo => TO_DATE('01/08/2024', 'dd/mm/yy'),
//        p_fin_periodo => TO_DATE('31/12/2024', 'dd/mm/yy'),
//        p_total => 50000
//    );  
//   DBMS_OUTPUT.PUT_LINE(v_resultado);
//END;