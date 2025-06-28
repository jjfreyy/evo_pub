<?php
namespace App\Controllers;

class Put extends BaseController {

    function index() {
        if (\getRequestMethod() !== "POST") \send403Response();

        try {
            $jwt = authUser();
            $idUser = $jwt->id;
            $namaLengkap = $jwt->namaLengkap;
            $username = $jwt->username;
            $userLevel = $jwt->userLevel;
            $idCabang = $jwt->idCabang;
            $idLokasi = $jwt->idLokasi;
            
            switch (getPost("type")) {
                case "saveComplaint":
                    $id = getPost("id");
                    $judul = getPost("judul");
                    $deskripsi = getPost("deskripsi");
                    $img = \getRequest()->getFile("img");
                    $saveImg = getPost("saveImg");

                    $validateArr = [
                       "judul" => \loadValidation($judul, "judul")->
                            required()->
                            minLength(3)->
                            maxLength(50)->
                            alphaNumericSpace(),
                        "deskripsi" => \loadValidation($deskripsi, "dekripsi")->
                            required()->
                            minLength(3)->
                            maxLength(500)->
                            alphaNumericPunct(),
                    ];
                    if (!isEmpty($id)) {
                        $validateArr["id"] = \loadValidation($id, "komplain")->
                            isNotUnique("complaints", "id");
                    }
                    $isValid = validate($validateArr);
                    if (!$isValid["valid"]) \sendResponse(\toResponse("Gagal memproses data komplain!", getPost(), $isValid["errors"], ["img"], ["type", "saveImg"]), 400);

                    if ($saveImg) {
                        if ($img === null) \sendResponse(\toResponse("Gagal memproses data komplain!", getPost(), ["img" => "Bidang gambar diperlukan."], ["img"]), 400);

                        if ($img->getError() === 1) sendResponse(toResponse("Gagal memproses data komplain!", getPost(), ["img" => "Ukuran file melebihi " .ini_get("upload_max_filesize"). "!"], ["img"]), 400);

                        if ($img->getError() !== 0) sendResponse(toResponse("Gagal memproses data komplain!", getPost(), ["img" => "Gagal menyimpan gambar!"], ["img"]), 400);

                        if (!in_array(strtolower($img->getExtension()), ["jpeg", "jpg", "png"])) \sendResponse(\toResponse("Gagal memproses data komplain!", getPost(), ["img" => "Bidang gambar harus berekstensi jpeg/jpg/png."], ["img"], ["type", "saveImg"]), 400);
                
                        $imgName = "u$idUser-" .\uniqid(). "." .$img->getExtension();
                        $img->move("uploads/complaints/", $imgName);
                        compressImage("uploads/complaints/$imgName");
                    }
                    
                    if (isEmpty($id)) {
                        $notifMsg = "Komplain baru dari $namaLengkap";
                        $currentDate = date("Y-m-d H:i:s");
                        $query = "
                            INSERT INTO complaints (tglInput, judul, deskripsi, img, idUser)
                            VALUES (?, ?, ?, ?, ?)
                        ";
                        $params = [$currentDate, $judul, $deskripsi, $imgName, $idUser];
                    } else {
                        $notifMsg = "Update komplain $id dari $namaLengkap";
                        $query = "UPDATE complaints SET judul = ?, deskripsi = ?";
                        $params = [$judul, $deskripsi];
                        if ($saveImg) {
                            $query .= ", img = ?";
                            $params[] = $imgName;
                        }
                        $query .= " WHERE id = ?";
                        $params[] = $id;
                    }
                    if (dbPut($query, $params) === 0) {
                        throw new \Exception("Gagal Insert/Update!");
                    }

                    if (in_array($userLevel, ["1", "2"])) {
                        $query = "
                            SELECT id, username 
                            FROM users
                            WHERE userLevel = 1 AND id != $idUser
                        ";
                    } else {
                        $query = "
                            SELECT u.id, u.username
                            FROM users u
                            JOIN users1 u1 ON u.id = u1.idUser 
                            WHERE u1.idLokasi = $idLokasi AND u.id != $idUser
                        ";
                    }
                    
                    $data = dbGet($query);
                    foreach ($data as $v) {
                        \sendNotif($v["username"], $notifMsg, $judul);
                    }
                sendResponse(["msg" => "Berhasil memproses data komplain!"]);
                case "updateComplaintStatus":
                    if ($userLevel !== 1) {
                        sendResponse(["msg" => "Anda tidak memiliki akses untuk mengupdate data komplain!"], 400);
                    }

                    $id = getPost("id");
                    $st = getPost("st");
                    $query = "UPDATE complaints SET st = ? WHERE id = ?";
                    $params = [$st, $id];
                    dbPut($query, $params);
                sendResponse(["msg" => "Berhasil mengupdate status komplain!"]);
                case "updateComplaintSelesai":
                    if ($userLevel !== 1) {
                        sendResponse(["msg" => "Anda tidak memiliki akses untuk mengupdate data komplain!"], 400);
                    }
                    
                    $id = getPost("id");
                    $hasil = getPost("hasil");
                    $currentDate = date("Y-m-d H:i:s");
                    $query = "UPDATE complaints SET st = 3, hasil = ?, tglSelesai = ? WHERE id = ?";
                    $params = [$hasil, $currentDate, $id];
                    dbPut($query, $params);

                    $query = "
                        SELECT c.id idComplaint, u.id, u.username, c.judul
                        FROM complaints c
                        JOIN users u ON c.idUser = u.id
                        WHERE c.id = ?
                    ";
                    $params = [$id];
                    $data = dbGet($query, $params);
                    foreach ($data as $v) {
                        sendNotif($v["username"], "Komplain dengan id " .$v["idComplaint"]. " telah selesai.", $v["judul"]);
                    }
                sendResponse(["msg" => "Berhasil mengupdate komplain!"]);
                case "updateDetailProjectStatus":
                    $idProject = getPost("idProject");
                    $keteranganDetailProject = getPost("keteranganDetailProject");
                    $idDetailProject = getPost("idDetailProject");
                    $idStatusLog = getPost("idStatusLog");
                    $currentDate = date("Y-m-d H:i:s");

                    $con = getConnection();

                    transBegin($con);

                    $query = "
                        INSERT INTO logProjects (idDetailProject, idStatusLog, tglMulai)
                        VALUES (?, ?, '$currentDate')
                    ";
                    $params = [$idDetailProject, $idStatusLog];
                    dbPut($query, $params, $con);

                    $query = "
                        SELECT 
                            p.idProject, dp.idDetailProject,
                            (SELECT TOP 1 idStatusLog FROM logProjects WHERE idDetailProject = dp.idDetailProject ORDER BY idLog DESC) idStatusLog
                        FROM projects p 
                        JOIN detailProjects dp ON p.idProject = dp.idProject 
                        WHERE p.idProject = ?
                    ";
                    $params = [$idProject];
                    $data = dbGet($query, $params, $con);
                    $isFinish = true;
                    if (isEmptyArray($data)) {
                        $isFinish = false;
                    } else {
                        foreach ($data as $v) {
                            if ($v["idStatusLog"] === 6) continue;

                            $isFinish = false;
                            break;
                        }
                    }

                    if ($isFinish) {
                        $query = "UPDATE projects SET tglSelesai = '$currentDate', idStatusProject = 4 WHERE idProject = ?";
                        $params = [$idProject];
                        dbPut($query, $params, $con);
                    }

                    transCommit($con);
                sendResponse(["msg" => "Berhasil mengubah status $keteranganDetailProject!"]);
                default:
                    throw new \Exception("Invalid Type!");
            }
        } catch (\Exception $ex) {
            \send500Response(\formatException($ex));
        }
    }

}
