<style type="text/css">
@media print { #djDebug {display:none;}}
</style>
<div id="djDebug" style="display:none;" dir="ltr">
	<div style="display:none;" id="djDebugToolbar">
		<ul id="djDebugPanelList">
			{% if panels %}
			<li><a id="djHideToolBarButton" href="#" title="Hide Toolbar">Hide &raquo;</a></li>
			{% else %}
			<li id="djDebugButton">DEBUG</li>
			{% endif %}
			{% for panel in panels %}
				<li class="djDebugPanelButton">
					{% if panel.has_content %}
						<a href="{{ panel.url|default:"#" }}" title="{{ panel.title }}" class="{{ panel.dom_id }}">
					{% else %}
					    <div class="contentless">
					{% endif %}
					{{ panel.nav_title }}
					{% with panel.nav_subtitle as subtitle %}
						{% if subtitle %}<br /><small>{{ subtitle }}</small>{% endif %}
					{% endwith %}
					{% if panel.has_content %}
						</a>
					{% else %}
					    </div>
					{% endif %}
				</li>
			{% endfor %}
		</ul>
	</div>
	<div style="display:none;" id="djDebugToolbarHandle">
		<a title="Show Toolbar" id="djShowToolBarButton" href="#">&laquo;</a>
	</div>
	{% for panel in panels %}
		{% if panel.has_content %}
			<div id="{{ panel.dom_id }}" class="panelContent">
				<div class="djDebugPanelTitle">
					<a href="" class="djDebugClose">Close</a>
					<h3>{{ panel.nav_title|escape }}</h3>
				</div>
				<div class="djDebugPanelContent">
				    <div class="scroll">
                                            {% ifequal panel.nav_title  "Templates" %}
                                                    {% include "panels/templates.tpl" vars=vars %}
                                            {% else %}
				                    {{ panel.content }}
                                            {% endifequal %}
				    </div>
				</div>
			</div>
		{% endif %}
	{% endfor %}
	<div id="djDebugWindow" class="panelContent"></div>
</div>
{% lib "js/zdt_toolbar.js" %}
{% lib "css/zdt_toolbar.css" %}

<script type="text/javascript"> window.djdt.init(); </script>
