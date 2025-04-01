<!DOCTYPE html>
<html>
<head>
    <title>Множество Мандельброта</title>
    <script>
        function updateImage() {
            const res = document.getElementById('res').value;
            const x = document.getElementById('x').value;
            const y = document.getElementById('y').value;
            const scale = document.getElementById('scale').value;
            const max_iter = document.getElementById('max_iter').value;
            
            const img = document.getElementById('dynamic-img');
            img.src = `generate_mandelbrot.php?res=${res}&x=${x}&y=${y}&scale=${scale}&max_iter=${max_iter}`;
            console.log(res);
            // Параметр t=timestamp предотвращает кэширование
        }
    </script>
</head>
<body>
  <div style="display: flex; justify-content: center; align-items: center;">
    <label>Разрешение: <input id="res" type="number" min="100" max="2000" value="500" step="100" oninput="updateImage()"></label>
    <label>X: <input id="x" type="number" min="-10" max="10" value="-0.7" step="0.01" oninput="updateImage()"></label>
    <label>Y: <input id="y" type="number" min="-10" max="10" value="0.31" step="0.01" oninput="updateImage()"></label>
    <label>Scale: <input id="scale" type="number" min="-10" max="10" value="0.1" step="0.1" oninput="updateImage()"></label>
    <label>Max iteration: <input id="max_iter" type="number" min="100" max="5000" value="100" step="100" oninput="updateImage()"></label>
    <!--label>Цвет: 
        <select id="color" onchange="updateImage()">
            <option value="2550000">Красный</option>
            <option value="0002550">Зеленый</option>
            <option value="0000255">Синий</option>
        </select>
    </label-->
  </div>
    <br>
    <img id="dynamic-img" src="generate_mandelbrot.php?res=200" alt="Динамическое изображение" style="display: block; margin-left: auto; margin-right: auto;">
</body>
</html>

