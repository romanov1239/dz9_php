<p>Список пользователей</p>
<div class="table-responsive small">
    <table class="table table-striped table-sm">
        <thead>
        <tr>
            <th scope="col">ID</th>
            <th scope="col">Имя</th>
            <th scope="col">Фамилия</th>
            <th scope="col">День рождения</th>
        </tr>
        </thead>

    <tbody>
    {% for user in users %}
    <tr>
        <td>{{ user.getUserId() }}</td>
        <td>{{ user.getUserName() }}</td>
        <td>{{ user.getUserLastName() }}</td>
        <td>
            {% if user.getUserBirthday() is not empty %}
            {{ user.getUserBirthday() | date('d.m.Y') }}
            {% else %}
            <b>Не задан</b>
            {% endif %}
        </td>
        {% if isAdmin %}
        <td>
            <button class="delete-user-button" data-user-id="{{ user.getUserId() }}">Удалить</button>
        </td>
        {% endif %}
    </tr>
    {% endfor %}
    </tbody>
    </table>
    <script>
        $(document).ready(function() {
            $('body').on('click', '.delete-user-button', function() {
                var userId = $(this).data('userId');
                var button = $(this);

                $.ajax({
                    type: 'POST',
                    url: '/user/delete',
                    data: { id: userId },
                    success: function(response) {
                        if(response.success === true || response.status === "success") {
                            button.closest('tr').remove();
                        }
                        setTimeout(function() {
                            location.reload();
                        }, 3000);
                    },
                    error: function(xhr, status, error) {
                        alert('Ошибка выполнения запроса: ' + error);
                        setTimeout(function() {
                            location.reload();
                        }, 3000);
                    }
                });
            });
        });
    </script>

    <script>
        setInterval(function () {
            let maxId = $(".table-responsive tbody tr:last-child td:first-child").html();
            $.ajax({
                method: 'POST',
                url: "/user/indexRefresh",
                data: { maxId : maxId }
            }).done(function (data) {
                let users = $.parseJSON(data);
                if(users.length != 0){
                    for(var k in users){
                        let row = "<tr>";
                        row += "<td>" + users[k].id + "</td>";
                        maxId = users[k].id;
                        row += "<td>" + users[k].username + "</td>";
                        row += "<td>" + users[k].userlastname + "</td>";
                        row += "<td>" + users[k].userbirthday + "</td>";
                        row += '<td><button class="delete-user-button" data-user-id="' + users[k].id + '">Удалить</button></td>';
                        row += "</tr>";
                        $('.content-template tbody').append(row);
                    }
                }
            });
        }, 10000);
    </script>


</div>