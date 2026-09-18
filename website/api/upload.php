<?php
declare(strict_types=1);

require_once __DIR__ . '/auth.php';

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
    header('Allow: POST');
    ff_fail('method not allowed', 405);
}

ff_require_admin();

$path = isset($_POST['path']) && is_string($_POST['path']) ? trim($_POST['path']) : '';
$overwrite = ($_POST['overwrite'] ?? '0') === '1';
$pattern = '#^projects/[a-z0-9][a-z0-9-]*/[A-Za-z0-9][A-Za-z0-9._-]*\.(jpg|jpeg|png|webp|gif)$#i';
if (!preg_match($pattern, $path, $pathMatch)) ff_fail('use a path like projects/tiki-passport/foobar.jpg', 422);

if (!isset($_FILES['file']) || !is_array($_FILES['file'])) ff_fail('choose an image to upload', 422);
$file = $_FILES['file'];
$error = $file['error'] ?? UPLOAD_ERR_NO_FILE;
if ($error !== UPLOAD_ERR_OK) {
    $message = match ($error) {
        UPLOAD_ERR_INI_SIZE, UPLOAD_ERR_FORM_SIZE => 'the image is larger than the server allows',
        UPLOAD_ERR_PARTIAL => 'the upload was interrupted',
        UPLOAD_ERR_NO_FILE => 'choose an image to upload',
        default => 'the image could not be uploaded'
    };
    ff_fail($message, 422);
}

$size = $file['size'] ?? 0;
if (!is_int($size) || $size < 1 || $size > 12 * 1024 * 1024) ff_fail('images must be 12 MB or smaller', 422);
$temporary = $file['tmp_name'] ?? '';
if (!is_string($temporary) || !is_uploaded_file($temporary)) ff_fail('invalid upload', 422);

$mimeTypes = [
    'jpg' => ['image/jpeg'],
    'jpeg' => ['image/jpeg'],
    'png' => ['image/png'],
    'webp' => ['image/webp'],
    'gif' => ['image/gif']
];
$extension = strtolower($pathMatch[1]);
$finfo = new finfo(FILEINFO_MIME_TYPE);
$mime = $finfo->file($temporary);
if (!is_string($mime) || !in_array($mime, $mimeTypes[$extension], true)) ff_fail('the file contents do not match the filename extension', 422);

$webRoot = dirname(__DIR__);
$destination = $webRoot . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $path);
$directory = dirname($destination);
if (!is_dir($directory) && !mkdir($directory, 0755, true) && !is_dir($directory)) ff_fail('could not create the project image folder', 500);
if (is_file($destination) && !$overwrite) ff_fail('a file already exists at that path', 409);

$staging = $directory . DIRECTORY_SEPARATOR . '.upload-' . bin2hex(random_bytes(8));
if (!move_uploaded_file($temporary, $staging)) ff_fail('could not save the uploaded image', 500);
chmod($staging, 0644);
if (!rename($staging, $destination)) {
    @unlink($staging);
    ff_fail('could not finish saving the uploaded image', 500);
}

ff_json(['path' => $path, 'url' => '/' . $path, 'size' => $size, 'mime' => $mime]);
