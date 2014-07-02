%%%-------------------------------------------------------------------
%%% @author Mawuli Adzaku <mauwli@mawuli.me>
%%% @copyright (C) 2013, Mawuli Adzaku
%%% @doc
%%%
%%% @end
%%% Created : 27 Sep 2013 by Mawuli Adzaku <mawuli@mawuli.me>
%%%-------------------------------------------------------------------
-record(zdt_panel, 
        {
          content = undefined :: string(), 
          dom_id :: integer(), 
          nav_title :: string(), 
          nav_subtitle :: string(), 
          url = "" :: string(),
          has_content=false
         }).

-record(zdt_template,
        {
          name="" :: string(),
          origin_name="" :: string()          
         }).

-define(DEFAULT_ADDRESSES, ["127.0.0.1", "::1", "localhost"]).

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

-define(RecordToProplists(Name, Record), lists:zip(record_info(fields, Name), tl(tuple_to_list(Record)))).
