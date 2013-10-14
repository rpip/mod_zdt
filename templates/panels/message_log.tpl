<h3>{_ Message log _}</h3>
	<tbody>

                {% with m.search[{log}] as result %}
                        <div id="log-area">
                                {% for id in result %}
                                        {% include "partials/log_row.tpl" id=id %}
                                {% empty %}
                                        <div class="alert alert-info">
	                                        {_ No log messages. _}
                                        </div>
                                {% endfor %}
                        </div>
                {% endwith %}
