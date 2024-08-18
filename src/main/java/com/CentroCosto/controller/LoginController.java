/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.controller;

import com.CentroCosto.domain.CentroCosto;
import com.CentroCosto.domain.Usuario;
import com.CentroCosto.impl.UsuarioServiceImpl;
import org.springframework.ui.Model;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author mija2
 */
@Controller
@RequestMapping("/centro")
public class LoginController {

    @Autowired
    private UsuarioServiceImpl usuarioService;

    @PostMapping("/Login")
    public String login(@RequestParam("username") String username, @RequestParam("password") String password, Model model) {
        boolean resultado = usuarioService.validarUsuario(username, password);
        if (resultado) {
            Usuario u = usuarioService.getUsuarioDatos(username);
            
            return "centro/centroViews";
            
        } else {
            // Si el usuario no es válido, mostrar un mensaje de error
            
            model.addAttribute("error", "credenciales invalidas");
            return "Login";
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
            return new ModelAndView("redirect:templates/Index");
        }
    }

}
