<?php
// Убедимся, что нет никакого вывода перед заголовками
ob_start();

// Параметры с проверкой и фильтрацией
$res = isset($_GET['res']) ? max(10, min(2000, (int)$_GET['res'])) : 300;
$x = isset($_GET['x']) ? (float)$_GET['x'] : 0;
$y = isset($_GET['y']) ? (float)$_GET['y'] : 0;
$scale = isset($_GET['scale']) ? (float)$_GET['scale'] : 2;
$max_iter = isset($_GET['max_iter']) ? (int)$_GET['max_iter'] : 100;

function get_mandelbrot($resolution, $x, $y, $scale, $max_iter) {
    $descriptorspec = [
        0 => ["pipe", "r"],
        1 => ["pipe", "w"],
        2 => ["pipe", "w"]
    ];
    
    $cmd = __DIR__ . '/mandelbrot.exe ' . 
           escapeshellarg($resolution) . ' ' .
           escapeshellarg($x) . ' ' . 
           escapeshellarg($y) . ' ' .
           escapeshellarg($scale) . ' ' .
           escapeshellarg($max_iter);
    
    $process = proc_open($cmd, $descriptorspec, $pipes);
    
    if (!is_resource($process)) {
        throw new Exception("Не удалось запустить процесс");
    }
    
    $binary_data = stream_get_contents($pipes[1]);
    $error_output = stream_get_contents($pipes[2]);
    
    foreach ($pipes as $pipe) fclose($pipe);
    proc_close($process);
    
    if (!empty($error_output)) {
        throw new Exception("Ошибка: " . $error_output);
    }
    
    if (strlen($binary_data) < 4) {
        throw new Exception("Недостаточно данных");
    }
    
    $resolution = unpack('I', substr($binary_data, 0, 4))[1];
    $values = unpack('d*', substr($binary_data, 4));
    
    return array_chunk($values, $resolution);
}

function draw_mandelbrot(array $matrix, int $max_iter) {
    $width = count($matrix);
    $height = count($matrix[0]);
    $img = imagecreatetruecolor($width, $height);
    
    // Начальный цвет (#29010a в RGB)
    $start_r = 50;   // 0x29
    $start_g = 0;    // 0x01
    $start_b = 70;   // 0x0a
    
    // Разбиваем итерации на три фазы
    $phase1 = (int)($max_iter * 0.3); // #29010a -> белый
    $phase2 = (int)($max_iter * 0.8); // белый -> серый
    $phase3 = $max_iter;              // серый -> черный
    
    $palette = new SplFixedArray($max_iter + 1);
    
    for ($i = 0; $i <= $max_iter; $i++) {
        if ($i <= $phase1) {
            // Фаза 1: #29010a -> белый
            $ratio = $i / $phase1;
            $r = $start_r + (int)((255 - $start_r) * $ratio);
            $g = $start_g + (int)((255 - $start_g) * $ratio);
            $b = $start_b + (int)((255 - $start_b) * $ratio);
        }
        else {
            // Фаза 2: белый -> серый (128)
            $ratio = ($i - $phase1) / ($phase2 - $phase1);
            $val = 255 - (int)(128 * $ratio);
            $r = $g = $b = $val;
        }
        
        $palette[$i] = imagecolorallocate($img, $r, $g, $b);
        if ($palette[$i] === false) {
            $palette[$i] = imagecolorallocate($img, 0, 0, 0);
        }
    }
    
    // Черный для внутренних точек
    $inside_color = imagecolorallocate($img, 0, 0, 0);
    
    // Рендеринг
    for ($x = 0; $x < $width; $x++) {
        for ($y = 0; $y < $height; $y++) {
            $iter = min($max_iter, (int)$matrix[$x][$y]);
            $color = ($iter >= $max_iter) ? $inside_color : $palette[$iter];
            imagesetpixel($img, $x, $y, $color);
        }
    }
    
    return $img;
}

try {
    // Очищаем буфер на случай случайного вывода
    ob_end_clean();
    
    $matrix = get_mandelbrot($res, $x, $y, $scale, $max_iter);
    $gd = draw_mandelbrot($matrix, $max_iter);
    
    // Устанавливаем правильные заголовки
    header('Content-Type: image/png');
    header('Cache-Control: max-age=3600');
    
    // Выводим изображение
    imagepng($gd);
    
    // Сохраняем копию на диск (опционально)
    // imagepng($gd, __DIR__ . '/last_fractal.png');
    
    imagedestroy($gd);
    exit;
    
} catch (Exception $e) {
    ob_end_clean();
    header('Content-Type: text/plain');
    http_response_code(500);
    die("Ошибка: " . $e->getMessage());
}
?>
