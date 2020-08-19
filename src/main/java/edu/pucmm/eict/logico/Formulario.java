package edu.pucmm.eict.logico;

import javax.persistence.*;
import java.io.Serializable;

@Entity(name = "Formulario")
public class Formulario implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Se genera el ID automatico
    private int id;

    private String nombre;
    private String sector;
    private String nivelEscolar;
    private double latitud;
    private double longitud;
    private String mimeType;

    @Lob
    private String fotoBase64;

    public Formulario() { }

    public Formulario(String nombre, String sector, String nivelEscolar, double latitud, double longitud, String tipo, String foto) {
        this.nombre = nombre;
        this.sector = sector;
        this.nivelEscolar = nivelEscolar;
        this.latitud = latitud;
        this.longitud = longitud;
        this.mimeType = tipo;
        this.fotoBase64 = foto;
    }

    public Formulario(String nombre, String sector, String nivelEscolar, double latitud, double longitud) {
        this.nombre = nombre;
        this.sector = sector;
        this.nivelEscolar = nivelEscolar;
        this.latitud = latitud;
        this.longitud = longitud;
    }

    public int getId() { return id; }

    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }

    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getSector() { return sector; }

    public void setSector(String sector) { this.sector = sector; }

    public String getNivelEscolar() { return nivelEscolar; }

    public void setNivelEscolar(String nivelEscolar) { this.nivelEscolar = nivelEscolar; }

    public double getLatitud() { return latitud; }

    public void setLatitud(double latitud) { this.latitud = latitud; }

    public double getLongitud() { return longitud; }

    public void setLongitud(double longitud) { this.longitud = longitud; }

    public String getMimeType() { return mimeType; }

    public void setMimeType(String mimeType) { this.mimeType = mimeType; }

    public String getFotoBase64() { return fotoBase64; }

    public void setFotoBase64(String fotoBase64) { this.fotoBase64 = fotoBase64; }
}
