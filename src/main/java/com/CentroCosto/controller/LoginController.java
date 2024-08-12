/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.controller;

import com.CentroCosto.domain.CentroCosto;
import com.CentroCosto.domain.Usuario;
import com.CentroCosto.impl.UsuarioServiceImpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author mija2
 */
@Controller
public class LoginController {

    @Autowired
    private UsuarioServiceImpl usuarioService;

    @PostMapping("/Login")
    public ModelAndView login(@RequestParam("username") String username, @RequestParam("password") String password) {
        boolean resultado = usuarioService.validarUsuario(username, password);
        Usuario resRol = usuarioService.getUsuarioRol(username);
        if (resultado&& resRol!= null) {
            String rol = resRol.getRol();
            CentroCosto centro = resRol.getCentroCosto();
            int idCentro = centro.getID_CENTROCOSTO();
            System.out.println(rol+" " +idCentro);
            return new ModelAndView("redirect:templates/centro/centroViews");
        } else {
            // Si el usuario no es válido, mostrar un mensaje de error
            ModelAndView modelAndView = new ModelAndView("Login");
            modelAndView.addObject("error", "Credenciales inválidas");
            return modelAndView;
        }
    }

    @PostMapping("/agregarUsuario")
    public ModelAndView agregarUsuario(@RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("rol") String rol,
            @RequestParam("centroCosto") int centroCosto) {
        String resultado = usuarioService.agregarUsuario(username, password, rol, centroCosto);
        if (resultado.equals("Usuario insertado correctamente")) {
            // Si el usuario se agregó correctamente, redirigir a la página principal
            return new ModelAndView("redirect:templates/centro/centroViews");
        } else {
            // Si hubo un error al agregar el usuario, mostrar un mensaje de error
            ModelAndView modelAndView = new ModelAndView("agregarUsuario");
            modelAndView.addObject("error", resultado);
            return modelAndView;
        }
    }

}
