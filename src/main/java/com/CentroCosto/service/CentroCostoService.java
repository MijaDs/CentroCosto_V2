/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.service;

import com.CentroCosto.Repositories.CentroCostoRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author mija2
 */
@Service
public class CentroCostoService {
    @Autowired
    private CentroCostoRepo centroCostoRepo;
    public String agregarCentroCosto(String nombre, int id){
        return centroCostoRepo.agregarCentroCosto(nombre);
    }
}
