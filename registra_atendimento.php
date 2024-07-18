<?php
require('db_config.php');

$conn = getDbConnection();

$tecnico_id = $_POST['tecnico_id'];
$cliente_id = $_POST['cliente_id'];
$data = $_POST['data'];
$inicio = $_POST['inicio'];
$fim = $_POST['fim'];
$descricao = $_POST['descricao'];
$modalidade_servico = $_POST['modalidade_servico'];

$sql = "INSERT INTO atendimentos (tecnico_id, cliente_id, data, inicio, fim, descricao, modalidade_servico)
VALUES ('$tecnico_id', '$cliente_id', '$data', '$inicio', '$fim', '$descricao', '$modalidade_servico')";

if ($conn->query($sql) === TRUE) {
    $ultimo_id = $conn->insert_id;
    echo "Novo atendimento registrado com sucesso. Número do RAT: " . $ultimo_id;
} else {
    echo "Erro: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>

?>
