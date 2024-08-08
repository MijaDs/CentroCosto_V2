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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author mija2
 */
@Controller
public class LoginController {

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping("/Login")
    public String login(@RequestParam("username") String username, @RequestParam("password") String password, Model model) {
        if (usuarioService.validarUsuario(username, password)) {
            // Si el usuario es válido, redirigir al dashboard o a la página principal
            return "redirect:/Index";
        } else {
            // Si el usuario no es válido, mostrar un mensaje de error
            model.addAttribute("error", "Credenciales inválidas");
            return "Login";
        }
    }
}
