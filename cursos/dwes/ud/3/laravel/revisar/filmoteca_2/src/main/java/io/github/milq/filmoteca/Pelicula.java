package io.github.milq.filmoteca;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.validation.constraints.Size;
import javax.validation.constraints.Min;

@Entity
public class Pelicula {

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  private long id;

  @Size(min=1, max=240, message="Debe contener al menos 1 letra y un máximo de 240.")
  private String titulo;

  @Min(value = 1850, message = "El año de estreno debe ser de 1850 en adelante.")
  private int anyo;

  @Min(value = 1, message = "La duración mínima es de un minuto.")
  private int duracion;

  public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  public String getTitulo() {
    return titulo;
  }

  public void setTitulo(String titulo) {
    this.titulo = titulo;
  }

  public int getAnyo() {
    return anyo;
  }

  public void setAnyo(int anyo) {
    this.anyo = anyo;
  }

  public int getDuracion() {
    return duracion;
  }

  public void setDuracion(int duracion) {
    this.duracion = duracion;
  }

}
