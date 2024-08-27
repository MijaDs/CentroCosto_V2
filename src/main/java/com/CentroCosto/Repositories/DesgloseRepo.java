/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.Repositories;

import com.CentroCosto.domain.DesgloseMensualPresupuesto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

/**
 *
 * @author mija2
 */
public interface DesgloseRepo extends JpaRepository<DesgloseMensualPresupuesto, Long>{
    @Procedure("MOSTRAR_DESGLOSE")
    void mostrarDesglose();
}
