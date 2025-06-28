<?php

namespace App\Controllers;

require_once("vendor/autoload.php");
use \Firebase\JWT\JWT;

class Put extends BaseController {
    
    function index() {
        if (\getRequestMethod() !== "POST") \send403Response();
        
        try {
            $jwt = authUser();
            $kodePerusahaan = $jwt->Kode_Perusahaan;
            $userID = $jwt->UserID;
            $lokasi = $jwt->Lokasi;

            switch (getPost("type")) {
                case "saveKategori":        
                    $kodeBarang = getPost("kodeBarang");
                    $qty = getPost("qty");
                    
                    if (!\checkData("SELECT 1 FROM Barang WHERE Kode_Perusahaan = ? AND Kode_Stock_Owner = ? AND Kode_Barang = ?", [$kodePerusahaan, $lokasi, $kodeBarang])) sendResponse(["msg" => "Bidang $kodeBarang harus berisi nilai yang sudah ada sebelumnya dalam database."], 400); 

                    $curdate = date("Y-m-d H:i:s");
                    $query = "
                        INSERT INTO cart (Kode_Perusahaan, Tanggal, UserID, Lokasi, Kode_Barang, Qty, Kode_Paket, Disc, Pkt_2, Bonus)
                        VALUES (?, '$curdate', ?, ?, ?, ?, '', 0, '', 'T')
                    ";
                    $params = [$kodePerusahaan, $userID, $lokasi, $kodeBarang, $qty];
                    if (dbPut($query, $params) === 0) sendResponse(["msg" => "Gagal menginput $kodeBarang ke daftar keranjang!"], 400);
                sendResponse(["msg" => "Berhasil memasukkan $kodeBarang ke daftar keranjang"]);
                case "savePaket":
                    $paketan = json_decode(getPost("paketan", false));
                    
                    $con = \getConnection();
                    \transBegin($con);
                    foreach ($paketan as $k => $v) {
                        $kodeBarang = $v->kodeBarang;
                        $jumlah = $v->jumlah;
                        $kodePaket = $v->kodePaket;
                        $disc = $v->disc;
                        $pkt2 = sanitize($v->pkt2, "");
                        $bonus = $v->bonus;
                        
                        $query = "
                            SELECT 1 FROM Cart WHERE Kode_Perusahaan = ? AND UserID = ? AND Lokasi = ? AND Kode_Barang = ? AND Kode_Paket = ? AND Bonus = ?
                        ";
                        $params = [$kodePerusahaan, $userID, $lokasi, $kodeBarang, $kodePaket, $bonus];
                        if (count(dbGet($query, $params, $con)) > 0) {
                            transRollback($con);
                            sendResponse(["msg" => "$kodeBarang / $kodePaket sudah diinput ke daftar keranjang!"], 400);
                        }
                        
                        $curdate = date("Y-m-d H:i:s");
                        $query = "
                            INSERT INTO cart (Kode_Perusahaan, Tanggal, UserID, Lokasi, Kode_Barang, Qty, Kode_Paket, Disc, Pkt_2, Bonus)
                            VALUES (?, '$curdate', ?, ?, ?, ?, ?, ?, ?, ?)
                        ";
                        $params = [$kodePerusahaan, $userID, $lokasi, $kodeBarang, $jumlah, $kodePaket, $disc, $pkt2, $bonus];
                        if (dbPut($query, $params, $con) === 0) {
                            transRollback($con);
                            sendResponse(["msg" => "Gagal menginput $kodePaket ke daftar keranjang!"], 400);
                        }
                    }

                    transCommit($con);
                sendResponse(["msg" => "Berhasil menginput " .count($paketan). " data ke daftar keranjang!"]);
                case "saveCustomerPlafon":
                    $kodeCustomer = getPost("kodeCustomer");
                    $plafonRp = getPost("plafonRp");
                    $plafonJT = getPost("plafonJT");
                    $curdate = date("Y-m-d H:i:s");
                    $noFaktur = getPost("noFaktur");

                    $query = "
                        INSERT INTO Customer_Plafon (Kode_Perusahaan, Kode_Customer, Plafon_Rp, Plafon_JT, Tanggal, Sudah_Sync, No_Faktur, Sudah_Proses)
                        VALUES (?, ?, ?, ?, ?, NULL, ?, NULL)
                    ";
                    $params = [$kodePerusahaan, $kodeCustomer, $plafonRp, $plafonJT, $curdate, $noFaktur];
                    if (dbPut($query, $params) === 0) sendResponse(["msg" => "Gagal memproses data plafon $noFaktur!"], 400);

                sendResponse(["msg" => "Berhasil memproses data plafon $noFaktur!"]);
                case "savePermintaanKeluar":
                    $kodeCustomer = getPost("kodeCustomer");
                    $totalJml = getPost("totalJml");
                    $jenisTrans = getPost("jenisTrans");
                    $detailPermintaanKeluar = json_decode(getPost("detailPermintaanKeluar", false));
                    
                    $query = "SELECT Inisial_Faktur, Selisih_Jam FROM Stock_Owner WHERE Kode_Perusahaan = ? AND Kode_Stock_Owner =?";
                    $params = [$kodePerusahaan, $lokasi];
                    $data = dbGet($query, $params)[0];
                    $inisialFaktur = $data["Inisial_Faktur"];
                    $selisihJam = $data["Selisih_Jam"];
                    $dt = date("Y-m-d H:i:s", strtotime("$selisihJam hour"));
                    $bulanTahun = date("m/y", strtotime($dt));
                    
                    // cari no. urut faktur utk bulan tahun sekarang 
                    $query = "
                        SELECT 
                            ISNULL(
                                CAST(REPLACE(No_Faktur, 'SO-' + SUBSTRING(t1.No_Faktur, 4, 2) + '-' + SUBSTRING(t1.No_Faktur, 7, 5) + '-', '') AS INT), 
                                0
                            ) No_Urut
                        FROM (
                            SELECT MAX(pk.No_Faktur) No_Faktur
                            FROM Permintaan_Keluar pk 
                            WHERE Kode_Perusahaan = ? AND substring(No_Faktur, 4, 2) = ? AND SUBSTRING(No_Faktur, 7, 5) = ?
                        ) t1
                    ";
                    $params = [$kodePerusahaan, $inisialFaktur, $bulanTahun];
                    $noUrut = dbGet($query, $params)[0]["No_Urut"];
                    
                    $noFaktur = "SO-$inisialFaktur-$bulanTahun-" .str_pad(++$noUrut, 5, "0", STR_PAD_LEFT);
                    $tanggal = date("Y-m-d 00:00:00.000", strtotime($dt));
                    $jam = date("H:i:s", strtotime($dt));

                    $con = getConnection();
                    transBegin($con);

                    // insert ke permintaan keluar
                    $query = "
                        INSERT INTO Permintaan_Keluar(Kode_Perusahaan, No_Faktur, Tanggal, Jam, Kode_Customer, UserID, Lokasi, Total_Jml, Harus_Update, JT)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'X', ?)
                    ";
                    $params = [$kodePerusahaan, $noFaktur, $tanggal, $jam, $kodeCustomer, $userID, $lokasi, $totalJml, $jenisTrans];
                    if (dbPut($query, $params, $con) === 0) {
                        transRollback($con);
                        sendResponse(["msg" => "Gagal menginput data permintaan keluar!"], 400);
                    }

                    // insert ke detail permintaan keluar
                    foreach ($detailPermintaanKeluar as $k => $v) {
                        $kodeBarang = $v->kodeBarang;
                        $qty = $v->qty;
                        $kodePaket = $v->kodePaket;
                        $disc = $v->disc;
                        $kodePaket2 = jtrim($v->kodePaket2);
                        $pkt2 = isEmpty($kodePaket2) ? "" : "Y";
                                                
                        $query = "
                            INSERT INTO Detail_Permintaan_Keluar (Kode_Perusahaan, No_Faktur, Kode_Stock_Owner, Kode_Barang, Jumlah, Kode_Pkt, Disc_Prsn, Pkt_2, Kode_Pkt2)
                            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                        ";
                        $params = [$kodePerusahaan, $noFaktur, $lokasi, $kodeBarang, $qty, $kodePaket, $disc, $pkt2, $kodePaket2];
                        if (dbPut($query, $params, $con) === 0) {
                            transRollback($con);
                            sendResponse(["msg" => "Gagal menginput data detail permintaan keluar!"], 400);
                        }
                    }

                    // hapus data item di cart
                    $query = "DELETE FROM Cart WHERE Kode_Perusahaan = ? AND UserID = ? AND Lokasi = ?";
                    $params = [$kodePerusahaan, $userID, $lokasi];
                    if (dbPut($query, $params, $con) === 0) {
                        transRollback($con);
                        sendResponse(["msg" => "Gagal menghapus data barang/paketan di cart!"], 400);
                    }
                    
                    // response jika berhasil
                    transCommit($con);
                sendResponse(["msg" => "Berhasil memproses data permintaan keluar!"]);
                case "updateCartQty":
                    $kodeBarang = getPost("kodeBarang");
                    $qty = getPost("qty");

                    $query = "
                        UPDATE Cart SET
                        Qty = ?
                        WHERE Kode_Perusahaan = ? AND UserID = ? AND Lokasi = ? AND Kode_Barang = ?
                    ";
                    $params = [$qty, $kodePerusahaan, $userID, $lokasi, $kodeBarang];
                    $rowsAffected = dbPut($query, $params);
                    // response gagal update
                    if ($rowsAffected === 0) \sendResponse(["msg" => "Gagal mengupdate data barang!"], 400);

                    // response berhasil update
                \sendResponse(["msg" => "Berhasil mengupdate data barang!"]);
                case "updateLokasi":
                    $con = getConnection();
                    transBegin($con);

                    $newLokasi = getPost("newLokasi");
                    $query = "
                        UPDATE Users SET Lokasi = ? WHERE Kode_Perusahaan = ? AND UserID = ?
                    ";
                    $params = [$newLokasi, $kodePerusahaan, $userID];
                    if (dbPut($query, $params, $con) === 0) sendResponse(["msg" => "Gagal mengupdate lokasi!"], 400);
                    
                    try {
                        $currentTime = time();
                        $payload = [
                            "Kode_Perusahaan" => $kodePerusahaan,
                            "UserID" => $userID, 
                            "UserLevel" => $jwt->UserLevel, 
                            "Lokasi" => $newLokasi, 
                            "iat" => $currentTime, 
                            "exp" => $currentTime + 3600 * 6,
                        ];
                        $newJwt = JWT::encode($payload, env("JWT_TOKEN"));
                        transCommit($con);
                    } catch (\Exception $e) {
                        \transRollback($con);
                        \send500Response();
                    }
                sendResponse(["msg" => "Berhasil mengupdate lokasi!", "data" => ["token" => $newJwt]]);
                case "updatePermintaanKeluar":
                    $noFaktur = getPost("noFaktur");
                    $jenis = getPost("jenis");
         
                    $query = "SELECT 1 FROM Permintaan_Keluar WHERE Kode_Perusahaan = ? AND No_Faktur = ?";
                    $params = [$kodePerusahaan, $noFaktur];
                    if (count(dbGet($query, $params)) === 0) sendResponse(["msg" => "No. Faktur transaksi tidak dapat ditemukan!"], 400);
                    
                    $infoMsg = "Gagal memproses transaksi!";
                    $con = getConnection();
                    \transBegin($con);
                    $query = "UPDATE Permintaan_Keluar SET {SET} WHERE Kode_Perusahaan = ? AND No_Faktur = ?";
                    switch ($jenis) {
                        case "ACC":
                            $query = str_replace("{SET}", "Sudah_Acc_Kacab = 'Y'", $query);    
                            if (dbPut($query, $params, $con) === 0) {
                                $infoMsg = "Transaksi $noFaktur sudah di acc!";
                                goto rollback;
                            }

                            $response = fetchPost("broadcast", ["type" => "permintaanKeluar", "jenis" => $jenis, "noFaktur" => $noFaktur, "userID" => $userID]);
                            if ($response->getStatusCode() !== 200) {
                                $infoMsg = "Transaksi $noFaktur gagal di acc!";
                                goto rollback;
                            }

                            $infoMsg = "Transaksi $noFaktur berhasil di acc!";
                        goto commit;
                        case "SPC":
                            $query = str_replace("{SET}", "Spc_Request = 'Y'", $query);
                            if (dbPut($query, $params, $con) === 0) {
                                $infoMsg = "Transaksi $noFaktur sudah dibuat special request!";
                                goto rollback;
                            }

                            $response = fetchPost("broadcast", ["type" => "permintaanKeluar", "jenis" => $jenis, "noFaktur" => $noFaktur, "userID" => $userID]);
                            if ($response->getStatusCode() !== 200) {
                                $infoMsg = "Transaksi $noFaktur gagal di acc!";
                                goto rollback;
                            } 

                            $infoMsg = "Transaksi $noFaktur berhasil dibuat special request!";
                        goto commit;
                        case "ACC_STOCK":
                            $query = str_replace("{SET}", "Sudah_Stock_Kurang = 'Y'", $query);
                            if (dbPut($query, $params, $con) === 0) {
                                $infoMsg = "Transaksi $noFaktur sudah di acc stock kurang!";
                                goto rollback;
                            } 

                            $infoMsg = "Transaksi $noFaktur berhasil di acc stock kurang!";
                        goto commit;
                        case "BTL":
                            $query = str_replace("{SET}", "Status = 'Y'", $query);
                            if (dbPut($query, $params, $con) === 0) {
                                $infoMsg = "Transaksi $noFaktur sudah dibatalkan!";
                                goto rollback;
                            } 
                            
                            $response = fetchPost("broadcast", ["type" => "permintaanKeluar", "jenis" => $jenis, "noFaktur" => $noFaktur, "userID" => $userID]);
                            if ($response->getStatusCode() !== 200) {
                                $infoMsg = "Transaksi $noFaktur gagal dibatalkan!";
                                goto rollback;
                            }

                            $infoMsg = "Transaksi $noFaktur berhasil dibatalkan!";
                        goto commit;
                        case "REFRESH":
                            $query = str_replace("{SET}", "Sudah_Sync = NULL, Sudah_Proses = NULL, Ada_Problem = NULL, Ket_Problem = NULL", $query);
                            if (dbPut($query, $params, $con) === 0) {
                                $infoMsg = "Gagal merefresh transaksi $noFaktur!";
                                goto rollback;
                            }

                            $infoMsg = "Berhasil merefresh transaksi $noFaktur!";
                        goto commit;
                    }
                
                    rollback:
                        transRollback($con);
                        sendResponse(["msg" => $infoMsg], 400);
                
                    commit:
                        transCommit($con);
                sendResponse(["msg" => $infoMsg]);
                default: 
                    throw new \Exception("Invalid Type!");
            }
        } catch (\Exception $e) {
            \send500Response(formatException($e));
        }
    }

}
