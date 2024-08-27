/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.Repositories;

import com.CentroCosto.domain.Compra;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

/**
 *
 * @author mija2
 */
public interface CompraRepo extends JpaRepository<Compra , Long>{
    @Procedure("REALIZAR_COMPRA")
    String realizarCompra(@Param("p_id_usuario") Long idUsuario, 
                          @Param("p_id_rubro") Long idRubro, 
                          @Param("p_cantidad") int cantidad, 
                          @Param("p_mensaje") String mensaje);
    
    @Procedure("FN_INFO_COMPRA")
    Compra getInfoCompra(@Param("COD") Long codCompra);
}
