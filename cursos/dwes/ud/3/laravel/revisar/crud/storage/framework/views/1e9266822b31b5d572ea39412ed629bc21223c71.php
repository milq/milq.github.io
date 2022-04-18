<?php $__env->startSection('main'); ?>

    <nav class='nav nav-pills'>
      <a class='nav-link' href='/'>Inicio</a>
      <a class='nav-link active' href="<?php echo e(route('libros.index')); ?>">Ver</a>
      <a class='nav-link' href="<?php echo e(route('libros.create')); ?>">Añadir</a>
      <a class='nav-link' href="<?php echo e(route('libros.editform')); ?>">Editar</a>
      <a class='nav-link' href="<?php echo e(route('libros.borrarform')); ?>">Borrar</a>
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
          <?php $__currentLoopData = $libros; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $libro): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
          <tr>
            <td><?php echo e($libro->id); ?></td>
            <td><?php echo e($libro->título); ?></td>
            <td><?php echo e($libro->autor); ?></td>
            <td><?php echo e($libro->precio); ?></td>
          </tr>
          <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </tbody>
      </table>
    <div>

<?php $__env->stopSection(); ?>

<?php echo $__env->make('base', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?><?php /**PATH /home/nacho/crud/resources/views/libros/index.blade.php ENDPATH**/ ?>