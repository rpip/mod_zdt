<h3>{_ Environment variables _}</h3>
<table>
        <thead>
                <tr>
                        <th>{_ Key _}</th>
                        <th>{_ Value _}</th>
                </tr>
        </thead>
        <tbody>
                {% for key, value in env %}
                        <tr>
                                <td>{{ key }}</td>
                                <td>{{ value }}</td>
                        </tr>
                {% endfor %}

        </tbody>
</table>
