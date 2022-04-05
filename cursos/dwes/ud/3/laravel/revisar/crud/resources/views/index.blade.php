@extends('base')

@section('main')

    <nav class='nav nav-pills'>
      <a class='nav-link active' href='/'>Inicio</a>
      <a class='nav-link' href="{{ route('libros.index')}}">Ver</a>
      <a class='nav-link' href="{{ route('libros.create')}}">Añadir</a>
      <a class='nav-link' href="{{ route('libros.editform')}}">Editar</a>
      <a class='nav-link' href="{{ route('libros.borrarform')}}">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Inicio</h2>

    <p>¡Bienvenido! Esta es la página de inicio de una biblioteca básica. Aquí podrás ver, añadir, editar y borrar libros.</p>

@endsection
