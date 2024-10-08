/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.impl;

import com.CentroCosto.Repositories.CentroCostoRepo;
import com.CentroCosto.service.CentroService;
import java.math.BigDecimal;
import java.sql.Date;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author mija2
 */
@Service
public class CentroCostoServiceImpl implements CentroService{
    @Autowired
    private CentroCostoRepo centroCostoRepo;
    
    @Override
    public String agregarCentroCosto(String nombre, int id){
        return centroCostoRepo.agregarCentroCosto(nombre);
    }
    @Override
    public String crearCentroCostoYPresupuesto(String nombreCentroCosto, Date inicioPeriodo, Date finPeriodo, BigDecimal total) {
        return centroCostoRepo.crearCentroCosto(nombreCentroCosto, inicioPeriodo, finPeriodo, total);
    }
}
