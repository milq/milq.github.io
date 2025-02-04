<?php

$currentPage = 'transactions-show';

include APP_ROOT . '/resources/views/layouts/header.php';

?>

<h1 class='mb-4'>Ver</h1>

<table class='table'>
    <thead>
        <tr>
            <th>ID</th>
            <th>Fecha</th>
            <th>Tipo</th>
            <th>Cantidad</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <?php echo $transaction->getId(); ?>
            </td>
            <td>
                <?php echo $transaction->getDate(); ?>
            </td>
            <td>
                <?php echo $transaction->getType() === 'income' ? 'Ingreso' : 'Gasto'; ?>
            </td>
            <td class='<?php echo $transaction->getType() === 'income' ? 'text-success' : 'text-danger'; ?>'>
                <?php echo $transaction->getAmount(); ?> &euro;
            </td>
        </tr>
    </tbody>
</table>

<?php

include APP_ROOT . '/resources/views/layouts/footer.php';

?>
