<?php
require_once("vendor/autoload.php");
use \Firebase\JWT\JWT;
use \Firebase\JWT\Key;

function authUser() {
    try {
        $jwt = getRequest()->getHeaders()["Authorization"]->getValue();
        if (isEmpty($jwt)) sendResponse(["msg" => "Empty Token!"], 403);
        $decoded = jwtDecode($jwt);
        return $decoded;
    } catch (\Exception $e) {
        send403Response("Invalid Token!");
    }
}

function compressImage($filePath, $maintainRatio = true, $width = 1280, $height = 720) {
    if (is_array($maintainRatio)) {
        $width = $maintainRatio["width"] ?? $width;
        $height = $maintainRatio["height"] ?? $height;
        $maintainRatio = $maintainRatio["maintainRatio"] ?? true;
    }

    return \Config\Services::image()->withFile($filePath)->resize($width, $height, $maintainRatio)->save($filePath);
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
            "baseURI" => "https://fcm.googleapis.com",
            "headers" => [
                "Authorization" => "key=AAAAR2qPvqs:APA91bGi6K-V82yBW4_OEU8FJmRxJXoQC4JF1wMAb78IyihB8Kf8J7CkUKl-TCKQSP2RZXj4Nn3fCCj46sEE19yaB4QH5KdCPaCNRrDZQyj0Z7_wrRiUOL2FiE5eEe_m1T-n_TgqUjuR",
                "Content-Type" => "application/json",
            ],
            "http_errors" => false,
        ]
    );
    return $client;
}

function jwtDecode($jwt) {
    return JWT::decode($jwt, new Key(env("JWT_TOKEN"), "HS256"));
}

function jwtEncode($payload) {
    return JWT::encode($payload, env("JWT_TOKEN"), "HS256");
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

function sendNotif($topics, $title, $body) {
    $data = [
        "to" => "/topics/$topics",
        "notification" => [
            "title" => $title,
            "body" => $body,
        ],
    ];
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_HTTPHEADER, array(
        'Content-Type: application/json',
        'Authorization: key=AAAAR2qPvqs:APA91bGi6K-V82yBW4_OEU8FJmRxJXoQC4JF1wMAb78IyihB8Kf8J7CkUKl-TCKQSP2RZXj4Nn3fCCj46sEE19yaB4QH5KdCPaCNRrDZQyj0Z7_wrRiUOL2FiE5eEe_m1T-n_TgqUjuR',
    ));
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($data));

    $result = curl_exec($curl);
    curl_close($curl);
    return $result;
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
