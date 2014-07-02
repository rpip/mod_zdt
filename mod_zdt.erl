%%%-------------------------------------------------------------------
%%% @author Mawuli Adzaku <mawuli@mawuli.me>
%%% @copyright (C) 2013, Mawuli Adzaku
%%% @doc Zotonic Debug Toolbar
%%%
%%% @end
%%% Created : 27 Sep 2013 by Mawuli Adzaku <mawuli@mawuli.me>
%%%-------------------------------------------------------------------
-module(mod_zdt).
-author('Mawuli Adzaku <mawuli@mawuli.me>').

%% Module metadata
-mod_title("Zotonic Debug Toolbar").
-mod_description("Frontend Debugging Panel").
-mod_prio(500).

-include_lib("zotonic.hrl").
-include_lib("modules/mod_admin/include/admin_menu.hrl").
-include_lib("include/mod_zdt.hrl").

-export([
         panels/0, 
         panel/2, 
         build_panels/1,
         get_config/2,
         is_address_allowed/2,
         get_site_templates/1,
        is_panel_visible/2]).

    
modules(Context) ->
    Status = z_module_manager:get_modules_status(Context),
    Status1 = lists:flatten(
                    [ 
                        [ {Module, atom_to_list(State)} || {Module, _, _Pid, _Date} <- Specs ] 
                        || {State, Specs} <- Status 
                    ]),
    [
        {modules, mod_admin_modules:all(Context)},
        {status, Status1}
    ].

%% @doc Returns the list of panel names
-spec panels() -> [PanelName::atom()].
panels()->
    ?ZDTB_PANELS.

%% @doc Construct a debug panel
-spec panel(PanelName::atom(), #context{}) -> #zdt_panel{}.
panel(sql, Context) ->
    sql_panel(Context);
panel(http_vars, Context) ->
    http_vars_panel(Context);
panel(logs, Context) ->
    message_log_panel(Context);
panel(configs, Context) ->
    configs_panel(Context);
panel(templates, Context) ->
    templates_panel(Context);
panel(modules, Context) ->
    modules_panel(Context);
panel(system, Context) ->
    system_panel(Context);
panel(stats, Context) ->
    stats_panel(Context);
panel(dispatch, Context) ->
    dispatch_panel(Context);
panel(_, _Context)->
    undefined.

%% @doc Returns the rendered panel templates
-spec build_panels(Context::#context{}) -> [#zdt_panel{}].
build_panels(Context) ->
    Panels = [
              ?RecordToProplists(zdt_panel, panel(Panel, Context)) 
              || Panel <- ?ZDTB_PANELS, is_panel_visible(Panel, Context)
             ],
    Panels.

%%=======================================================================================
%% Statistics
%%=======================================================================================
%% @doc Returns basic system statistics
basic_statistics() ->
    {MegaSecs, Secs, _} = now(),
    Epoch = MegaSecs * 1000000 + Secs,
    {ContextSwitches, 0} = statistics(context_switches),
    {{input, Input}, {output, Output}} = statistics(io),
    RunningQueue = statistics(run_queue),
    KernelPoll = erlang:system_info(kernel_poll),
    ProcessCount = erlang:system_info(process_count),
    ProcessLimit = erlang:system_info(process_limit),
    Nodes = length(nodes()) + 1,
    Ports = length(erlang:ports()),
    ModulesLoaded = length(code:all_loaded()),
    [
     {<<"date">>, Epoch}, {<<"context_switches">>, ContextSwitches}, 
     {<<"input">>, Input}, {<<"output">>, Output},
     {<<"running_queue">>, RunningQueue}, {<<"kernel_poll">>, KernelPoll}, 
     {<<"process_count">>, ProcessCount},
     {<<"process_limit">>, ProcessLimit}, {<<"nodes">>, Nodes}, 
     {<<"ports">>, Ports}, {<<"modules_loaded">>, ModulesLoaded}
    ].

%% @doc Returns Memory statistics
memory_statistics() ->
    {GarbageCollections, _, 0} = statistics(garbage_collection),
    erlang:memory() ++ [{<<"garbage_collections">>, GarbageCollections}].

%% @doc Returns Mnesia statistics
mnesia_statistics() -> 
    RunningNodes = length(mnesia:system_info(running_db_nodes)),
    PersistentNodes = length(mnesia:system_info(db_nodes)),
    HeldLocks = length(mnesia:system_info(held_locks)),
    QueuedLocks = length(mnesia:system_info(lock_queue)),
    KnownTables = length(mnesia:system_info(tables)),
    RunningTransactions = length(mnesia:system_info(transactions)),
    % The rest is cumulative.
    TransactionCommits = mnesia:system_info(transaction_commits),
    TransactionFailures = mnesia:system_info(transaction_failures),
    TransactionLogWrites = mnesia:system_info(transaction_log_writes),
    TransactionRestarts = mnesia:system_info(transaction_restarts),
    [
        {<<"running_nodes">>, RunningNodes}, 
        {<<"persistent_nodes">>, PersistentNodes},
        {<<"held_locks">>, HeldLocks},
        {<<"queued_locks">>, QueuedLocks},
        {<<"known_tables">>, KnownTables},
        {<<"running_transactions">>, RunningTransactions},
        {<<"transaction_commits">>, TransactionCommits},
        {<<"transaction_failures">>, TransactionFailures},
        {<<"transaction_log_writes">>, TransactionLogWrites},
        {<<"transaction_restarts">>, TransactionRestarts}
    ].


%%================================================================================================
%% Panels
%%================================================================================================
stats_panel(Context) ->
    Statistics = [{memory, memory_statistics()}, 
                  {basic, basic_statistics()}, 
                  {mnesia, mnesia_statistics()}],
    _Vars = Statistics ++ [{sites, z_sites_manager:get_sites()}],
    Content = z_template:render("panels/statistics.tpl", [{statistics, Statistics}], Context),    
    #zdt_panel{
       content=Content,
       dom_id="zdtb-stats",
       nav_title="Statistics", 
       nav_subtitle="System statistics",
       url="",
       has_content=true
      }.

message_log_panel(Context) ->
    Content = z_template:render("panels/message_log.tpl", [], Context),
    [{LogCount}] = z_db:q("select count(*) from log", Context),
    #zdt_panel{
       content=Content,
       dom_id="zdtb-logs",
       nav_title="Message Log", 
       nav_subtitle=erlang:integer_to_list(LogCount) ++ " messages",
       url="",
       has_content=true
      }.

configs_panel(Context) ->
    Content = z_template:render("panels/configs.tpl", [], Context),
    #zdt_panel{
       content=Content,
       dom_id="zdtb-configs",
       nav_title="Configs",
       nav_subtitle="Configurations",
       url="",
       has_content=true
      }.

http_vars_panel(Context) ->
    Content = z_template:render("panels/http_vars.tpl", [{z_context, Context}], Context),
    #zdt_panel{
       content=Content,
       dom_id="zdtb-req-vars",
       nav_title="HTTP Request",
       nav_subtitle="Request data/variables",
       url="",
       has_content=true
      }.

%% This function is not used, but rather 
%% see templates/toolbar.tpl for how the templates panel works
templates_panel(Context) ->
    NumberOfTemplates = integer_to_list(length(get_site_templates(Context))),
    #zdt_panel{
       dom_id="zdtb-tpl-templates",
       nav_title= "Templates",
       nav_subtitle=NumberOfTemplates ++ " Template files, variables etc",
       url="",
       has_content=true
      }.

sql_panel(Context) ->
    Content = z_template:render("panels/sql.tpl", [], Context),
    #zdt_panel{
       content=Content,
       dom_id="zdtb-sql",
       nav_title="SQL",
       nav_subtitle="SQL queries", 
       url="",
       has_content=true
      }.

modules_panel(Context) ->
    Modules = modules(Context),
    NumOfActiveModules = length(z_module_manager:active(Context)),
    ActiveModules =  integer_to_list(NumOfActiveModules) ++ " active modules",
    Content = z_template:render("panels/modules.tpl", Modules, Context),
    #zdt_panel{
       content=Content,
       dom_id="zdtb-modules",
       nav_title="Modules", 
       nav_subtitle=ActiveModules,
       url="",
       has_content=true
      }.

system_panel(Context) ->
    Cmd = "ps -e -o pcpu -o pid -o user -o args",
    %% split output into lines, using \n
    [_Head | OSProcs ] = string:tokens(os:cmd(Cmd), "\n"),
    OSProcs1 = [proc_to_tuple(X) || X <- OSProcs],
    Env = env_to_proplists(os:getenv()),
    Content = z_template:render("panels/system.tpl",
                                [{env, Env}, {os_procs, OSProcs1}], Context),
    #zdt_panel{
       content=Content,
       dom_id="zdtb-system",
       nav_title="System",
       nav_subtitle="CPU usage",
       url="", 
       has_content=true
      }.

dispatch_panel(Context) ->
    {_name, _title, _, _, _, _, DispatchInfo} = z_dispatcher:dispatchinfo(Context),
    DispatchRules = [
                    [
                     {name, Name}, 
                     {path, Path}, 
                     {resource, Resource}, 
                     {args, Args}
                    ] || {Name, Path, Resource, Args} <- DispatchInfo
                   ],
    Content = z_template:render("panels/dispatch.tpl",
                                [{dispatch_rules, DispatchRules}],Context),
    #zdt_panel{
       content=Content,
       dom_id="zdtb-dispatch",
       nav_title="URL dispatch",
       nav_subtitle="URL dispatch rules", 
       url="",
       has_content=true
      }.


%%% ==================================================================
%%% Zotonic Debug toolbar
%%% ==================================================================

%% truns alist of strings into a a list of tuples
-spec env_to_proplists([string()]) -> [tuple(string(), string())].
env_to_proplists(Env) when is_list(Env) ->
    [ to_tuple(X) || X <- Env].

%% @doc convert a Key, value string into a tuple
-spec to_tuple(string()) -> {string(), string()}.
to_tuple(KVString) ->
    Index = string:chr(KVString,$=),
    Key = string:sub_string(KVString, 1, Index - 1),
    Value = string:sub_string(KVString, Index + 1),
    {Key, Value}.


proc_to_tuple(Proc) ->
    [Cpu, Pid, User | Args ] = (string:tokens(Proc, "  ")),
    {Cpu, Pid, User, Args}.


-spec get_config(Key, Context) -> undefined | {ok, binary()} when
      Key :: atom(),
      Context :: #context{}.
get_config(Key, Context) when is_atom(Key) ->
    case m_config:get(?MODULE, Key, Context) of
        undefined ->
            undefined;
        Props ->
            {ok, proplists:get_value(value, Props)}
    end.

-spec is_address_allowed(string(), #context{}) -> true | false.    
is_address_allowed(Address, Context) ->
    case get_config(address, Context) of
        {ok, Addresses} ->
            if
                Addresses == <<"*">> ->
                    true;
                true ->
                    Addresses1 = binary_to_list(Addresses),
                    AddressList = lists:map(fun(X) -> z_string:trim(X) end,
                                            z_string:split(Addresses1, ",")),
                    AddressList1 = lists:umerge(AddressList, ?DEFAULT_ADDRESSES),
                    lists:member(Address, AddressList1)
            end;
        undefined ->
            false
    end.

%% @doc Returns true if the panel has been configured to be publicly visible.
%% Otherwise, false
-spec is_panel_visible(Panel, Context) -> true | false when
      Panel :: atom(),
      Context :: #context{}.
is_panel_visible(Panel, Context) when is_atom(Panel) ->
    case get_config(panels, Context) of
        {ok, Panels} ->
            if
                Panels == <<"*">> ->
                    true;
                 true ->
                    Panels1 = binary_to_list(Panels),
                    PanelList = lists:map(fun(X) -> z_string:trim(X) end,
                                            z_string:split(Panels1, ",")),
                    AllPanels = lists:map(fun(X) -> atom_to_list(X) end, ?ZDTB_PANELS),
                    PanelList1 = lists:subtract(AllPanels, PanelList),
                    lists:member(atom_to_list(Panel), PanelList1)
            end;
        undefined ->
            false
    end.

get_templates(Context) ->
    SiteDir = z_path:site_dir(Context),
    TemplatesDir = filename:join(SiteDir, "templates"),
    filelib:fold_files(TemplatesDir, ".*", true,
                       fun(File, Acc) -> [File|Acc] end, []). 

%% @doc Return's list of site's templates.
get_site_templates(Context) ->
    Templates = get_templates(Context),
    [ 
      ?RecordToProplists(
         zdt_template,
         #zdt_template
         {
           name=filename:basename(Filepath),
           origin_name=Filepath
         })                   
      || Filepath <- Templates
    ].
