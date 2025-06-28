<?php
namespace App\Controllers;

require_once("vendor/autoload.php");
use \Firebase\JWT\JWT;

use App\Controllers\BaseController;

class Auth extends BaseController {
    
    function resetPassword() {
        if (\getRequestMethod() !== "POST" || getPost("type") !== "reset_password" || getPost("verifyToken") !== env("VERIFY_TOKEN")) \send403Response();

        $kodePerusahaan = getPost("kodePerusahaan");
        $userID = getPost("userID");
        $password = getPost("password");
        $konfirmasiPassword = getPost("konfirmasiPassword");

        $isValidPassword = loadValidation($password, "password")->
            required()->
            minLength(3)->
            passwordMatch($konfirmasiPassword)->
            result();

        if (!$isValidPassword["valid"]) sendResponse(["msg" => $isValidPassword["msg"]], 400);

        try {
            $passwordEncrypt = passwordHash($password);
            $query = "UPDATE Users SET MobilePass = ? WHERE Kode_Perusahaan = ? AND UserID = ?";
            $params = [$passwordEncrypt, $kodePerusahaan, $userID];

            if (dbPut($query, $params) === 0) sendResponse(["msg" => "Reset password gagal!"], 400);
            
            sendResponse(["msg" => "Reset Password berhasil!"]);
        } catch (\Exception $ex) {
            \send500Response(\formatException($ex));
        }
    }
    
    function signin() {
        if (\getRequestMethod() !== "POST" || getPost("type") !== "signin") \send403Response();

        $username = getPost("username");
        $password = getPost("password");

        try {
            $query = "SELECT Kode_Perusahaan, UserID, MobilePass, UserLevel, Lokasi FROM Users WHERE UserID = ?";
            $params = [$username];
            $data = dbGet($query, $params);
            
            if (isEmptyArray($data)) sendResponse(["msg" => "Username/password salah."], 403);
            
            $Kode_Perusahaan = $data[0]["Kode_Perusahaan"];
            $UserID = $data[0]["UserID"];
            $MobilePass = $data[0]["MobilePass"];
            $UserLevel = $data[0]["UserLevel"];
            $Lokasi = $data[0]["Lokasi"];
            
            if (!passwordVerify($password, $MobilePass)) sendResponse(["msg" => "Username/Password salah!"], 403);
            
            $currentTime = time();
            $payload = [
                "Kode_Perusahaan" => $Kode_Perusahaan,
                "UserID" => $UserID, 
                "UserLevel" => $UserLevel, 
                "Lokasi" => $Lokasi, 
                "iat" => $currentTime, 
                "exp" => $currentTime + 3600 * 6,
            ];
            $jwt = JWT::encode($payload, env("JWT_TOKEN"));
            sendResponse(["msg" => "Berhasil Login!", "data" => ["token" => $jwt]]);
        } catch (\Exception $ex) {
            \send500Response(formatException($ex));
        }
    }

    function changePassword() {
        if (\getRequestMethod() !== "POST" || getPost("type") !== "ubah_password") \send403Response();

        $passwordLama = getPost("passwordLama");
        $passwordBaru = getPost("passwordBaru");
        $konfirmasiPassword = getPost("konfirmasiPassword");

        try {
            $jwt = authUser();
            $kodePerusahaan = $jwt->Kode_Perusahaan;
            $userID = $jwt->UserID;

            $query = "SELECT MobilePass FROM Users WHERE Kode_Perusahaan = ? AND UserID = ?";
            $params = [$kodePerusahaan, $userID];
            $data = dbGet($query, $params);

            if (isEmptyArray($data)) sendResponse(["msg" => "UserID tidak dapat ditemukan!"], 403);

            if (!passwordVerify($passwordLama, $data[0]["MobilePass"])) sendResponse(["msg" => "Password yang dimasukkan salah!"], 403);

            $isValidPassword = loadValidation($passwordBaru, "password")->
                required()->
                minLength(3)->
                passwordMatch($konfirmasiPassword)->
                result();

            if (!$isValidPassword["valid"]) sendResponse(["msg" => $isValidPassword["msg"]], 400);

            $passwordEncrypt = passwordHash($passwordBaru);
            $query = "UPDATE Users SET MobilePass = ? WHERE Kode_Perusahaan = ? AND UserID = ?";
            $params = [$passwordEncrypt, $kodePerusahaan, $userID];

            if (dbPut($query, $params) === 0) sendResponse(["msg" => "Ganti password gagal!"], 400);

            sendResponse(["msg" => "Ganti password berhasil!"]);
        } catch (\Exception $ex) {
            \send500Response(formatException($ex));
        }
    }
}
