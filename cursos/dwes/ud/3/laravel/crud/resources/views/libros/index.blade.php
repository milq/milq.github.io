@extends('base')

@section('main')

    <nav class='nav nav-pills'>
      <a class='nav-link' href='/'>Inicio</a>
      <a class='nav-link active' href="{{ route('libros.index')}}">Ver</a>
      <a class='nav-link' href="{{ route('libros.create')}}">Añadir</a>
      <a class='nav-link' href="{{ route('libros.editform')}}">Editar</a>
      <a class='nav-link' href="{{ route('libros.borrarform')}}">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Libros</h2>

    <div class='row'>
    <div class='col-sm-12'>
      
      <table class='table table-striped'>
        <thead>
          <tr>
            <td>ID</td>
            <td>Título</td>
            <td>Autor</td>
            <td>Precio</td>
          </tr>
        </thead>
        <tbody>
          @foreach($libros as $libro)
          <tr>
            <td>{{$libro->id}}</td>
            <td>{{$libro->título}}</td>
            <td>{{$libro->autor}}</td>
            <td>{{$libro->precio}}</td>
          </tr>
          @endforeach
        </tbody>
      </table>
    <div>

@endsection
