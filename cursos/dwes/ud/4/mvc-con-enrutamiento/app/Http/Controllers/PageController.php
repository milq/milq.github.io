<?php

namespace App\Http\Controllers;

use Symfony\Component\Routing\RouteCollection;

class PageController
{
    public function home(RouteCollection $routes)
    {
        require_once APP_ROOT . '/resources/views/home.php';
    }
}
