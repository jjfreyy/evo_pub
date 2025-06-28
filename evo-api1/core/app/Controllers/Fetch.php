<?php
namespace App\Controllers;

class Fetch extends BaseController {

    function index() {
        if (\getRequestMethod() !== "POST") \send403Response();

        try {
            $jwt = authUser();
            $idUser = $jwt->id;
            $userLevel = $jwt->userLevel;
            $idCabang = $jwt->idCabang;
            $idLokasi = $jwt->idLokasi;
            
            switch (getPost("type")) {
                case "complaints":
                    $tgl1 = getPost("tgl1");
                    $tgl2 = getPost("tgl2");
                    $st = getPost("st");

                    if ($userLevel === 3) {
                        $query = "
                            SELECT
                                c.id, c.tglInput, c.judul, c.deskripsi, c.img, c.st, c.tglSelesai, c.hasil, c.idUser, u.namaLengkap
                            FROM complaints c
                            JOIN users u ON c.idUser = u.id
                            WHERE
                                c.idUser = ? AND 
                                CAST(c.tglInput AS DATE) BETWEEN ? AND ?
                        ";
                        $params = [$idUser, $tgl1, $tgl2];
                    } else {
                        $query = "
                            SELECT 
                                c.id, c.tglInput, c.judul, c.deskripsi, c.img, c.st, c.tglSelesai, c.hasil, c.idUser, u.namaLengkap 
                            FROM complaints c 
                            JOIN users u ON c.idUser = u.id 
                            WHERE       
                        ";
                        $queryLokasi = "u.idLokasi IN (
                            SELECT idLokasi
                            FROM users1 
                            WHERE idUser = ?
                        )";
                        if ($userLevel === 1) {
                            $queryLokasi = "($queryLokasi OR u.idLokasi IS NULL)";
                        } else {
                            $queryLokasi = "($queryLokasi OR c.idUser = $idUser)";
                        }
                        $query  .= "$queryLokasi AND CAST(c.tglInput AS DATE) BETWEEN ? AND ?";
                        $params = [$idUser, $tgl1, $tgl2];
                    }
                    $filterSt = "";
                    if ($st !== "0") {
                        $query .= " AND st = ?";
                        $params[] = intval($st);
                    }
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                case "projects":
                    $query = "
                        SELECT 
                            t1.idProject, 
                            (SELECT noProject FROM projects WHERE idProject = t1.idProject) noProject,
                            (SELECT namaProject FROM projects WHERE idProject = t1.idProject) namaProject,
                            (SELECT keteranganProject FROM projects WHERE idProject = t1.idProject) keteranganProject,
                            (SELECT CONVERT(VARCHAR, tglMulai, 20) FROM projects WHERE idProject = t1.idProject) tglMulai,
                            (SELECT CONVERT(VARCHAR, tglSelesai, 20) FROM projects WHERE idProject = t1.idProject) tglSelesai,
                            STRING_AGG(CONCAT_WS('|', t1.idDetailProject, t1.keteranganDetailProject , t1.logs), '~') logs
                        FROM (
                            SELECT 
                                dp.idProject, 	
                                dp.idDetailProject, 
                                (SELECT keteranganDetailProject FROM detailProjects WHERE idDetailProject = dp.idDetailProject) keteranganDetailProject,
                                STRING_AGG(CONCAT_WS('#', lp.idStatusLog, CONVERT(VARCHAR, lp.tglMulai, 20)), ';') logs
                            FROM detailProjects dp 
                            JOIN projects p ON dp.idProject = p.idProject 
                            LEFT JOIN logProjects lp ON dp.idDetailProject = lp.idDetailProject 
                            WHERE p.idStatusProject != 4
                            GROUP BY dp.idProject, dp.idDetailProject
                        ) t1
                        GROUP BY t1.idProject 
                    ";
                    $data = dbGet($query);
                sendResponse(["numRows" => count($data), "data" => $data]);
                default:
                    throw new \Exception("Invalid Type!");
            }
        } catch (\Exception $ex) {
            \send500Response(\formatException($ex));
        }
    }

}
