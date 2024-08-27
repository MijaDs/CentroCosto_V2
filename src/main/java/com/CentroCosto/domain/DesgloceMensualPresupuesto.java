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
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name="DESGLOSE_MENSUAL_PRESUPUESTO")
public class DesgloceMensualPresupuesto implements Serializable{
    private static long serialVersionUID =1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="ID_DESGLOSEMENSUAL")
    private Long idDesglose;
    @ManyToOne
    @JoinColumn(name = "ID_PRESUPUESTO", referencedColumnName = "ID_PRESUPUESTO")
    private Presupuesto presupuesto;
    @Column(name="PRESUPUESTOASIGNADO")
    private int presupuestoAsignado;
    @ManyToOne
    @JoinColumn(name = "ID_RUBRO", referencedColumnName = "ID_RUBRO")
    private Rubro rubro;
    @Column(name="MES")
    private Date mes;
    @Column(name="TOTAL")
    private int total;
    @Column(name="PRESUSPUESTOACTUAL")
    private int presupuestoActual;
}
