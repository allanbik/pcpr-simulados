<?php
/**
 * Conexão com o Banco de Dados MySQL via PDO
 * Portal de Provas e Simulados PC PR 2026 (Banca FGV)
 */

declare(strict_types=1);

class Database {
    private static ?PDO $instance = null;

    /**
     * Retorna uma única instância da conexão PDO (Singleton Pattern)
     */
    public static function getConnection(): PDO {
        if (self::$instance === null) {
            $host     = getenv('DB_HOST') ?: '127.0.0.1';
            $port     = getenv('DB_PORT') ?: '3306';
            $dbname   = getenv('DB_NAME') ?: 'pcpr_simulados';
            $username = getenv('DB_USER') ?: 'root';
            $password = getenv('DB_PASS') !== false ? getenv('DB_PASS') : '';

            $dsn = "mysql:host={$host};port={$port};dbname={$dbname};charset=utf8mb4";

            $options = [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"
            ];

            try {
                self::$instance = new PDO($dsn, $username, $password, $options);
            } catch (PDOException $e) {
                http_response_code(500);
                header('Content-Type: application/json; charset=utf-8');
                echo json_encode([
                    'sucesso' => false,
                    'erro'    => 'Erro de conexão com o banco de dados MySQL: ' . $e->getMessage(),
                    'dica'    => 'Verifique se o MySQL está rodando e se o script database.sql foi importado.'
                ], JSON_UNESCAPED_UNICODE);
                exit;
            }
        }

        return self::$instance;
    }
}
