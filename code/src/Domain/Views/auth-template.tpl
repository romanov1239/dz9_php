{% if not user_authorized %}
<div class="col-md-3 text-end">
    <a href="/user/auth/" class="btn btn-primary">Войти</a>
</div>
{% else %}
<p>Добро пожаловать на сайт, {{ user_login }}!</p>
<p>
    {% set now = date('now', 'Europe/Moscow') %}
    Текущее время: {{ now.format('H:i:s') }}
</p>
<form method="POST" action="/user/logout/" class="logout-form">
    <input type="submit" value="Выход">
</form>
{% endif %}









