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

    /**
     * @return the serialVersionUID
     */
    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    /**
     * @param aSerialVersionUID the serialVersionUID to set
     */
    public static void setSerialVersionUID(long aSerialVersionUID) {
        serialVersionUID = aSerialVersionUID;
    }

    /**
     * @return the idUser
     */
    public Long getIdUser() {
        return idUser;
    }

    /**
     * @param idUser the idUser to set
     */
    public void setIdUser(Long idUser) {
        this.idUser = idUser;
    }

    /**
     * @return the user
     */
    public String getUser() {
        return user;
    }

    /**
     * @param user the user to set
     */
    public void setUser(String user) {
        this.user = user;
    }

    /**
     * @return the pass
     */
    public String getPass() {
        return pass;
    }

    /**
     * @param pass the pass to set
     */
    public void setPass(String pass) {
        this.pass = pass;
    }

    /**
     * @return the rol
     */
    public String getRol() {
        return rol;
    }

    /**
     * @param rol the rol to set
     */
    public void setRol(String rol) {
        this.rol = rol;
    }

    /**
     * @return the centroCosto
     */
    public CentroCosto getCentroCosto() {
        return centroCosto;
    }

    /**
     * @param centroCosto the centroCosto to set
     */
    public void setCentroCosto(CentroCosto centroCosto) {
        this.centroCosto = centroCosto;
    }
    
}
