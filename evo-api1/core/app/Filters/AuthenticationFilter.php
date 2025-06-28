<?php
namespace App\Filters;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\Filters\FilterInterface;

class AuthenticationFilter implements FilterInterface {
    function before(RequestInterface $request, $arguments = null) {
        helper(["db", "server", "utils"]);
        try {
            \authUser();
        } catch (\Exception $e) {
            \send500Response(formatException($e));
        }
    }
    
    function after(RequestInterface $request, ResponseInterface $response, $arguments = null) {
    }
}
