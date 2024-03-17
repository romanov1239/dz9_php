<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{ title }}</title>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">

    <link rel="stylesheet" href="/css/main.css">
    <script src="/js/main.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="h=100 d-flex flex-column">
<div class="container">
    <header class="d-flex flex-wrap align-items-center
justify-content-center justify-content-md-between py-3 mb-4 border-bottom">

        <ul class="nav col-12 col-md-auto mb-2 justify-content-center mb-md-0">
            <li><a href="/" class="nav-link px-2 link-secondary">Главная</a></li>
            <li><a href="/user/index/" class="nav-link px-2 link-dark">Пользователи</a></li>
            <li><a href="/user/save" class="nav-link px-2 link-dark">Добавить в БД</a></li>
            {% if isAdmin %}
            <li><a href="/user/update" class="nav-link px-2 link-dark">Изменить пользователя</a></li>

            {% endif %}
        </ul>


        {% include "auth-template.tpl" %}
    </header>
</div>

<div class="container">
    <div class="row">
        <div class="col-4 alert alert-danger">
            <!-- Содержимое колонки 1 -->
        </div>
        <div class="col-4 alert alert-danger">
            <!-- Содержимое колонки 1 -->
        </div>
        <div class="col-4 alert alert-danger">
            <!-- Содержимое колонки 1 -->
        </div>
    </div>
</div>

<main class="flex-shrink-0">
    <div class="container content-template">
        {% if content_template_name == 'error.tpl' %}
        {% include content_template_name with {'title': title, 'message': message, 'code': code, 'file': file, 'line': line} %}
        {% else %}
        {% include content_template_name %}
        {% endif %}
    </div>


</main>

<footer class="footer mt-auto py-3 bg-light">
    <p id="server-time"></p>
    <script>
        setInterval(()=>{
            (
                async()=>{
                    const response=await fetch('/time/index');
                    const answer= await response.json();
                    document.querySelector('#server-time').textContent=answer.time;
                }
            )();
        }, 1000)
    </script>

    <div class="container">
<span class="text-muted">Место для контента прикрепленного футера
здесь.</span>
    </div>
</footer>
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous">
</script>


</body>
</html>
