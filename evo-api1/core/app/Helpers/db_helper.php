<?php

function checkData($query, $params = [], $con = NULL) {
    return count(dbGet($query, $params, $con)) > 0;
}

function dbEscape($val) {
    return str_replace("'", "''", $val);
}

function dbGet($query, $params = [], $con = NULL) {
    if (isEmpty($con)) $con = getConnection();
    $stmt = sqlsrv_query($con, $query, $params);
    
    if (!$stmt) send500Response(\sqlsrv_errors()[0]["message"]);
    
    $data = [];
    while ($obj = \sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        $data[] = $obj;
    }
    return $data;
}

function dbPut($query, $params = [], $con = NULL) {
    if (isEmpty($con)) $con = getConnection();
    $stmt = sqlsrv_query($con, $query, $params);

    if (!$stmt) send500Response(\sqlsrv_errors()[0]["message"]);

    return sqlsrv_rows_affected($stmt);
}

function dbInsert($query, $params = [], $con = NULL) {
    if (isEmpty($con)) $con = getConnection();
    $stmt = sqlsrv_query($con, "$query; SELECT SCOPE_IDENTITY()", $params);

    if (!$stmt) send500Response(sqlsrv_errors()[0]["message"]);

    sqlsrv_next_result($stmt);
    sqlsrv_fetch($stmt);
    return sqlsrv_get_field($stmt, 0); // get lastInsertId
}

function getConnection() {
    $server = env("MSSQL_SERVER");
    $database = env("MSSQL_DB");
    $uid = env("MSSQL_UID");
    $pwd = env("MSSQL_PWD");
    $connectionInfo = ["Database" => $database, "UID" => $uid, "PWD" => $pwd];
    $con = sqlsrv_connect($server, $connectionInfo);
    if (!$con) {
        send500Response("Gagal terhubung ke database!");
    }
    return $con;
}

function transBegin($con) {
    return sqlsrv_begin_transaction($con);
}

function transCommit($con) {
    return sqlsrv_commit($con);
}

function transRollback($con) {
    return sqlsrv_rollback($con);
}
