<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\LibroController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::view('/', 'index');

Route::view('/confirmation', 'confirmation');

Route::get('/libros', [LibroController::class, 'index'])->name('libros.index');
Route::get('/libros/create',[LibroController::class, 'create'])->name('libros.create');
Route::post('/libros',[LibroController::class, 'store'])->name('libros.store');
Route::get('/libros/{id}',[LibroController::class, 'show'])->name('libros.show');
Route::get('/libros/{id}/edit',[LibroController::class, 'edit'])->name('libros.edit');
Route::post('/libros/{id}/update',[LibroController::class, 'update'])->name('libros.update');
Route::get('/libros/{id}/delete',[LibroController::class, 'destroy'])->name('libros.destroy');

//Route::resource('libros', LibroController::class);

Route::get('/editform', function () {
    return view('libros.editform');
})->name('libros.editform');

Route::post('/editform', [LibroController::class, 'editform'])->name('libros.editformid');

Route::get('/borrarform', function () {
    return view('libros.borrarform');
})->name('libros.borrarform');

Route::post('/borrarform', [LibroController::class, 'borrarform'])->name('libros.borrarformid');



