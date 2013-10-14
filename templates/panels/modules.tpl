<h3>{_ Modules _}</h3>

<div {% include "_language_attrs.tpl" language=`en` %}>
    <table class="table table-striped">
        <thead>
            <tr>
                <th width="20%">{_ Title _}</th>
                <th width="45%">{_ Path _}</th>
                <th width="5%">{_ Prio _}</th>
                <th width="30%">{_ Dependencies _}</th>
            </tr>
        </thead>

        <tbody>
            {% for sort, prio, module, props in modules %}
            <tr id="{{ #li.module }}" class="{% if not props.is_active %}unpublished{% endif %}">
                <td>{% include "_icon_status.tpl" status_title=status[module] status=status[module] status_id=#status.module %} {{ props.mod_title|default:props.title }}</td>
                <td>{{ props.path|default:"-" }}</td>
                <td>{{ prio }}</td>
                <td>
                        {{ props.mod_depends|pprint }}
                </td>
            </tr>
            {% empty %}
            <tr>
                <td colspan="4">
                    {_ No modules found _}
                </td>
            </tr>
            {% endfor %}
        </tbody>
    </table>

</div>
