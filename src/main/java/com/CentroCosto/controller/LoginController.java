/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.controller;

import com.CentroCosto.domain.Usuario;
import com.CentroCosto.service.UsuarioService;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.ui.Model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author mija2
 */
@Controller
public class LoginController {

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping("/Login")
    public ModelAndView login(@RequestParam("username") String username, @RequestParam("password") String password) {
        if (usuarioService.validarUsuario(username, password)) {
            // Si el usuario es válido, redirigir a la página principal
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
