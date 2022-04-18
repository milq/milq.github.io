<?php $__env->startSection('main'); ?>

    <nav class='nav nav-pills'>
      <a class='nav-link' href='/'>Inicio</a>
      <a class='nav-link' href="<?php echo e(route('libros.index')); ?>">Ver</a>
      <a class='nav-link' href="<?php echo e(route('libros.create')); ?>">Añadir</a>
      <a class='nav-link' href="<?php echo e(route('libros.editform')); ?>">Editar</a>
      <a class='nav-link active' href="<?php echo e(route('libros.borrarform')); ?>">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Borrar</h2>

	<p>Indica el ID del libro a borrar:</p>

    <form method='post' action="<?php echo e(route('libros.borrarformid')); ?>">
      <?php echo csrf_field(); ?>
      <div class='form-group mb-3'>
        <label for='id'>ID:</label>
        <input type='text' class='form-control' name='id' />
      </div>
      <button type='submit' class='btn btn-primary'>Enviar</button>
    </form>

<?php $__env->stopSection(); ?>

<?php echo $__env->make('base', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?><?php /**PATH /home/nacho/crud/resources/views/libros/borrarform.blade.php ENDPATH**/ ?>