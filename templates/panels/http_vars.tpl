<h3>{_ HTTP Request Vars _}</h3>
<table>
    <thead>
        <tr>
                <th>{_ Key _}</th>
                <th>{_ Value _}</th>
        </tr>
    </thead>
    <tbody>
                    <tr>
                            <td>Path</td>
                            <td>{{ m.req.path }}</td>
                    </tr>
                    <tr>
                            <td>Raw Path</td>
                            <td>{{ m.req.raw_path }}</td>
                    </tr>
                    <tr>
                            <td>Peer address</td>
                            <td>{{ m.req.peer }}</td>
                    </tr>
                    <tr>
                            <td>SSL Connection</td>
                            <td>{{ m.req.is_ssl }}</td>
                    </tr>
                    <tr>
                            <td>Host</td>
                            <td>{{ m.req.host }}</td>
                    </tr>
                    <tr>
                            <td>HTTP version</td>
                            <td>{{ m.req.version|pprint }}</td>
                    </tr>
    </tbody>
</table>


<h3>{_ GET Vars _}</h3>
<table>
        <thead>
                <tr>
                    <th>{_ Key _}</th>
                    <th>{_ Value _}</th>
                </tr>
        </thead>
        <tbody>
                {% for key, value in m.req.qs %}
                        <tr>
                            <td>{{ key }}</td>
                            <td>{{ value }}</td>
                        </tr>
                {% endfor %}

        </tbody>
</table>

<h3>{_ HTTP Headers _}</h3>
<table>
        <thead>
                <tr>
                        <th>{_ Key _}</th>
                        <th>{_ Value _}</th>
                </tr>
        </thead>
        <tbody>
        {% for key, value in m.req.headers %}
                <tr>
                        <td>{{ key }}</td>
                        <td>{{ value }}</td>
                </tr>
        {% endfor %}

</tbody>
</table>

<h3>{_ Zotonic context _}</h3>
<table>
        <tbody>
                <tr>
                        <td>{{ z_context|pprint }}</td>
                </tr>
        </tbody>
</table>
