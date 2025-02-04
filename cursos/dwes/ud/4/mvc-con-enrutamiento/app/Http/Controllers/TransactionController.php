<?php

namespace App\Http\Controllers;

use Symfony\Component\Routing\RouteCollection;

use App\Models\Transaction;

class TransactionController
{
    public function index(RouteCollection $routes)
    {
        $transactions = Transaction::readAll();

        require_once APP_ROOT . '/resources/views/transactions/index.php';
    }

    public function create(RouteCollection $routes)
    {
        require_once APP_ROOT . '/resources/views/transactions/create.php';
    }

    public function store(RouteCollection $routes)
    {
        $transaction = new Transaction();

        $transaction->setType($_POST['type']);
        $transaction->setAmount($_POST['amount']);
        $transaction->setDate($_POST['date']);

        $transaction->create();

        require_once APP_ROOT . '/resources/views/transactions/store.php';
    }

    public function show(int $id, RouteCollection $routes)
    {
        $transaction = new Transaction();
        $transaction->read($id);

        require_once APP_ROOT . '/resources/views/transactions/show.php';
    }
}
