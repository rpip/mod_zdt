%%%-------------------------------------------------------------------
%%% @author Mawuli Adzaku <mawuli@mawuli.me>
%%% @copyright (C) 2013, Mawuli Adzaku
%%% @doc
%%%
%%% @end
%%% Created : 28 Sep 2013 by Mawuli Adzaku <mawuli@mawuli.me>
%%%-------------------------------------------------------------------
-module(controller_admin_zdt).
-author("Mawuli Adzaku <mawuli@mawuli.me>").

-export([
    is_authorized/2,
    html/1
]).

-include_lib("controller_html_helper.hrl").
-include_lib("../include/mod_zdt.hrl").

is_authorized(ReqData, Context) ->
    z_acl:wm_is_authorized(use, mod_zdt, ReqData, Context).

html(Context) ->
    Html = z_template:render("zdt_admin.tpl", [], Context),
    z_context:output(Html, Context).


