{% for key, value in statistics %}
        <h3>{{ key }}</h3>

        <table>
                <thead>
                        <tr>
                                <th>{_ Key _}</th>
                                <th>{_ Value _}</th>
                        </tr>
                </thead>
                <tbody>
                        {% for key, value in value %}
                                <tr class="{% cycle 'row1' 'row2' %}">
                                        <td>{{ key }}</td>
                                        <td>{{ value }}</td>
                                </tr>
                        {% endfor %}
                </tbody>
        </table>

{% endfor %}
