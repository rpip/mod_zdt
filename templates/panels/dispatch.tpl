<h3>{_ URL dispatch _}</h3> <h3><b>{{m.site.title}}</b> </h3>
<table>
        <thead>
                <tr>
                        <th>{_ Name _}</th>
                        <th>{_ Path _}</th>
                        <th>{_ Resource _}</th>
                        <th>{_ Args _}</th>
                </tr>
        </thead>
        <tbody>
                {% for rule in dispatch_rules %}
                        <tr class="{% cycle 'row1' 'row2' %}">
                                <td>{{ rule.name }}</td>
                                <td>{{ rule.path }}</td>
                                <td>{{ rule.resource }}</td>
                                <td>{{ rule.args|pprint }}</td>
                        </tr>
                {% endfor %}
        </tbody>
</table>
