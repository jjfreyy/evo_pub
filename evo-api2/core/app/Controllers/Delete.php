<?php

namespace App\Controllers;

class Delete extends BaseController {
    function index() {
        if (\getRequestMethod() !== "POST") \send403Response();
        
        try {
            $jwt = authUser();
            $kodePerusahaan = $jwt->Kode_Perusahaan;
            $userID = $jwt->UserID;
            $lokasi = $jwt->Lokasi;

            switch (getPost("type")) {
                case "deleteCartItem":          
                    $kodeBarang = getPost("kodeBarang");
                    $kodePaket = getPost("kodePaket");
                        
                    $query = "DELETE FROM Cart WHERE Kode_Perusahaan = ? AND UserID = ? AND Lokasi = ?";
                    $params = [$kodePerusahaan, $userID, $lokasi];
                    if (isEmpty($kodePaket)) { // Satuan
                        $query .= " AND Kode_Barang = ?";
                        $params[] = $kodeBarang;
                    } else { // Paketan
                        $query .= " AND Kode_Paket = ?";
                        $params[] = $kodePaket;
                    }

                    $rowsAffected = dbPut($query, $params);
                    // response gagal hapus
                    if ($rowsAffected === 0) sendResponse(["msg" => "Gagal menghapus data barang/paketan!"], 400);
                
                // response berhasil hapus
                sendResponse(["msg" => "Berhasil menghapus $rowsAffected data barang/paketan dari daftar keranjang!"]);
            }
        } catch (\Exception $e) {
            \send500Response(\formatException(e));
        }
    }
}
