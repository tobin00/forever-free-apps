<?php
declare(strict_types=1);

require_once __DIR__ . '/auth.php';

function ff_projects_file(): string { return ff_data_dir() . '/projects.json'; }

function ff_seed_projects(): array {
    $seed = json_decode((string) file_get_contents(dirname(__DIR__) . '/projects.json'), true);
    return is_array($seed) ? $seed : [];
}

function ff_read_projects(): array {
    $file = ff_projects_file();
    if (!is_file($file)) return ff_seed_projects();
    $projects = json_decode((string) file_get_contents($file), true);
    return is_array($projects) ? $projects : ff_seed_projects();
}

function ff_validate_projects(mixed $value): array {
    if (!is_array($value) || count($value) > 100) ff_fail('invalid project list', 422);
    $required = ['id', 'name', 'type', 'description', 'url', 'image', 'imageAlt', 'accent', 'featured', 'published'];
    $ids = [];
    $featuredCount = 0;
    $normalized = [];
    foreach ($value as $project) {
        if (!is_array($project)) ff_fail('invalid project', 422);
        foreach ($required as $key) if (!array_key_exists($key, $project)) ff_fail("missing project field: $key", 422);
        if (!is_string($project['id']) || !preg_match('/^[a-z0-9]+(?:-[a-z0-9]+)*$/', $project['id'])) ff_fail('invalid project id', 422);
        if (isset($ids[$project['id']])) ff_fail('duplicate project id', 422);
        $ids[$project['id']] = true;
        foreach (['name', 'type', 'description', 'url', 'image', 'imageAlt', 'accent'] as $key) {
            if (!is_string($project[$key]) || trim($project[$key]) === '' || strlen($project[$key]) > 4000) ff_fail("invalid project field: $key", 422);
        }
        if (!filter_var($project['url'], FILTER_VALIDATE_URL) || !in_array(parse_url($project['url'], PHP_URL_SCHEME), ['http', 'https'], true)) ff_fail('invalid project URL', 422);
        if (!in_array($project['accent'], ['coral', 'gold', 'blue'], true)) ff_fail('invalid project accent', 422);
        $project['mediaStyle'] = $project['mediaStyle'] ?? 'cover';
        $project['image2'] = $project['image2'] ?? '';
        $project['image2Alt'] = $project['image2Alt'] ?? '';
        if (!is_string($project['mediaStyle']) || !in_array($project['mediaStyle'], ['cover', 'phones'], true)) ff_fail('invalid project media layout', 422);
        foreach (['image2', 'image2Alt'] as $key) if (!is_string($project[$key]) || strlen($project[$key]) > 4000) ff_fail("invalid project field: $key", 422);
        if (trim($project['image2']) !== '' && trim($project['image2Alt']) === '') ff_fail('second image description is required', 422);
        if (!is_bool($project['featured']) || !is_bool($project['published'])) ff_fail('invalid project flags', 422);
        if ($project['featured']) $featuredCount++;
        $normalized[] = $project;
    }
    if ($featuredCount > 1) ff_fail('only one project can be featured', 422);
    return $normalized;
}

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
if ($method === 'GET') {
    $projects = ff_read_projects();
    if (isset($_GET['admin'])) ff_require_admin();
    else $projects = array_values(array_filter($projects, static fn(array $project): bool => ($project['published'] ?? false) === true));
    ff_json(['projects' => $projects]);
}

if ($method === 'PUT') {
    ff_require_admin();
    $body = ff_body();
    $projects = ff_validate_projects($body['projects'] ?? null);
    $dir = ff_data_dir();
    if (!is_dir($dir) && !mkdir($dir, 0700, true) && !is_dir($dir)) ff_fail('cannot create data directory', 500);
    $tmp = $dir . '/projects.' . bin2hex(random_bytes(6)) . '.tmp';
    $json = json_encode($projects, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . "\n";
    if (file_put_contents($tmp, $json, LOCK_EX) === false || !rename($tmp, ff_projects_file())) { @unlink($tmp); ff_fail('could not save projects', 500); }
    ff_json(['projects' => $projects, 'saved' => true]);
}

header('Allow: GET, PUT');
ff_fail('method not allowed', 405);
