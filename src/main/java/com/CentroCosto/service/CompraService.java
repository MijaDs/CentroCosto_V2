/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.service;

import com.CentroCosto.domain.Compra;

/**
 *
 * @author mija2
 */
public interface CompraService {
    
    Compra getInfoCompra(Long codCompra);
    
    String realizarCompra(Long idUsuario, Long idRubro, int cantidad);
}
