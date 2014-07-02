<h3>Template variables</h3>
{% include "_debug.tpl" vars=vars %}

<h4>{{ zdt_templates|if:"Templates":"Template" }}</h4>

{% if zdt_templates %}
        <dl>
                {% for zdt_template in zdt_templates %}
                        <dt>
                                <strong>
                                        <a class="remoteCall toggleTemplate" href="{% url zdt_template_source template=zdt_template.origin_name %}">
                                                {{ zdt_template.name }}</a></strong>
                        </dt>
                        <dd><samp>{{ zdt_template.origin_name }}</samp></dd>
                        {% if zdt_template.context %}
                                <dd>
                                        <div class="djTemplateShowContextDiv">
                                                <a class="djTemplateShowContext">
                                                        <span class="toggleArrow">&#x25B6;</span>
                                                        {_ Toggle context _}
                                                </a>
                                        </div>
                                        <div class="djTemplateHideContextDiv" style="display:none;">
                                                <code>{{ zdt_template.context|pprint }}</code>
                                        </div>
                                </dd>
                        {% endif %}
                {% endfor %}
        </dl>
{% else %}
        <p>None</p>
{% endif %}
