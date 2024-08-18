/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.Repositories;

import com.CentroCosto.domain.Usuario;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

/**
 *
 * @author mija2
 */
@SpringBootApplication
public interface UsuarioRepo extends JpaRepository<Usuario, Long> {

    @Query(value = "SELECT validar_usuario(:p_user, :p_pass) FROM dual", nativeQuery = true)
    Integer validarUsuario(@Param("p_user") String user, @Param("p_pass") String password);

    @Query(value = "SELECT FN_DATOS_USUARIO(:p_user); END;", nativeQuery = true)
    Usuario getUsuarioDatos(@Param("p_user") String user);

    @Procedure(procedureName = "INCERTAR_USUARIO")
    String incertarUsuario(@Param("username") String username, @Param("password") String password, @Param("rol") String rol, @Param("id_centroCosto") int id_centroCosto);
    
    
    
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
