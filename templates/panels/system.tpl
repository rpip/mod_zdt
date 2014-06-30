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


<h3>{_ System Process info _}</h3>
<table>
        <thead>
                <tr>
                        <th>{_ %CPU _}</th>
                        <th>{_ PID _}</th>
                        <th>{_ USER _}</th>
                        <th>{_ COMMAND _}</th>
                </tr>
        </thead>
        <tbody>
                {% for cpu, pid, user, command in os_procs %}
                        <tr>
                                <td>{{ cpu }}</td>
                                <td>{{ pid }}</td>
                                <td>{{ user }}</td>
                                <td>{{ command }}</td>
                        </tr>
                {% endfor %}

        </tbody>
</table>
