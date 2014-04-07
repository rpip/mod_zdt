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
-export([observe_admin_menu/3]).
-include_lib("zotonic.hrl").
-include_lib("modules/mod_admin/include/admin_menu.hrl").
-include_lib("include/mod_zdt.hrl").
-export([
         panels/0, 
         panel/2, 
         build_panels/1
        ]).

observe_admin_menu(admin_menu, Acc, Context) ->
    [
     #menu_item{id=admin_zdt,
                parent=admin_modules,
                label=?__("Debug Toolbar", Context),
                url={admin_zdt},
                visiblecheck={acl, use, ?MODULE}}
     |Acc].


    
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
    Panels = lists:map(fun(P) -> 
                               ?R2P(panel(P, Context)) 
                       end, ?ZDTB_PANELS),
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
    #zdt_panel{content=Content, dom_id="zdtb-stats", nav_title="Statistics", 
           nav_subtitle="System statistics", url="", has_content=true}.

message_log_panel(Context) ->
    Content = z_template:render("panels/message_log.tpl", [], Context),
    [{LogCount}] = z_db:q("select count(*) from log", Context),
    #zdt_panel{content=Content, dom_id="zdtb-logs", nav_title="Message Log", 
        nav_subtitle=erlang:integer_to_list(LogCount) ++ " messages", url="", has_content=true}.

configs_panel(Context) ->
    Content = z_template:render("panels/configs.tpl", [], Context),
    #zdt_panel{content=Content, dom_id="zdtb-configs", nav_title="Configs",
    nav_subtitle="Configurations", url="", has_content=true}.

http_vars_panel(Context) ->
    Content = z_template:render("panels/http_vars.tpl", [{z_context, Context}], Context),
    #zdt_panel{content=Content, dom_id="zdtb-req-vars", nav_title="HTTP Request",
      nav_subtitle="Request data/variables", url="", has_content=true}.

templates_panel(_Context) ->
    %% Content = z_template:render("panels/templates.tpl", [], Context),
    #zdt_panel{content=undefined, dom_id="zdtb-tpl-vars", nav_title="Templates",
    nav_subtitle="Template files, variables etc", url="", has_content=true}.

sql_panel(Context) ->
    Content = z_template:render("panels/sql.tpl", [], Context),
    #zdt_panel{content=Content, dom_id="zdtb-sql", nav_title="SQL", nav_subtitle="SQL queries", 
     url="", has_content=true}.

modules_panel(Context) ->
    Modules = modules(Context),
    ActiveModules = integer_to_list(length(z_module_manager:active(Context))) ++ " active modules",
    Content = z_template:render("panels/modules.tpl", Modules, Context),
    #zdt_panel{content=Content, dom_id="zdtb-modules", nav_title="Modules", 
            nav_subtitle=ActiveModules, url="", has_content=true}.

system_panel(Context) ->
    _Cmd = "ps -e -o pcpu -o pid -o user -o args",
    Content = z_template:render("panels/system.tpl", [], Context),
    #zdt_panel{content=Content, dom_id="zdtb-system", nav_title="System",
           nav_subtitle="CPU usage", url="", has_content=true}.

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
    Content = z_template:render("panels/dispatch.tpl", [{dispatch_rules, DispatchRules}], Context),
    #zdt_panel{content=Content, dom_id="zdtb-dispatch", nav_title="URL dispatch", nav_subtitle="URL dispatch rules", 
    url="", has_content=true}.
