<?php

// mysql/mariadb datu-basearekiko konexioa kudeatzen du PDO erabiliz.
class DB
{
    private ?PDO $konexioa = null;
    private string $host = 'localhost';
    private string $db   = 'hackaton';
    private string $user = 'wesuser';
    private string $pass = '123456';

    // konexioa irekitzen da (bakarrik behar bada) eta itzultzen da.
    public function konektatu(): PDO
    {
        if ($this->konexioa !== null) {
            return $this->konexioa;
        }

        $dsn = "mysql:host={$this->host};dbname={$this->db};charset=utf8mb4";

        $aukerak = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];

        try {
            $this->konexioa = new PDO($dsn, $this->user, $this->pass, $aukerak);
        } catch (PDOException $e) {
            // errore teknikoa logean gordetzen da, erabiltzaileari mezu orokorra.
            error_log($e->getMessage());
            http_response_code(500);
            exit('Ezin izan da datu-basera konektatu.');
        }

        return $this->konexioa;
    }

    // konexioa itzultzen du (ez badago irekita, irekitzen da).
    public function getKonexioa(): PDO
    {
        return $this->konektatu();
    }
}
