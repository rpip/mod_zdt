%%%-------------------------------------------------------------------
%%% @author Mawuli Adzaku <mawuli@mawuli.me>
%%% @copyright (C) 2013, Mawuli Adzaku
%%% @doc Renders the debug toolbar
%%%
%%% @end
%%% Created : 28 Sep 2013 by Mawuli Adzaku <mawuli@mawuli.me>
%%%-------------------------------------------------------------------
-module(scomp_zdt_debug_toolbar).
-behaviour(gen_scomp).

-export([vary/2, render/3]).

-include("zotonic.hrl").

vary(_Params, _Context) -> nocache.

render(_Params, _Vars, Context) ->
    ZDTVars = [{panels,  mod_zdt:build_panels(Context)}],
    Html = z_template:render("toolbar.tpl", ZDTVars, Context),
    {ok, Html}.

