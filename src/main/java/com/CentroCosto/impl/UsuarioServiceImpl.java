/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.impl;

import com.CentroCosto.Repositories.UsuarioRepo;
import com.CentroCosto.domain.Usuario;
import com.CentroCosto.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author mija2
 */
@Service
public class UsuarioServiceImpl implements UsuarioService {

    @Autowired
    private UsuarioRepo usuarioRepo;

    @Override
    @Transactional(readOnly = true)
    public boolean validarUsuario(String username, String password) {
        Integer result = usuarioRepo.validarUsuario(username, password);
        return result != null && result == 1;
    }

    public String agregarUsuario(String username, String password, String rol, int centroCosto) {
        String res = usuarioRepo.incertarUsuario(username, password, rol, centroCosto);
        return res;
    }
    @Override
    public Usuario getUsuarioDatos(String user) {
        return usuarioRepo.getUsuarioDatos(user);
    }
  

  
    

}
