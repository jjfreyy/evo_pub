<?php
namespace App\Controllers;

class Auth extends BaseController {

    function index() {
        if (\getRequestMethod() !== "POST") \send403Response();

        try {
            switch (getPost("type")) {
                case "changePassword":
                    $jwt = authUser();
                    $id = $jwt->id;

                    $pass = getPost("pass");
                    $newPass = getPost("newPass");
                    $confirmPass = getPost("confirmPass");

                    $query = "SELECT pass FROM users WHERE id = ?";
                    $params = [$id];
                    $data = dbGet($query, $params);
                    if (isEmptyArray($data)) sendResponse(["msg" => "User tidak dapat ditemukan!"], 400);

                    if (!\passwordVerify($pass, $data[0]["pass"])) {
                        sendResponse(
                            \toResponse("Ubah Password gagal!", getPost(), ["pass" => "Password yang dimasukkan salah!"]), 
                            400
                        );
                    } 

                    $isValidPassword = loadValidation($newPass, "password")->
                        required()->
                        minLength(3)->
                        maxLength(32)->
                        passwordMatch($confirmPass)->
                        result();
                    if (!$isValidPassword["valid"]) {
                        sendResponse(
                            \toResponse("Ubah Password gagal!", getPost(), ["newPass" => $isValidPassword["msg"]]),
                            400
                        );
                    } 

                    $passEncrypt = passwordHash($newPass);
                    $query = "UPDATE users SET pass = ? WHERE id = ?";
                    $params = [$passEncrypt, $id];
                    if (dbPut($query, $params) === 0) throw new \Exception("Update Gagal!");

                sendResponse(["msg" => "Ubah password berhasil!"]);
                case "resetPassword":
                    if (getPost("verifyToken") !== env("VERIFY_TOKEN")) \send403Response("Verify Token must be provided!");
                    $idUser = getPost("idUser");
                    $pass = getPost("pass");
                    $confirmPass = getPost("confirmPass");

                    $isValidPassword = loadValidation($pass, "password")->
                        required()->
                        minLength(3)->
                        maxLength(32)->
                        passwordMatch($confirmPass)->
                        result();
                    if (!$isValidPassword["valid"]) {
                        sendResponse(
                            \toResponse("Reset Password gagal!", getPost(), ["pass" => $isValidPassword["msg"]], [], ["verifyToken"]), 
                            400
                        );
                    } 
                    
                    $passEncrypt = passwordHash($pass);
                    $query = "UPDATE users SET pass = ? WHERE id = ?";
                    $params = [$passEncrypt, $idUser];
                    if (dbPut($query, $params) === 0) throw new \Exception("Gagal Update!");

                sendResponse(["msg" => "Reset Password berhasil!"]);
                case "signin":
                    $username = getPost("username");
                    $pass = getPost("pass");

                    $query = "
                        SELECT u.id, u.namaLengkap, u.pass, u.userLevel, u.idCabang, c.nm cabang, u.idLokasi, l.nm lokasi 
                        FROM users u
                        LEFT JOIN cabang c ON u.idCabang = c.id
                        LEFT JOIN lokasi l ON u.idLokasi = l.id
                        WHERE u.username = ?
                    ";
                    $params = [$username];
                    $dataUser = dbGet($query, $params);

                    if (isEmptyArray($dataUser)) sendResponse(["msg" => "Username/password salah."], 403);

                    $dataUser = $dataUser[0];
                    $id = $dataUser["id"]; 
                    $namaLengkap = $dataUser["namaLengkap"]; 
                    $userLevel = $dataUser["userLevel"];
                    $idCabang = $dataUser["idCabang"];
                    $cabang = $dataUser["cabang"];
                    $idLokasi = $dataUser["idLokasi"];
                    $lokasi = $dataUser["lokasi"];

                    if (!\passwordVerify($pass, $dataUser["pass"])) sendResponse(["msg" => "Username/password salah!"], 403);

                    $currentTime = time();
                    $jwtExpiredTime = dbGet("SELECT val FROM settings WHERE nm = 'jwtExpiredTime'")[0]["val"];
                    $payload = [
                        "id" => $id,
                        "namaLengkap" => $namaLengkap,
                        "username" => $username,
                        "userLevel" => $userLevel,
                        "idCabang" => $idCabang,
                        "cabang" => $cabang,
                        "idLokasi" => $idLokasi,
                        "lokasi" => $lokasi,
                        "iat" => $currentTime,
                        "exp" => $currentTime + $jwtExpiredTime,
                    ]; 
                    $jwt = \jwtEncode($payload);
                sendResponse(["msg" => "Signin berhasil!", "data" => ["token" => $jwt]]);
                case "signup":
                    $namaLengkap = getPost("namaLengkap");
                    $username = getPost("username");
                    $pass = getPost("pass");
                    $confirmPass = getPost("confirmPass");
                    $userLevel = getPost("userLevel");
                    $idCabang = getPost("idCabang");
                    $idLokasi = getPost("idLokasi");

                    $validateArr = [
                        "namaLengkap" => loadValidation($namaLengkap, "nama lengkap")->
                            required()->
                            minLength(3)->
                            maxLength(100)->
                            alphaNumericSpace(),
                        "username" => loadValidation($username, "username")->
                            required()->
                            minLength(3)->
                            maxLength(50)->
                            alphaNumericUnderScore()->
                            isUnique("users", "username"),
                        "pass" => loadValidation($pass, "password")->
                            required()->
                            minLength(3)->
                            maxLength(32)->
                            passwordMatch($confirmPass),
                        "userLevel" => loadValidation($userLevel, "level user")->
                            required()->
                            inList(["1", "2", "3"]),
                    ];
                    switch ($userLevel) {
                        case "1":
                            $idLokasi = null;
                            $idCabang = null;
                        break;
                        case "2":
                            $idLokasi = null;
                            $validateArr["idCabang"] = loadValidation($idCabang, "cabang")->
                                required()->
                                isNotUnique("cabang", "id");
                        break;
                        case "3":
                            $idCabang = null;
                            $validateArr["idLokasi"] = loadValidation($idLokasi, "lokasi")->
                                required()->
                                isNotUnique("lokasi", "id"); 
                        break;
                    }
                    $isValidUser = validate($validateArr);
                    
                    if (!$isValidUser["valid"]) sendResponse(\toResponse("Signup gagal!", getPost(), $isValidUser["errors"], ["idCabang", "idLokasi"]), 400);
                    
                    $passHash = passwordHash($pass);
                    $query = "
                        INSERT INTO users (namaLengkap, username, pass, userLevel, idCabang, idLokasi)
                        VALUES (?, ?, ?, ?, ?, ?);
                    ";
                    $params = [$namaLengkap, $username, $passHash, $userLevel, $idCabang, $idLokasi];
                    if (dbPut($query, $params) === 0) throw new \Exception("Gagal Insert!");

                    // transCommit($con);
                sendResponse(["msg" => "Signup berhasil!"]);
                default:
                    throw new \Exception("Invalid Type!");
            }
        } catch (\Exception $ex) {
            \send500Response(formatException($ex));
        }
    }

}
