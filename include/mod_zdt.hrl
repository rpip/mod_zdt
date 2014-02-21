%%%-------------------------------------------------------------------
%%% @author Mawuli Adzaku <mauwli@mawuli.me>
%%% @copyright (C) 2013, Mawuli Adzaku
%%% @doc
%%%
%%% @end
%%% Created : 27 Sep 2013 by Mawuli Adzaku <mawuli@mawuli.me>
%%%-------------------------------------------------------------------
-record(zdt_panel, {
          content :: string(), 
          dom_id :: integer(), 
          nav_title :: string(), 
          nav_subtitle :: string(), 
          url :: string(),
          has_content=false
         }).

-define(ZDTB_PANELS, [
                      stats, 
                      configs, 
                      dispatch, 
                      sql, 
                      http_vars, 
                      templates, 
                      modules, logs, 
                      system
                     ]).

-define(R2P(Panel), lists:zip(record_info(fields, zdt_panel), tl(tuple_to_list(Panel)))).
