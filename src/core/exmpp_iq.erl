% $Id$

%% @author Jean-Sébastien Pédron <js.pedron@meetic-corp.com>

%% @doc
%% The module <strong>{@module}</strong> provides helper to do IQ common
%% operations.

-module(exmpp_iq).
-vsn('$Revision$').

-include("exmpp.hrl").

% Creation.
-export([
  get/2,
  get/3,
  set/2,
  set/3,
  result/1,
  result/2,
  error/2,
  error_without_original/2
]).

% IQ standard attributes.
-export([
  get_type/1
]).

% --------------------------------------------------------------------
% IQ creation.
% --------------------------------------------------------------------

%% @spec (NS, Request) -> IQ
%%     NS = atom()
%%     Request = exmpp_xml:xmlnselement()
%%     IQ = exmpp_xml:xmlnselement()
%% @doc Prepare an `<iq/>' to transport the given `get' request.

get(NS, Request) ->
    get(NS, Request, undefined).

%% @spec (NS, Request, ID) -> Request_IQ
%%     NS = atom()
%%     Request = exmpp_xml:xmlnselement()
%%     ID = string()
%%     Request_IQ = exmpp_xml:xmlnselement()
%% @doc Prepare an `<iq/>' to transport the given `get' request.

get(NS, Request, ID) ->
    Attrs1 = exmpp_error:set_type_in_attrs([], "get"),
    Attrs2 = exmpp_error:set_id_in_attrs(Attrs1, ID),
    #xmlnselement{
      ns = NS,
      name = 'iq',
      attrs = Attrs2,
      children = [Request]
    }.

%% @spec (NS, Request) -> Request_IQ
%%     NS = atom()
%%     Request = exmpp_xml:xmlnselement()
%%     Request_IQ = exmpp_xml:xmlnselement()
%% @doc Prepare an `<iq/>' to transport the given `set' request.

set(NS, Request) ->
    set(NS, Request, undefined).

%% @spec (NS, Request, ID) -> Request_IQ
%%     NS = atom()
%%     Request = exmpp_xml:xmlnselement()
%%     ID = string()
%%     Request_IQ = exmpp_xml:xmlnselement()
%% @doc Prepare an `<iq/>' to transport the given `set' request.

set(NS, Request, ID) ->
    Attrs1 = exmpp_error:set_type_in_attrs([], "set"),
    Attrs2 = exmpp_error:set_id_in_attrs(Attrs1, ID),
    #xmlnselement{
      ns = NS,
      name = 'iq',
      attrs = Attrs2,
      children = [Request]
    }.

%% @spec (Request_IQ) -> Response_IQ
%%     Request_IQ = exmpp_xml:xmlnselement()
%%     Response_IQ = exmpp_xml:xmlnselement()
%% @doc Prepare an `<iq/>' to answer to the given request.

result(Request_IQ) ->
    Attrs1 = exmpp_error:set_type_in_attrs([], "result"),
    Attrs2 = exmpp_error:set_id_in_attrs(Attrs1,
      exmpp_error:get_id(Request_IQ)),
    #xmlnselement{
      ns = Request_IQ#xmlnselement.ns,
      name = 'iq',
      attrs = Attrs2,
      children = []
    }.

%% @spec (Request_IQ, Result) -> Response_IQ
%%     Request_IQ = exmpp_xml:xmlnselement()
%%     Result = exmpp_xml:xmlnselement()
%%     Response_IQ = exmpp_xml:xmlnselement()
%% @doc Prepare an `<iq/>' to answer to the given request with `Result'.

result(Request_IQ, Result) ->
    exmpp_xml:set_children(result(Request_IQ), [Result]).

%% @spec (Request_IQ, Error) -> Response_IQ
%%     Request_IQ = exmpp_xml:xmlnselement()
%%     Error = exmpp_xml:xmlnselement()
%%     Response_IQ = exmpp_xml:xmlnselement()
%% @doc Prepare an `<iq/>' to notify an error.

error(IQ, Error) ->
    Attrs1 = exmpp_error:set_id([], exmpp_error:get_id(IQ)),
    exmpp_error:stanza_error(IQ#xmlnselement{attrs = Attrs1}, Error).

%% @spec (Request_IQ, Error) -> Response_IQ
%%     Request_IQ = exmpp_xml:xmlnselement()
%%     Error = exmpp_xml:xmlnselement()
%%     Response_IQ = exmpp_xml:xmlnselement()
%% @doc Prepare an `<iq/>' to notify an error.
%%
%% Child elements from `Request_IQ' are not kept.

error_without_original(IQ, Error) ->
    Attrs1 = exmpp_error:set_id_in_attrs([], exmpp_error:get_id(IQ)),
    exmpp_error:stanza_error_without_original(IQ#xmlnselement{attrs = Attrs1},
      Error).

% --------------------------------------------------------------------
% IQ standard attributes.
% --------------------------------------------------------------------

%% @spec (IQ) -> Type
%%     IQ = exmpp_xml:xmlnselement()
%%     Type = get | set | result | error | undefined
%% @doc Return the type of the given `<iq/>'.

get_type(IQ) ->
    case exmpp_error:get_type(IQ) of
        "get"    -> 'get';
        "set"    -> 'set';
        "result" -> 'result';
        "error"  -> 'error';
        _        -> undefined
    end.
