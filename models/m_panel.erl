%%%-------------------------------------------------------------------
%%% @author Mawuli Adzaku <mawuli@mawuli.me>
%%% @copyright (C) 2013, Mawuli Adzaku
%%% @doc
%%%
%%% @end
%%% Created : 28 Sep 2013 by Mawuli Adzaku <mawuli@mawuli.me>
%%%-------------------------------------------------------------------
-module(m_panel).
-author("Mawuli Adzaku <mawuli@mawuli.me>").

-behaviour(gen_model).

%% interface functions
-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

-include_lib("zotonic.hrl").
-include("../include/mod_zdt.hrl").

%% return a property of the model
m_find_value(value, #m{}=M, Context) ->
    m_value(M, Context);

m_find_value(Key, #m{value=V} = _M, _Context) ->
    case lists:member(Key,[record_info(fields, zdt_panel)]) of
        true ->  proplists:get_value(Key,V);
        false -> undefined
    end.     

%% @doc Transform a m_zdtb value to a list, used for template loops
%% @spec m_to_list(Source, Context) -> []
m_to_list(#m{value=_V}, Context) ->
    mod_zdt:build_panels(Context).
    
%% @doc return a model
m_value(#m{value=V}, _Context) ->
    V.


