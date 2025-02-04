<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8' />
    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=2.0' />
    <title>MVC con enrutamiento</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN' crossorigin='anonymous' />
  </head>
  <body>
    <main class='container'>
      <nav class='navbar navbar-expand-md navbar-dark bg-dark mb-4'>
        <div class='container-fluid'>
          <a class='navbar-brand' href='<?php echo $routes->get('homepage')->getPath(); ?>'>MVC con enrutamiento</a>
          <ul class='navbar-nav me-auto mb-2 mb-md-0'>
            <li class='nav-item'>
              <a class='nav-link active <?php echo ($currentPage == 'home') ? 'bg-secondary' : ''; ?>' href='<?php echo $routes->get('homepage')->getPath(); ?>'>Inicio</a>
            </li>
            <li class='nav-item'>
              <a class='nav-link active <?php echo ($currentPage == 'transactions-index') ? 'active bg-secondary' : ''; ?>' href='<?php echo $routes->get('transactions.index')->getPath(); ?>'>Ver</a>
            </li>
            <li class='nav-item'>
              <a class='nav-link active <?php echo ($currentPage == 'transactions-create') ? 'active bg-secondary' : ''; ?>' href='<?php echo $routes->get('transactions.create')->getPath(); ?>'>Añadir</a>
            </li>
          </ul>
        </div>
      </nav>
