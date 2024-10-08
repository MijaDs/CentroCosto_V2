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
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.io.Serializable;
import java.util.List;

import lombok.Data;

@Data
@Entity
@Table(name="USUARIOS")
public class Usuario implements Serializable{
    
    private static long serialVersionUID =1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="ID_USER")
    private Long idUser;
    
    @Column(name="USER_NAME")
    private String user;
    
    @Column(name="PASS")
    private String pass;
    
    @Column(name="ROL")
    private String rol;
    
    @ManyToOne
    @JoinColumn(name = "ID_CENTROCOSTO", referencedColumnName = "ID_CENTROCOSTO")
    private CentroCosto centroCosto;
    @OneToMany(mappedBy = "usuario")
    private List<Compra> compras;
}
