<?php
declare(strict_types=1);

spl_autoload_register(static function (string $class): void {
    if (!str_starts_with($class, 'Firebase\\JWT\\')) return;
    $file = __DIR__ . '/vendor/firebase-jwt/' . substr($class, strlen('Firebase\\JWT\\')) . '.php';
    if (is_file($file)) require_once $file;
});

const FF_SUPABASE_REF = 'vdpasrxiwsqziwakqbpa';
const FF_ADMIN_EMAIL = 'tobin.coziahr@gmail.com';

function ff_data_dir(): string { return dirname(__DIR__, 2) . '/foreverfree-data'; }
function ff_issuer(): string { return 'https://' . FF_SUPABASE_REF . '.supabase.co/auth/v1'; }
function ff_jwks_url(): string { return ff_issuer() . '/.well-known/jwks.json'; }

function ff_json(array $body, int $status = 200): never {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    header('Cache-Control: no-store');
    echo json_encode($body, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    exit;
}

function ff_fail(string $message, int $status): never { ff_json(['error' => $message], $status); }

function ff_body(int $maxBytes = 131072): array {
    $raw = file_get_contents('php://input', false, null, 0, $maxBytes + 1);
    if (!is_string($raw) || $raw === '') return [];
    if (strlen($raw) > $maxBytes) ff_fail('request too large', 413);
    $decoded = json_decode($raw, true);
    if (!is_array($decoded)) ff_fail('invalid JSON body', 400);
    return $decoded;
}
