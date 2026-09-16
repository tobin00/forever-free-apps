<?php
declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

use Firebase\JWT\JWK;
use Firebase\JWT\JWT;

final class FfProviderUnavailable extends Exception {}

function ff_http_get(string $url): ?string {
    if (extension_loaded('curl')) {
        $ch = curl_init($url);
        curl_setopt_array($ch, [CURLOPT_RETURNTRANSFER => true, CURLOPT_TIMEOUT => 6, CURLOPT_CONNECTTIMEOUT => 4, CURLOPT_FOLLOWLOCATION => true]);
        $body = curl_exec($ch);
        $status = curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
        curl_close($ch);
        if (is_string($body) && $status === 200) return $body;
    }
    $context = stream_context_create(['http' => ['timeout' => 6, 'ignore_errors' => true]]);
    $body = @file_get_contents($url, false, $context);
    return is_string($body) ? $body : null;
}

function ff_jwks(bool $refresh = false): array {
    $dir = ff_data_dir();
    $cache = $dir . '/jwks.json';
    if (!$refresh && is_file($cache) && time() - filemtime($cache) < 21600) {
        $data = json_decode((string) file_get_contents($cache), true);
        if (is_array($data) && !empty($data['keys'])) return $data;
    }
    $raw = ff_http_get(ff_jwks_url());
    if ($raw === null && is_file($cache)) $raw = (string) file_get_contents($cache);
    $data = is_string($raw) ? json_decode($raw, true) : null;
    if (!is_array($data) || empty($data['keys'])) throw new FfProviderUnavailable();
    @mkdir($dir, 0700, true);
    @file_put_contents($cache, $raw, LOCK_EX);
    return $data;
}

function ff_token_kid(string $token): ?string {
    $parts = explode('.', $token);
    if (count($parts) !== 3) return null;
    $header = json_decode((string) base64_decode(strtr($parts[0], '-_', '+/'), false), true);
    return is_array($header) && isset($header['kid']) && is_string($header['kid']) ? $header['kid'] : null;
}

function ff_verify_token(string $token): object {
    $keys = JWK::parseKeySet(ff_jwks(), 'ES256');
    $kid = ff_token_kid($token);
    if ($kid !== null && !isset($keys[$kid])) $keys = JWK::parseKeySet(ff_jwks(true), 'ES256');
    JWT::$leeway = 60;
    $claims = JWT::decode($token, $keys);
    if (($claims->iss ?? null) !== ff_issuer()) throw new UnexpectedValueException('wrong issuer');
    $audiences = is_array($claims->aud ?? null) ? $claims->aud : [$claims->aud ?? null];
    if (!in_array('authenticated', $audiences, true)) throw new UnexpectedValueException('wrong audience');
    if (!isset($claims->sub) || !is_string($claims->sub) || $claims->sub === '') throw new UnexpectedValueException('missing subject');
    return $claims;
}

function ff_bearer_token(): ?string {
    foreach ([$_SERVER['HTTP_AUTHORIZATION'] ?? null, $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? null, $_SERVER['HTTP_X_FF_AUTH'] ?? null] as $value) {
        if (is_string($value) && preg_match('/^Bearer\s+(\S+)$/i', $value, $match)) return $match[1];
    }
    return null;
}

function ff_require_admin(): object {
    $token = ff_bearer_token();
    if ($token === null) ff_fail('sign in required', 401);
    try { $claims = ff_verify_token($token); }
    catch (FfProviderUnavailable $e) { ff_fail('identity provider unavailable', 503); }
    catch (Throwable $e) { ff_fail('invalid token', 401); }
    $email = isset($claims->email) && is_string($claims->email) ? strtolower($claims->email) : '';
    if ($email !== strtolower(FF_ADMIN_EMAIL)) ff_fail('this account is not an administrator', 403);
    return $claims;
}
