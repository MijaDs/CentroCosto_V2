/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.service;

import com.CentroCosto.Repositories.UsuarioRepo;
import com.CentroCosto.domain.Usuario;
import java.sql.CallableStatement;
import java.sql.Connection;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.stereotype.Service;

/**
 *
 * @author mija2
 */
@Service
public class UsuarioService {
    
    @Autowired
    private UsuarioRepo usuarioRepo;
    
    public boolean validarUsuario(String username, String password) {
        Integer result = usuarioRepo.validarUsuario(username, password);
        return result != null && result > 0;
    }
}
