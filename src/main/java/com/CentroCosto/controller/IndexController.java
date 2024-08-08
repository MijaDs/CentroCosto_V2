/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 *
 * @author mija2
 */
@Controller
public class IndexController {

    @GetMapping("/")
    public String home() {
        return "index"; // Asegúrate de que index.html esté en el directorio de plantillas
  
    }
}