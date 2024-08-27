/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.Repositories;

import com.CentroCosto.domain.Rubro;
import jakarta.persistence.ParameterMode;
import java.util.List;
import org.hibernate.annotations.Parameter;
import org.hibernate.jdbc.Expectation.OutParameter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

/**
 *
 * @author mija2
 */
public interface RubroRepo extends JpaRepository<Rubro , String> {
    @Query(value ="SELECT FN_INFO_RUBRO(:ID_RUBRO); END;", nativeQuery = true)
    Rubro getRubroDatos(@Param("ID_RUBRO") String idRubro);
    
    @Procedure(procedureName = "sp_insert_rubro", outputParameterName = "p_mensaje")
    void insertarRubro(@Param("p_descripción") String descripción, 
                        @Param("p_monto") int monto, 
                        @Param("p_mensaje") String mensaje);
    
    @Query(value = "SELECT * FROM TABLE(get_datos_rubro())", nativeQuery = true)
    List<Rubro> getRubrosDatos();
}
