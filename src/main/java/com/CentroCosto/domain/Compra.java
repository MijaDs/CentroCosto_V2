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
import lombok.Data;

/**
 *
 * @author mija2
 */
@Data
@Entity
@Table(name="COMPRA")
public class Compra implements Serializable {
    private static long serialVersionUID =1L;
     @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="COD_COMPRA")
    private Long codCompra;
    @Column(name="CANTIDAD")
    private int cantidad;
    @Column(name="MONTO")
    private int monto;
    @Column(name="ID_RUBRO")
    private String idRubro;
    @Column(name="ID_USUARIO")
    private int idUsuario;
}
