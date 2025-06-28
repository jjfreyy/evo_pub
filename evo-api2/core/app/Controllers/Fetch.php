<?php

namespace App\Controllers;

class Fetch extends BaseController {

    function index() {
        $method = \getRequestMethod();
        if ($method === "POST") $this->_fetchPost();
        if ($method === "GET") $this->_fetchGet();
        \send403Response();
    }

    private function _fetchGet() {
        try {
            switch (getGet("type")) {
                case "refreshProses":
                    $verifyToken = getGet("verifyToken");
                    if ($verifyToken !== env("VERIFY_TOKEN")) \send403Response();

                    $response = fetchPost("broadcast", ["type" => "permintaanKeluar", "jenis" => "PRS"]);
                    if ($response->getStatusCode() !== 200) {
                        \sendResponse(["msg" => "Gagal refresh!"], 400);
                    }
                    \sendResponse(["msg" => "Berhasil refresh!"]);
                default:
                    throw new \Exception("Invalid Type!");
            }
        } catch (\Exception $e) {
            \send500Response(\formatException($e));
        }
    }

    private function _fetchPost() {
        try {
            $jwt = authUser();
            $kodePerusahaan = $jwt->Kode_Perusahaan;
            $lokasi = $jwt->Lokasi;
            $userID = $jwt->UserID;

            switch (getPost("type")) {
                case "appVersion":
                    $query = "SELECT Nilai FROM Settings WHERE Nama = 'versi'";
                    $data = dbGet($query);
                sendResponse(["data" => $data[0]]);
                case "barang":
                    $kodeKategoriApps = getPost("kodeKategoriApps");
                    $nama = getPost("nama");
                    $query = "
                        SELECT 
                            Kode_Stock_Owner, Kode_Barang, Nama, Kode_Kategori_Apps, Good_Stock, 
                            Image, (CASE WHEN Flag_PPN = 'Y' THEN 10 ELSE 0 END) AS Flag_PPN, Disc1, F_Hrg_Resell_Std, F_Hrg_Resell_Distributor, Satuan, Kode_Satuan_Besar, Isi_Satuan_Besar 
                        FROM Barang 
                        WHERE 
                            Kode_Perusahaan = ? AND 
                            Jenis = 'B' AND 
                            Aktif = 'Y' AND 
                            Frb = 'Y' AND
                            Flag_PPN = 'Y' AND
                            Kode_Stock_Owner = ? AND
                            Kode_Kategori_Apps = ? AND
                            Nama LIKE ?
                        ORDER BY Kode_Stock_Owner, Nama
                    ";
                    $params = [$kodePerusahaan, $lokasi, $kodeKategoriApps, "%$nama%"];
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                case "cart":
                    $query = "
                        SELECT 
                            c.Kode_Perusahaan, c.Tanggal, c.UserID, c.Lokasi, c.Kode_Barang,
                            b.Nama Nama_Barang, b.Satuan, c.Disc, c.Qty, c.Kode_Paket, IIF(c.Kode_Paket = '', 'T', 'Y') Flag_Paket, 
                            b.F_Hrg_Resell_Std Harga, b.Kode_Satuan_Besar, b.Isi_Satuan_Besar, c.Pkt_2 Kode_Paket2
                        FROM Cart c, Barang b
                        WHERE 
                            c.Kode_Perusahaan = b.Kode_Perusahaan AND 
                            c.Lokasi = b.Kode_Stock_Owner AND 
                            c.Kode_Barang = b.Kode_Barang AND 
                            c.Kode_Perusahaan = ? AND 
                            c.Lokasi = ? AND 
                            c.UserID = ?
                        ORDER BY c.Urutan
                    ";
                    $params = [$kodePerusahaan, $lokasi, $userID];
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                case "customers":
                    $kodeCustomer = getPost("kodeCustomer");
                    $query = "
                        SELECT Lokasi, Kode_Customer, Nama, Jenis_Trans 
                        FROM customers 
                        WHERE
                            Kode_Perusahaan = ? AND 
                            Cabang_Sendiri = 'T' AND 
                            Blacklist = 'T' AND 
                            Flag_Audit = 'T' AND 
                            Sdh_Frb IS NULL AND 
                            Frb = 'Y' AND
                            Lokasi = ? AND
                            Nama LIKE ?
                        ORDER BY Lokasi, Nama
                    ";
                    $params = [$kodePerusahaan, $lokasi, "%$kodeCustomer%"];
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                case "detailPaket":
                    $kodePaket = getPost("kodePaket");
                    
                    $query = "
                        SELECT
                            a.Hrs_Budgeting, c.X_Hrg_Mid, a.Kode_SO, a.Kode_Paket, a.Pakai_Range,
                            a.Diskon_Cash, a.Min_Order, a.Pkt_2, a.Max_Order, a.Flag_Satuan_Besar,
                            a.Colly1, a.Colly2, b.Kode_Stock_Owner, b.Kode_Barang, c.Nama, b.Jml, 
                            b.Disc_Persen, b.Kategori, b.Bonus, b.Dari, b.Sampai, 
                            c.F_Hrg_Resell_Std, c.Satuan, c.Disc1, c.Kode_Satuan_Besar, c.Isi_Satuan_Besar 
                        FROM Paket_Retail_New2 a, Paket_Retail_Detail_New2 b, Barang c
                        WHERE
                            a.Kode_Perusahaan = b.Kode_Perusahaan AND 
                            b.Kode_Perusahaan = c.Kode_Perusahaan AND 
                            a.Kode_SO = b.Kode_SO AND 
                            a.Kode_Paket = b.Kode_Paket AND
                            b.Kode_Stock_Owner = c.Kode_Stock_Owner AND
                            b.Kode_Barang = c.Kode_Barang AND 
                            a.Kode_Perusahaan = ? AND 
                            a.Frb = 'Y' AND 
                            a.Aktif = 'Y' AND 
                            a.Aktif_Sementara = 'Y' AND
                            a.Kode_SO = ? AND
                            a.Kode_Paket = ?
                        ORDER BY b.Bonus, c.Nama, a.Kode_SO, a.Kode_Paket
                    ";
                    $params = [$kodePerusahaan, $lokasi, $kodePaket];
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                case "detailPermintaanKeluar":
                    $noFaktur = getPost("noFaktur");
                    $query = "
                        SELECT 
                            dpk.Disc_Prsn, dpk.Jumlah, b.F_Hrg_Resell_Std Harga, b.Nama Nama_Barang, dpk.Kode_Pkt, b.Satuan, b.Kode_Satuan_Besar, b.Isi_Satuan_Besar  
                        FROM Detail_Permintaan_Keluar dpk, Barang b 
                        WHERE 
                            dpk.Kode_Perusahaan = b.Kode_Perusahaan AND 
                            dpk.Kode_Barang = b.Kode_Barang AND 
                            dpk.Kode_Perusahaan = ? AND 
                            dpk.No_Faktur = ? AND 
                            dpk.Kode_Stock_Owner = ?
                        ORDER BY dpk.No_Urut 	
                    ";
                    $params = [$kodePerusahaan, $noFaktur, $lokasi];
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                case "history":
                    $tgl1 = getPost("tgl1");
                    $tgl2 = getPost("tgl2");
                    $query = "
                        SELECT 
                    ";
                case "kategoriBarang":
                    $query = "
                        SELECT Nama, Image 
                        FROM Kategori_Barang
                        WHERE Kode_Perusahaan = ?
                    ";
                    $params = [$kodePerusahaan];
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                case "paket":
                    $kodePaket = getPost("kodePaket");
                    $query = "
                            SELECT
                                Kode_SO, Kode_Paket, Pakai_Range, Diskon_Cash, Min_Order,
                                Pkt_2, Max_Order, Flag_Satuan_Besar, Colly1, Colly2, 
                                Hrs_Budgeting
                            FROM Paket_Retail_New2
                            WHERE
                                Kode_Perusahaan = ? AND
                                Frb = 'Y' AND
                                Aktif = 'Y' AND
                                Aktif_Sementara = 'Y' AND
                                Kode_SO = ? AND
                                Kode_Paket LIKE ?
                            ORDER BY Kode_SO, Kode_Paket
                    ";
                    $params = [$kodePerusahaan, $lokasi, "%$kodePaket%"];
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                case "permintaanKeluar":
                    $query = "
                        SELECT 
                            pk.No_Faktur, c.Kode_Customer, c.Nama Nama_Customer, pk.Lokasi, pk.Tanggal, 
                            pk.Jam, pk.UserID, pk.JT, pk.Selesai, pk.Status, 
                            pk.Sudah_Acc_Kacab, pk.Sudah_Spc_Request, pk.Sudah_Proses, pk.Ada_Problem, pk.Ket_Problem, 
                            pk.Sudah_Sync, pk.Flag_Plafon, pk.Sudah_Plafon, pk.Flag_Lama_JT, pk.Sudah_Lama_JT, 
                            pk.Flag_Stock_Kurang, pk.Sudah_Stock_Kurang
                        FROM Permintaan_Keluar pk, Customers c 
                        WHERE 
                            pk.Kode_Perusahaan = c.Kode_Perusahaan AND 
                            pk.Kode_Customer = c.Kode_Customer AND
                            pk.Kode_Perusahaan = ? AND
                            pk.Lokasi = ? AND  
                    ";
                    $params = [$kodePerusahaan, $lokasi];
                    switch (getPost("hsl")) {
                        case "1":
                            $query .= "
                                pk.Sudah_Acc_Kacab IS NULL AND 
                                pk.Selesai IS NULL AND 
                                pk.Status IS NULL AND 
                                pk.Spc_Request IN ('Y', 'T')
                            ";
                        break;
                        case "2":
                            $query .= "
                                pk.Sudah_Acc_Kacab IS NULL AND
                                pk.Selesai IS NULL AND
                                pk.Status IS NULL AND
                                pk.Spc_Request = 'Y' AND
                                pk.Sudah_Spc_Request IS NULL
                            ";
                        break;
                        case "3":
                            $query .= "
                                pk.Sudah_Acc_Kacab = 'Y' AND
                                pk.Selesai IS NULL AND
                                pk.Status IS NULL
                            ";
                        break;
                        case "4":
                            $tgl1 = getPost("tgl1");
                            $tgl2 = getPost("tgl2");
                            $query .= "
                                pk.Selesai = 'Y' AND 
                                pk.Status IS NULL AND
                                pk.Tanggal BETWEEN ? AND ?
                            ";
                            $params[] = $tgl1;
                            $params[] = $tgl2;
                        break;
                        default: throw new \Exception("Invalid hsl!");
                    }
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                case "roleKota": 
                    $query = "
                        SELECT Kode_Kota FROM Role_Kota 
                        WHERE
                            Kode_Perusahaan = ? and 
                            UserID = ? 
                        ORDER BY Kode_Kota
                    ";
                    $params = [$kodePerusahaan, $userID];
                    $data = dbGet($query, $params);
                sendResponse(["numRows" => count($data), "data" => $data]);
                default: 
                    throw new \Exception("Invalid Type!");
            }
        } catch (\Exception $e) {
            \send500Response(\formatException($e));
        }
    }

}
