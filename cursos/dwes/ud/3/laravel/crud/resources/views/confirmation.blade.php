@extends('base')

@section('main')

    <nav class='nav nav-pills'>
      <a class='nav-link' href='/'>Inicio</a>
      <a class='nav-link' href="{{ route('libros.index')}}">Ver</a>
      <a class='nav-link' href="{{ route('libros.create')}}">Añadir</a>
      <a class='nav-link' href="{{ route('libros.editform')}}">Editar</a>
      <a class='nav-link' href="{{ route('libros.borrarform')}}">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Confirmación</h2>

    @if(session()->get('success'))
      <div class='alert alert-success'>
        {{ session()->get('success') }}
      </div>
    @else
      <div class='alert alert-danger'>
        La operación no se ha realizado con éxito.
      </div>
    @endif

@endsection
