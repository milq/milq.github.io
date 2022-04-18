<?php $__env->startSection('main'); ?>

    <nav class='nav nav-pills'>
      <a class='nav-link active' href='/'>Inicio</a>
      <a class='nav-link' href="<?php echo e(route('libros.index')); ?>">Ver</a>
      <a class='nav-link' href="<?php echo e(route('libros.create')); ?>">Añadir</a>
      <a class='nav-link' href="<?php echo e(route('libros.editform')); ?>">Editar</a>
      <a class='nav-link' href="<?php echo e(route('libros.borrarform')); ?>">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Inicio</h2>

    <p>¡Bienvenido! Esta es la página de inicio de una biblioteca básica. Aquí podrás ver, añadir, editar y borrar libros.</p>

<?php $__env->stopSection(); ?>

<?php echo $__env->make('base', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?><?php /**PATH /home/nacho/crud/resources/views/index.blade.php ENDPATH**/ ?>