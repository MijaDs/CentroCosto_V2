/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.impl;

import com.CentroCosto.Repositories.RubroRepo;
import com.CentroCosto.domain.Rubro;
import com.CentroCosto.service.RubroService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author mija2
 */
@Service
public class RubroServiceImpl implements  RubroService{
    @Autowired
    private RubroRepo rubroRepo;
    
    @Override
    public Rubro getRubroDatos(String idRubro) {
        return rubroRepo.getRubroDatos(idRubro);
    }
  
    @Override
    public void agregarRubro(String descripción, int monto) {
        String mensaje = null;
        rubroRepo.insertarRubro(descripción, monto, mensaje);
        System.out.println(mensaje);
    }
    
    @Override
    public List<Rubro> getRubrosDatos() {
        return rubroRepo.getRubrosDatos();
    }
    
}
