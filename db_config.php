<?php
// Informações de acesso ao banco de dados
$servername = "localhost";
$username = "alessandro";
$password = "ale@2024";
$dbname = "rat_db";

// Função para conectar ao banco de dados
function getDbConnection() {
    global $servername, $username, $password, $dbname;
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Verifica se a conexão falhou
    if ($conn->connect_error) {
        die("Conexão falhou: " . $conn->connect_error);
    }

    return $conn;
}
?>
