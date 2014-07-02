%%%-------------------------------------------------------------------
%%% @author Mawuli Adzaku <mawuli@mawuli.me>
%%% @copyright (C) 2013, Mawuli Adzaku
%%% @doc Serve requested template files
%%%
%%% @end
%%% Created : 11 Oct 2013 by Mawuli Adzaku <mawuli@mawuli.me>
%%%-------------------------------------------------------------------
-module(service_zdt_templates).
-author("Mawuli Adzaku <mawuli@mawuli.me>").

-svc_title("Serve template files via REST").
-svc_needauth(false).

-export([process_get/2]).

-include_lib("zotonic.hrl").

process_get(_ReqData, Context) ->
    File = z_context:get_q(template, Context),
    SiteDir = z_path:site_dir(Context),
    Filepath = filename:join(SiteDir, filename:join("templates", File)),
    io:format("FILE: ~p", [Filepath]),
    {ok, Source} = file:read_file(filename:join(SiteDir, File)),
    Vars = [
            {template_name, File},
            {source, Source}
           ],
    Html = z_template:render("_template_source.tpl", Vars, Context),
    {IoList, _Context2} = z_context:output(Html, Context),
    iolist_to_binary(IoList).
