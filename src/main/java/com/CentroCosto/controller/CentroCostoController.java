/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.controller;
import com.CentroCosto.service.CentroCostoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
/**
 *
 * @author mija2
 */
@RestController
@RequestMapping("/centroCosto")
public class CentroCostoController {
    @Autowired
    private CentroCostoService centroCostoService;
    @PostMapping
    public String agregarCentroCosto(@RequestBody String nombre){
        return centroCostoService.agregarCentroCosto(nombre, 0);
    }
}
