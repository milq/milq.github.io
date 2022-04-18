<?php $__env->startSection('main'); ?>

    <nav class='nav nav-pills'>
      <a class='nav-link' href='/'>Inicio</a>
      <a class='nav-link' href="<?php echo e(route('libros.index')); ?>">Ver</a>
      <a class='nav-link' href="<?php echo e(route('libros.create')); ?>">Añadir</a>
      <a class='nav-link' href="<?php echo e(route('libros.editform')); ?>">Editar</a>
      <a class='nav-link' href="<?php echo e(route('libros.borrarform')); ?>">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Confirmación</h2>

    <?php if(session()->get('success')): ?>
      <div class='alert alert-success'>
        <?php echo e(session()->get('success')); ?>

      </div>
    <?php else: ?>
      <div class='alert alert-danger'>
        La operación no se ha realizado con éxito.
      </div>
    <?php endif; ?>

<?php $__env->stopSection(); ?>

<?php echo $__env->make('base', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?><?php /**PATH /home/nacho/crud/resources/views/confirmation.blade.php ENDPATH**/ ?>