# Zotonic Debug Toolbar - ZDT
Debugging toolbar for Zotonic implemented as a module.
Shamelessly ripped off from the Django Debug Toolbar.

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

## How to use
Insert `{% debug_toolbar %}` in the base template file(default is `base.html`).

## Screenshots
![screenshot-1.png](priv/screenshots/screenshot-1.png "Site configurations panel")

![screenshot-2.png](priv/screenshots/screenshot-1.png "HTTP headers panel")

![screenshot-3.png](priv/screenshots/screenshot-3.png "Debug Toolbar")


## Panels under construction

- Templates
- SQL profiler.
  This should display the queries made by the current request, and profile them by execution time.
- Events [observers and notifications]
- System Info [server CPU usage]

## TODO
See the TODO file

## *Please help if you have time! Thanks!*
