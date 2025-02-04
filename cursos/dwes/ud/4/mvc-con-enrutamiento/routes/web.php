<?php

use Symfony\Component\Routing\Route;
use Symfony\Component\Routing\RouteCollection;

$routes = new RouteCollection();

$routes->add('homepage', new Route(BASE_PATH . '/', array('controller' => 'PageController', 'method'=>'home')));
$routes->add('transactions.show', new Route(BASE_PATH . '/transactions/{id}', array('controller' => 'TransactionController', 'method'=>'show'), array('id' => '[0-9]+')));
$routes->add('transactions.create', new Route(BASE_PATH . '/transactions/create', array('controller' => 'TransactionController', 'method'=>'create')));
$routes->add('transactions.store', new Route(BASE_PATH . '/transactions/store', array('controller' => 'TransactionController', 'method'=>'store')));
$routes->add('transactions.index', new Route(BASE_PATH . '/transactions/index', array('controller' => 'TransactionController', 'method'=>'index')));

?>
