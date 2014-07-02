<h3>{_ Message log _}</h3>
<table>
        <tbody>
                {% with m.search[{log}] as result %}
                        <div id="log-area">
                                {% for id in result %}
                                        {% include "_log_row.tpl" id=id %}
                                {% empty %}
                                        <div class="alert alert-info">
	                                        {_ No log messages. _}
                                        </div>
                                {% endfor %}
                        </div>
                {% endwith %}
        </tbody>
</table>
