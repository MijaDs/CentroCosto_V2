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
@Table(name="PREMISOS_COMPRA")
public class PermisosCompra implements Serializable{
     private static long serialVersionUID =1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="ID_PERMISO")
    private Long idPermiso;
    @Column (name="COD_COMPRA")
    private int codCompra;
    @Column (name="FECHA")
    private Date fecha;
    @Column (name="ID_CENTRO")
    private int idCentro;
    @Column (name="ESTADO")
    private String estado;
    
    @ManyToOne
    @JoinColumn(name = "ID_CENTROCOSTO", referencedColumnName = "ID_CENTROCOSTO")
    private CentroCosto centroCosto;
}
