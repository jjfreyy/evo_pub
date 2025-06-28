<?php

namespace App\Controllers;

class Test extends BaseController {

    function index() {
        $method = getRequestMethod();
        $data = $method === "GET" ? getGet() : getPost();
        \sendResponse(["msg" => "Access Granted!", "method" => $method, "data" => $data]);
    }

}
