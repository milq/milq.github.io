@extends('base')

@section('main')

    <nav class='nav nav-pills'>
      <a class='nav-link' href='/'>Inicio</a>
      <a class='nav-link' href="{{ route('libros.index')}}">Ver</a>
      <a class='nav-link' href="{{ route('libros.create')}}">Añadir</a>
      <a class='nav-link active' href="{{ route('libros.editform')}}">Editar</a>
      <a class='nav-link' href="{{ route('libros.borrarform')}}">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Editar</h2>

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
        <form method='post' action="{{ route('libros.update', $libro->id) }}">
            @csrf
            <div class='form-group'>
                <label for='título'>Título:</label>
                <input type='text' class='form-control' name='título' value='{{ $libro->título }}' />
            </div>

            <div class='form-group'>
                <label for='descripción'>Autor:</label>
                <input type='text' class='form-control' name='autor' value='{{ $libro->autor }}' />
            </div>

            <div class='form-group mb-3'>
                <label for='precio'>Precio:</label>
                <input type='number' class='form-control' name='precio' value='{{ $libro->precio }}' />
            </div>

            <button type='submit' class='btn btn-primary'>Actualizar</button>
        </form>

@endsection
