package io.github.milq.filmoteca;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import io.github.milq.filmoteca.PeliculaRepository;

@Controller
public class FilmotecaController {

  private final PeliculaRepository peliculaRepository;

  @Autowired
  public FilmotecaController(PeliculaRepository peliculaRepository) {
      this.peliculaRepository = peliculaRepository;
  }

  @GetMapping("/")
  public String filmotecaInicio() {
    return "index";
  }

  @GetMapping("/insertar")
  public String insertarPeliculaFormulario(Model model) {
    model.addAttribute("pelicula", new Pelicula());
    return "insertar";
  }

  @PostMapping("/insertar")
  public String insertarPelicula(@Valid Pelicula pelicula, BindingResult result) {
    if (result.hasErrors()) {
      return "insertar";
    }
    peliculaRepository.save(pelicula);

    return "insertado";
  }

  @GetMapping("/peliculas")
  public String mostrarPeliculas(Model model) {
    model.addAttribute("peliculas", peliculaRepository.findAll());
    return "ver";
  }

  @GetMapping("/editar/{id}")
    public String editarPeliculaFormulario(@PathVariable("id") long id, Model model) {
        Pelicula pelicula = peliculaRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Película con ID (identificador) inválido:" + id));
        model.addAttribute("pelicula", pelicula);
        return "editar";
    }
    
  @PostMapping("/editar/{id}")
  public String editarPelicula(@PathVariable("id") long id, @Valid Pelicula pelicula, BindingResult result) {
        if (result.hasErrors()) {
            pelicula.setId(id);
            return "editar";
        }        
        peliculaRepository.save(pelicula);
        return "editado";
    }
    
  @GetMapping("/borrar/{id}")
  public String borrarPelicula(@PathVariable("id") long id, Model model) {
        Pelicula pelicula = peliculaRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Película con ID (identificador) inválido:" + id));
        peliculaRepository.delete(pelicula);
        
        model.addAttribute("peliculas", peliculaRepository.findAll());
        return "ver";
  }

}
