/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.impl;

import com.CentroCosto.Repositories.PermisosRepo;
import com.CentroCosto.service.PermisosService;
import java.sql.Date;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author mija2
 */
@Service
public class PermisosServiceImpl implements PermisosService{
    @Autowired
    private PermisosRepo permisosRepo;
    
    @Override
    public void mostrarPermisos(Long idPermiso, Long idCentro, Long codCompra, Date fecha, String estado) {
        permisosRepo.mostrarPermisos(idPermiso, idCentro, codCompra, fecha, estado);
    }
}
