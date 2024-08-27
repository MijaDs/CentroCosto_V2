/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.service;

import java.sql.Date;

/**
 *
 * @author mija2
 */
public interface PermisosService {
    void mostrarPermisos(Long idPermiso, Long idCentro, Long codCompra, Date fecha, String estado);
}
