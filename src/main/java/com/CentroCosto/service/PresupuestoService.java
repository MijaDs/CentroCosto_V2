/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.service;

import com.CentroCosto.domain.Presupuesto;
import java.sql.Date;

/**
 *
 * @author mija2
 */
public interface PresupuestoService {
    
    String actualizarPresupuesto(Long idCentroCosto, Date iniPeriodo, Date finPeriodo, int vTotal);
    Presupuesto obtenerDatosCentro(int idCentro);
}
