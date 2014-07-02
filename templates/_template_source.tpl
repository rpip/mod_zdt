<div class="djDebugPanelTitle">
	<a class="djDebugClose djDebugBack" href="">{{ _"Back" }}</a>
	<h3>{{ _"Template source:" }} <code>{{ template_name }}</code></h3>
</div>
<div class="djDebugPanelContent">
	<div class="scroll">
		{% if source.pygmentized %}
                        {{ source }}
		{% else %}
			<pre>{{ source }}</pre>
		{% endif %}
	</div>
</div>
