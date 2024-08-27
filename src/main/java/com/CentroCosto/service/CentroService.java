/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.service;

import java.math.BigDecimal;
import java.sql.Date;

/**
 *
 * @author mija2
 */
public interface CentroService {
    String agregarCentroCosto(String nombre, int id);
    String crearCentroCostoYPresupuesto(String nombreCentroCosto, Date inicioPeriodo, Date finPeriodo, BigDecimal total);
}
