/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.Repositories;

import com.CentroCosto.domain.PermisosCompra;
import java.sql.Date;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

/**
 *
 * @author mija2
 */
public interface PermisosRepo extends JpaRepository <PermisosCompra, Long>{
    @Procedure("MOSTRAR_PERMISOS")
    void mostrarPermisos(@Param("id_permiso") Long idPermiso, @Param("id_centro") Long idCentro, 
                         @Param("cod_compra") Long codCompra, @Param("fecha") Date fecha, 
                         @Param("estado") String estado);
}
