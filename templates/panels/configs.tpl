<h3>{_ Site configurations _}</h3>
<table>
        <thead>
                <tr>
                        <th>{_ Key _}</th>
                        <th>{_ Value _}</th>
                </tr>
        </thead>
        <tbody>
                {% for key, value in m.site %}
                        <tr class="{% cycle 'row1' 'row2' %}">
                                <td>{{ key }}</td>
                                <td>{{ value }}</td>
                        </tr>
                {% endfor %}
        </tbody>
</table>


{% for mod,keys in m.config %}
        <h3>{{ mod }}</h3>
    <table>
            <thead>
                    <tr>
                            <th>{_ Key _}</th>
                            <th>{_ Value _}</th>
                    </tr>
            </thead>
            <tbody>
                    {% for key,value in keys %}
                            <tr class="{% cycle 'row1' 'row2' %}">
                                    <td>{{ key }}</td>
                                    <td>{{ value.value }}</td>
                            </tr>
                    {% endfor %}
            </tbody>
    </table>
{% endfor %}
