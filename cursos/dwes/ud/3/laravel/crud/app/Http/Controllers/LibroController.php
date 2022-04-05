<?php

namespace App\Http\Controllers;

use App\Models\Libro;
use Illuminate\Http\Request;

class LibroController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
		$libros = Libro::all();

		return view('libros.index', compact('libros'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
		return view('libros.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
		$libro_data = $request->validate([
        'título'=>'required|max:100',
        'autor'=>'required|max:255',
        'precio'=>'required|numeric'
		]);

		Libro::create($libro_data);

		return redirect('/confirmation')->with('success', '¡Libro añadido!');
    }

    public function editform(Request $request)
    {
        
        $libro = Libro::findOrFail($request->id);

		return view('libros.edit', compact('libro'));
    }

    public function borrarform(Request $request)
    {
        $libro = Libro::findOrFail($request->id);
        
        $libro->delete();

		return redirect('/confirmation')->with('success', '¡Libro borrado!');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Libro  $libro
     * @return \Illuminate\Http\Response
     */
    public function show(Libro $libro)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Libro  $libro
     * @return \Illuminate\Http\Response
     */
    public function edit(Libro $libro)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Libro  $libro
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {	
        $libro_data = $request->validate([
            'título'=>'required|max:100',
            'autor'=>'required|max:255',
            'precio'=>'required|numeric'
        ]);

		$libro = Libro::findOrFail($request->id);
		$libro->título = $request->título;
		$libro->autor = $request->autor;
		$libro->precio = $request->precio;		
	 
        $libro->save();

		return redirect('/confirmation')->with('success', '¡Libro editado!');
		
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Libro  $libro
     * @return \Illuminate\Http\Response
     */
    public function destroy(Libro $libro)
    {
        //
    }
}
