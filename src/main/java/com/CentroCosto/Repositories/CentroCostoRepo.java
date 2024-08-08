/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.Repositories;

import com.CentroCosto.domain.centroCosto;
import java.io.Serializable;
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
public interface CentroCostoRepo extends JpaRepository<centroCosto,Integer>{
    
    @Procedure(procedureName = "SP_AGREGAR_CENTRO_COSTO")
    String agregarCentroCosto(@Param("c_nombre") String nombre);
}
