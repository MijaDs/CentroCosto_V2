/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.service;

import com.CentroCosto.domain.Usuario;

/**
 *
 * @author mija2
 */
public interface UsuarioService {
    boolean validarUsuario(String username, String password);
    Usuario getUsuarioDatos(String username);
    
}
