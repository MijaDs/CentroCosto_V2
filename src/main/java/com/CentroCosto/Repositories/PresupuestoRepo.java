/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.Repositories;

import com.CentroCosto.domain.Presupuesto;
import java.sql.Date;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 *
 * @author mija2
 */
public interface PresupuestoRepo extends JpaRepository<Presupuesto , String> {
    @Query(value = "BEGIN :mensaje := actualizar_presupuesto(:IdCentroCosto, :IniPeriodo, :FinPeriodo, :VTotal); END;",
            nativeQuery = true)
    String actualizarPresupuesto(@Param("IdCentroCosto") Long idCentroCosto,
                                @Param("IniPeriodo") Date iniPeriodo,
                                @Param("FinPeriodo") Date finPeriodo,
                                @Param("VTotal") int vTotal,
                                @Param("mensaje") String mensaje);
    @Query(value = "SELECT obtener_datos_Centro(:idCentro) FROM DUAL", nativeQuery = true)
    Presupuesto obtenerDatosCentro(@Param("idCentro") Long idCentro);
}
