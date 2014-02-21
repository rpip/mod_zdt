# Zotonic Debug Toolbar - ZDT
Debugging toolbar for Zotonic implemented as a module.

Shamelessly ripped off from the Django Debug Toolbar :-)

Basically, what it does is to add a diagnostics toolbar to Zotonic applications.
When enabled, it injects an html div to the right side of the web application
with easy access to logging, database queries, request variables, session/cookie data,
application modules, Erlang runtime info, and other useful information.

## Overview of the toolbar

- Modules: path, status, dependencies
- Request vars [GET, POST, session, cookies, http headers]
- Settings - site configs
- Message logs
- Template context variables
- Resource usage
- Sql profiler
- Process Info:
- URL dispatch

## How to use
Insert `{% debug_toolbar %}` in a template file, preferably the base template file(`base.tpl`).

A better approach will be add a debug key to the site config: ``{debug, true}``, and then do:

    ````
    {% if m.site.debug %}
        {% debug_toolbar %}
    {% endif %}
    ````

## Screenshots
![screenshot-1.png](priv/screenshots/screenshot-1.png "Site configurations panel")

![screenshot-2.png](priv/screenshots/screenshot-2.png "HTTP headers panel")

![screenshot-3.png](priv/screenshots/screenshot-3.png "Debug Toolbar")


## Panels under construction

- Templates
- SQL profiler: displays the queries made by the current request, and profile them by execution time.
- Events [observers and notifications]
- System Info [server CPU usage]

## TODO
See the TODO file

## Contributing

Issues, forks, and pull requests are welcome!
