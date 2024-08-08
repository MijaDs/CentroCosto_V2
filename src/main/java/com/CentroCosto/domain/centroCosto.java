/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.CentroCosto.domain;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

/**
 *
 * @author mija2
 */
@Data
@Entity
@Table(name="CENTRO_COSTOS")
public class centroCosto {
    @Id
    private int ID_CENTROCOSTO;
    @Column(name="NOMBRE")
    private String nombre;
}
