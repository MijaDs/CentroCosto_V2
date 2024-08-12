/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.Repositories;

import com.CentroCosto.domain.CentroCosto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

/**
 *
 * @author mija2
 */
@SpringBootApplication
public interface CentroCostoRepo extends JpaRepository<CentroCosto,Integer>{
    
    @Procedure(procedureName = "SP_AGREGAR_CENTRO_COSTO")
    String agregarCentroCosto(@Param("c_nombre") String nombre);
    
    @Procedure(procedureName ="CREAR_CENTRO_COSTO_Y_PRESUPUESTO")
    String crearCentroCosto(@Param("p_nombre_centro_costo") String nombreCentroCosto,
                                       @Param("p_inicio_periodo") Date inicioPeriodo,
                                       @Param("p_fin_periodo") Date finPeriodo,
                                       @Param("p_total") BigDecimal total);
}
