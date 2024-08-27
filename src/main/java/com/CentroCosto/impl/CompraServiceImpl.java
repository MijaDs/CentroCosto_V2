/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.impl;

import com.CentroCosto.Repositories.CompraRepo;
import com.CentroCosto.domain.Compra;
import com.CentroCosto.service.CompraService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author mija2
 */
@Service
public class CompraServiceImpl implements CompraService{
    @Autowired
    private CompraRepo compraRepo;
    
    public Compra getInfoCompra(Long codCompra) {
        return compraRepo.getInfoCompra(codCompra);
    }
    public String realizarCompra(Long idUsuario, Long idRubro, int cantidad) {
        String mensaje = compraRepo.realizarCompra(idUsuario, idRubro, cantidad, null);
        return mensaje;
    }
}
