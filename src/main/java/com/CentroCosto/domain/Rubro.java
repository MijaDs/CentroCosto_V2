/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.io.Serializable;
import java.util.List;
import lombok.Data;

/**
 *
 * @author mija2
 */
@Data
@Entity
@Table(name="RUBROS")
public class Rubro implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="ID_RUBRO")
    private String idRubro;
    
    @Column(name="DESCRIPCIÓN")
    private String descrioción;
    @Column(name="MONTO")
    private int monto;
    
    @OneToMany(mappedBy = "rubro")
    private List<DesgloceMensualPresupuesto> desglosesMensuales;
    @OneToMany(mappedBy = "rubro")
    private List<Compra> compras;
    
}
