<?php
$servername = "localhost";
$username = "rat_user";
$password = "senha_segura";
$dbname = "rat_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Conexão falhou: " . $conn->connect_error);
}

$tecnico_id = $_POST['tecnico_id'];
$cliente_id = $_POST['cliente_id'];
$data = $_POST['data'];
$descricao = $_POST['descricao'];

$sql = "INSERT INTO atendimentos (tecnico_id, cliente_id, data, descricao)
VALUES ('$tecnico_id', '$cliente_id', '$data', '$descricao')";

if ($conn->query($sql) === TRUE) {
    $ultimo_id = $conn->insert_id;
    echo "Novo atendimento registrado com sucesso. Número de RAT: " . $ultimo_id;
} else {
    echo "Erro: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>
