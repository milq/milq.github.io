<?php $__env->startSection('main'); ?>

    <nav class='nav nav-pills'>
      <a class='nav-link' href='/'>Inicio</a>
      <a class='nav-link' href="<?php echo e(route('libros.index')); ?>">Ver</a>
      <a class='nav-link active' href="<?php echo e(route('libros.create')); ?>">Añadir</a>
      <a class='nav-link' href="<?php echo e(route('libros.editform')); ?>">Editar</a>
      <a class='nav-link' href="<?php echo e(route('libros.borrarform')); ?>">Borrar</a>
    </nav>

    <h2 class='display-5 mt-4 mb-3'>Añadir</h2>
    
    <?php if($errors->any()): ?>
    <div class='alert alert-danger'>
      <ul>
        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
          <li><?php echo e($error); ?></li>
        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
      </ul>
    </div>
    <br />
    <?php endif; ?>
    
    <form method='post' action="<?php echo e(route('libros.store')); ?>">
      <?php echo csrf_field(); ?>
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

<?php $__env->stopSection(); ?>

<?php echo $__env->make('base', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?><?php /**PATH /home/nacho/crud/resources/views/libros/create.blade.php ENDPATH**/ ?>