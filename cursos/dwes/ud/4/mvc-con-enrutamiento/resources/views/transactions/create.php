<?php

$currentPage = 'transactions-create';

include APP_ROOT . '/resources/views/layouts/header.php';

?>

<h1 class='mb-4'>Añadir</h1>

<form action='<?php echo $routes->get('transactions.store')->getPath(); ?>' method='POST'>
    <div class='mb-3'>
        <label for='type' class='form-label'>Tipo:</label>
        <select id='type' name='type' class='form-control' required>
            <option value='income'>Ingreso</option>
            <option value='expense'>Gasto</option>
        </select>
    </div>

    <div class='mb-3'>
        <label for='amount' class='form-label'>Cantidad (€):</label>
        <input type='number' step='0.01' id='amount' name='amount' class='form-control' required>
    </div>

    <div class='mb-3'>
        <label for='date' class='form-label'>Fecha:</label>
        <input type='date' id='date' name='date' class='form-control' required>
    </div>

    <button type='submit' class='btn btn-primary mt-3'>Añadir Transacción</button>
</form>

<?php

include APP_ROOT . '/resources/views/layouts/footer.php';

?>
