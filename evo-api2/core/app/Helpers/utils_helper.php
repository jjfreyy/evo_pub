<?php

function checkFile($file) {
    return !empty(glob($file));
}

function coalesce($value, $assign = null, $allowZero = true) {
    if (is_array($assign)) {
        $allowZero = $assign["allowZero"] ?? $allowZero;
        $assign = $assign["assign"] ?? null;
    }

    if (!is_array($value)) $value = [$value];
    foreach ($value as $v) {
        if (!isEmpty($v, $allowZero)) return $v;
    }
    return $assign;
}

function convertCurrencyToNumber($number, $toCurrency = false) {
    if ($toCurrency) {
        try {
            $number = convertNumberToCurrency($number);
        } catch (\Throwable $e) {}
    }
    $number = str_replace(".", "", $number);
    return str_replace(",", ".", $number);
}

function convertNumberToCurrency($number, $toNumber = false) {
    if ($toNumber) $number = convertCurrencyToNumber($number);
    if (isEmpty($number) || $number === "-") return $number;
    $numberArr = explode(".", $number);
    if (!isset($numberArr[1]) || (isset($numberArr[1]) && $numberArr[1] == 0)) $decimal = 0;
    else $decimal = 2;

    try {
        return number_format($number, $decimal, ",", ".");
    } catch (\Throwable $e) {
        return $number;
    }
}

function jtrim($str, $charlist = "") {
    $isArray = is_array($str);
    if (!$isArray) $str = [$str];
    for ($i = 0; $i < count($str); $i++) {
        $str[$i] = trim(preg_replace("/[\s]+/", " ", $str[$i]), " \t\n\r\0\x0B$charlist");
    }
    return $isArray ? $str : $str[0];
}

function debug($val, $die = true) {
    if (isEmpty($val, false)) var_dump($val);
    else {
        echo "<pre>";
        print_r($val);
        echo "</pre>";
    } 
    if ($die) die();
}

function formatException($e, $addslashes = false) {
    return get_class($e). " at " .$e->getFile(). " line " .$e->getLine(). ": " .(!$addslashes ? $e->getMessage() : \addslashes($e->getMessage()));
}

function generateRandomToken($len = 32) {
    return bin2hex(openssl_random_pseudo_bytes($len / 2));
}

function getGet($name = null, $sanitize = true, $decodeUrl = true, $default = null) {
    if (is_array($sanitize)) {
        $decodeUrl = $sanitize["decodeUrl"] ?? $decodeUrl;
        $default = $sanitize["default"] ?? $default;
        $sanitize = $sanitize["sanitize"] ?? true;
    }
    $request = getRequest();
    if (isEmpty($name)) return $request->getGet();
    $value = $request->getGet($name);
    if ($decodeUrl) $value = urldecode($value);
    if ($sanitize) $value = sanitize($value);
    return ifEmptyThen($value, $default);
}

function getGetArray($names, $sanitize = true, $decode_url = true, $default = null, $assoc = false) {
    if (is_array($sanitize)) {
        $decode_url = $sanitize["decode_url"] ?? $decode_url;
        $default = $sanitize["default"] ?? $default;
        $assoc = $sanitize["assoc"] ?? $assoc;
        $sanitize = $sanitize["sanitize"] ?? true;
    }

    $values = [];
    if (!is_array($names)) $names = [$names];
    foreach ($names as $name) {
        $values[$name] = getGet($name, $sanitize, $decode_url, $default);
    }

    return $assoc ? $values : array_values($values);
}

function getPost($name = null, $sanitize = true, $default = null) {
    if (is_array($sanitize)) {
        $default = $sanitize["default"] ?? $default;
        $sanitize = $sanitize["sanitize"] ?? true;
    }

    $request = getRequest();
    if (isEmpty($name)) return $request->getPost();
    $value = $request->getPost($name);
    if ($sanitize) $value = sanitize($value);
    return ifEmptyThen($value, $default);
}

function getPostArray($names, $sanitize = true, $default = null, $assoc = true) {
    if (is_array($sanitize)) {
      $default = $sanitize["default"] ?? $default;
      $assoc = $sanitize["assoc"] ?? $assoc;
      $sanitize = $sanitize["sanitize"] ?? true;
    }
  
    $values = [];
    if (!is_array($names)) $names = [$names];
    foreach ($names as $name) {
        $values[$name] = getPost($name, $sanitize, $default);
    }
  
    return $assoc ? $values : array_values($values);
}

function getRequest() {
    return \Config\Services::request();
}

function getRequestMethod() {
    return getRequest()->getMethod(true);
}

function ifEmptyThen($value, $assign = "-", $allowZero = true) {
    if (is_array($assign)) {
        $allowZero = $assign["allowZero"] ?? $allowZero;
        $assign = $assign["assign"] ?? "-";
    }
    if (isEmpty($value, $allowZero)) return $assign;
    return $value;
}

function isEmpty($str, $allowZero = true) {
    if (!isset($str)) return true;
    if ($allowZero && (($str === 0 || $str === "0") || (is_bool($str) && !$str))) return false;
    return empty($str);
}

function isEmptyArray($arr, $deepFilter = false) {
    $isEmpty = !isset($arr) || !is_array($arr) || empty($arr);
    if ($isEmpty || !$deepFilter) return $isEmpty;
    foreach ($arr as $k => $v) {
        if (isEmpty($v)) return true;
    }
    return false;
}

function loadValidation($val, $label) {
    return App\Libraries\Validation::set($val, $label);
}

function sanitize($data, $default = null) {
    $isArray = is_array($data);
    if (!$isArray) $data = [$data];
    foreach ($data as $k => $v) {
        $data[$k] = strip_tags(jtrim($v));
        $data[$k] = preg_replace("/[\\\]{2}/", "\\", $v);
        $data[$k] = str_replace("\\'", "'", $v);
        if (in_array($data[$k], ["true", "false"])) {
            $data[$k] = $v === "true";
            continue;
        }
        $data[$k] = coalesce($v, $default);
    }
    if (!$isArray) {
        foreach ($data as $k => $v) return $v;
    }
    return $data;
}

function toResponse($msg, $inputData, $errorData) {
    if (isEmptyArray($inputData)) return ["success" => true, "msg" => $msg];
    $feedbacks = [];
    foreach ($inputData as $k => $v) {
        if (is_array($v)) {
            $feedbacks[$k] = [
                "vals" => $v,
                "msgs" => $errorData[$k] ?? null,
            ];
            continue;
        }

        $feedbacks[$k] = [
            "val" => in_array($k, ["password", "confirmPassword"]) ? null : $v,
            "msg" => $errorData[$k] ?? null,
        ];
    }

    $response = [
        "success" => false,
        "msg" => $msg,
        "feedbacks" => $feedbacks,
    ];
    return $response;
}

function validate($fields) {
    $isValid = true;
    $errors = [];
    foreach ($fields as $k => $v) {
        $result = $v->result();
        if (!$result["valid"]) {
            $errors[$k] = $result["msg"];
            $isValid = false;
        }
    }

    if (!$isValid) return ["valid" => false, "errors" => $errors];
    return ["valid" => true];
}
