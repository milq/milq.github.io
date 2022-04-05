package io.github.milq.filmoteca;

import java.util.List;
import io.github.milq.filmoteca.Pelicula;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PeliculaRepository extends CrudRepository<Pelicula, Long> {}
