<?php
class DB
{
    private ?PDO $konexioa = null;
    private string $host;
    private string $db;
    private string $user;
    private string $pass;

    public function __construct()
    {
        $this->host = getenv('DB_HOST') ?: 'localhost';
        $this->db = getenv('DB_NAME') ?: 'e1inbentarioa';
        $this->user = getenv('DB_USER') ?: 'wesuser';
        $this->pass = getenv('DB_PASS') !== false ? getenv('DB_PASS') : '123456';
    }

    public function getKonexioa(): PDO
    {
        if ($this->konexioa !== null) {
            return $this->konexioa;
        }

        $dsn = "mysql:host={$this->host};dbname={$this->db};charset=utf8mb4";
        $aukerak = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ];

        try {
            $this->konexioa = new PDO($dsn, $this->user, $this->pass, $aukerak);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            http_response_code(500);
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(['success' => false, 'message' => 'Ezin izan da datu-basera konektatu.']);
            exit;
        }
        return $this->konexioa;
    }
}
