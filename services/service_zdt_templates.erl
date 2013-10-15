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

-export([process_get/2,
        gather_templates/0]).

-include_lib("zotonic.hrl").

process_get(_ReqData, _Context) ->
    Templates = gather_templates(),
    z_convert:to_json(Templates).

gather_templates() ->
    CoreModulesDir = z_utils:lib_dir(modules),
    CoreModulesTemplates = filelib:wildcard(
                    filename:join([CoreModulesDir, "*/*/*.tpl"])),

    PrivDir = z_utils:lib_dir(priv),
    PrivTemplates = filelib:wildcard(
                    filename:join([PrivDir, "*/*/*/*.tpl"])),
    CoreModulesTemplates ++ PrivTemplates.
