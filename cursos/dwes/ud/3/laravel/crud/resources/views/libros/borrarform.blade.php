@extends('base')

@section('main')

    <nav class='nav nav-pills'>
      <a class='nav-link' href='/'>Inicio</a>
      <a class='nav-link' href="{{ route('libros.index')}}">Ver</a>
      <a class='nav-link' href="{{ route('libros.create')}}">Añadir</a>
      <a class='nav-link' href="{{ route('libros.editform')}}">Editar</a>
      <a class='nav-link active' href="{{ route('libros.borrarform')}}">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Borrar</h2>

	<p>Indica el ID del libro a borrar:</p>

    <form method='post' action="{{ route('libros.borrarformid') }}">
      @csrf
      <div class='form-group mb-3'>
        <label for='id'>ID:</label>
        <input type='text' class='form-control' name='id' />
      </div>
      <button type='submit' class='btn btn-primary'>Enviar</button>
    </form>

@endsection
