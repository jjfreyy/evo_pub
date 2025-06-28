<?php
require_once("vendor/autoload.php");
use \Firebase\JWT\JWT;

function authUser() {
    try {
        $jwt = getRequest()->getHeaders()["Authorization"]->getValue();
        if (isEmpty($jwt)) sendResponse(["msg" => "Empty Token!"], 403);
        $decoded = JWT::decode($jwt, env("JWT_TOKEN"), ["HS256"]);
        return $decoded;
    } catch (\Exception $e) {
        // send500Response(formatException($e));
        send403Response("Invalid Token!");
    }
}

function fetchPost($url, $form_params = null) {
    $client = getClient();
    $response = $client->post($url, ["form_params" => $form_params]);
    return $response;
}

function getClient() {
    $client = new \CodeIgniter\HTTP\CURLRequest(
        new \Config\App(),
        new \CodeIgniter\HTTP\URI(),
        new \CodeIgniter\HTTP\Response(new \Config\App()),
        [
            "baseURI" => env("SOCKET_SERVER_URL"),
            "headers" => [
                "Accept" => "application/json",
                "Authorization" => env("SOCKET_SERVER_SECRET_KEY"),
                "Content-Type" => "application/x-www-form-urlencoded",
            ],
            "http_errors" => false,
        ]
    );
    return $client;
}

function passwordHash($pass) {
    return password_hash(passwordWrap($pass), PASSWORD_BCRYPT);
}

function passwordVerify($pass, $passHash) {
    return password_verify(passwordWrap($pass), $passHash);
}

function passwordWrap($pass) {
    return md5(env("API_TOKEN")). "." .md5($pass);
}

function send403Response($msg = "") {
    return sendResponse(["msg" => isEmpty($msg) ? "Not Allowed." : $msg], 403);
}

function send500Response($msg = "") {
    return sendResponse([
        "msg" => isEmpty($msg) || env("CI_ENVIRONMENT") !== "development" 
            ? "Terjadi kesalahan internal server." : $msg
    ], 500);
}

function sendResponse($body, $statusCode = 200) {
    $body["success"] = false;
    if ($statusCode === 200) $body["success"] = true;

    $response = \Config\Services::response();
    $response->setContentType("application/json");
    $response->setStatusCode($statusCode);
    $response->setBody(json_encode($body));
    $response->send();
    die();
}
