/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.CentroCosto.service;

import com.CentroCosto.domain.Rubro;
import java.util.List;

/**
 *
 * @author mija2
 */
public interface RubroService {
    Rubro getRubroDatos(String idRubro);
    void agregarRubro(String descripción, int monto);
    
    List<Rubro> getRubrosDatos();
}
