package com.CentroCosto.impl;


import com.CentroCosto.Repositories.PresupuestoRepo;
import com.CentroCosto.domain.Presupuesto;
import com.CentroCosto.service.PresupuestoService;
import java.sql.Date;
import static oracle.jdbc.driver.ClioSupport.log;
import org.springframework.beans.factory.annotation.Autowired;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

public abstract class PresusupestoServiceImpl implements PresupuestoService {
    @Autowired
    private PresupuestoRepo presupuestoRepo;
    
    @Override
    public String actualizarPresupuesto(Long idCentroCosto, Date iniPeriodo, Date finPeriodo, int vTotal) {
        String mensaje = presupuestoRepo.actualizarPresupuesto(idCentroCosto, iniPeriodo, finPeriodo, vTotal, null);
    return mensaje;
    }
    
    public Presupuesto obtenerDatosCentro(Long idCentro) {
        try {
            return presupuestoRepo.obtenerDatosCentro(idCentro);
        } catch (Exception e) {
            return null;
        }
    }


    
}