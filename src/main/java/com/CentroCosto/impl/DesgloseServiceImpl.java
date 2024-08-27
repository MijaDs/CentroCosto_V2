/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.impl;

import com.CentroCosto.Repositories.DesgloseRepo;
import com.CentroCosto.service.DesgloseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author mija2
 */
@Service
public class DesgloseServiceImpl implements DesgloseService{
     @Autowired
    private DesgloseRepo desgloseRepo;
    
    @Transactional
     @Override
    public void mostrarDesglose() {
        desgloseRepo.mostrarDesglose();
    }
}
