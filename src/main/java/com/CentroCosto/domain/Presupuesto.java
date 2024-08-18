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
import jakarta.persistence.Table;
import java.io.Serializable;
import java.sql.Date;
import lombok.Data;

/**
 *
 * @author mija2
 */
@Data
@Entity
@Table(name="PRESUPUESTO")
public class Presupuesto implements Serializable{
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID_Presupuesto")
    private String idPresupuesto;

    @Column(name = "ID_CentroCosto")
    private int idCentroCosto;

    @Column(name = "saldo_Comprometido")
    private float saldoComprometido;

    @Column(name = "inicio_Periodo")
    private Date inicioPeriodo;

    @Column(name = "fin_Periodo")
    private Date finPeriodo;

    @Column(name = "Total")
    private int total;
}
