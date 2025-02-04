<?php

namespace App;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\RequestContext;
use Symfony\Component\Routing\RouteCollection;
use Symfony\Component\Routing\Matcher\UrlMatcher;
use Symfony\Component\Routing\Exception\MethodNotAllowedException;
use Symfony\Component\Routing\Exception\ResourceNotFoundException;
use Symfony\Component\Routing\Exception\NoConfigurationException;

class Router
{
    private RequestContext $context;
    private UrlMatcher $matcher;

    public function __construct()
    {
        $this->context = new RequestContext();
        $this->context->fromRequest(Request::createFromGlobals());
    }

    public function handle(RouteCollection $routes)
    {
        $this->matcher = new UrlMatcher($routes, $this->context);
        try {
            $arrayUri = explode('?', $_SERVER['REQUEST_URI']);
            $matchedRoute = $this->matcher->match($arrayUri[0]);

            array_walk($matchedRoute, function(&$param) {
                if (is_numeric($param)) {
                    $param = (int) $param;
                }
            });

            $className = '\\App\\Http\\Controllers\\' . $matchedRoute['controller'];
            $classInstance = new $className();

            $params = array_merge(array_slice($matchedRoute, 2, -1), ['routes' => $routes]);

            call_user_func_array([$classInstance, $matchedRoute['method']], $params);

        } catch (MethodNotAllowedException $e) {
            echo 'Route method is not allowed.';
        } catch (ResourceNotFoundException $e) {
            echo 'Route does not exist.';
        } catch (NoConfigurationException $e) {
            echo 'Configuration does not exist.';
        }
    }
}

$router = new Router();
$router->handle($routes);
