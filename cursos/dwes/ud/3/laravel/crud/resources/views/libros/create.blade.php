@extends('base')

@section('main')

    <nav class='nav nav-pills'>
      <a class='nav-link' href='/'>Inicio</a>
      <a class='nav-link' href="{{ route('libros.index')}}">Ver</a>
      <a class='nav-link active' href="{{ route('libros.create')}}">Añadir</a>
      <a class='nav-link' href="{{ route('libros.editform')}}">Editar</a>
      <a class='nav-link' href="{{ route('libros.borrarform')}}">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Añadir</h2>
    
    @if ($errors->any())
    <div class='alert alert-danger'>
      <ul>
        @foreach ($errors->all() as $error)
          <li>{{ $error }}</li>
        @endforeach
      </ul>
    </div>
    <br />
    @endif
    
    <form method='post' action="{{ route('libros.store') }}">
      @csrf
      <div class='form-group'>
        <label for='título'>Título:</label>
        <input type='text' class='form-control' name='título' />
      </div>
      <div class='form-group'>
        <label for='descripción'>Autor:</label>
        <input type='text' class='form-control' name='autor' />
      </div>
      <div class='form-group mb-3'>
        <label for='precio'>Precio:</label>
        <input type='number' class='form-control' name='precio' />
      </div>
      <button type='submit' class='btn btn-primary'>Añadir</button>
    </form>

@endsection
