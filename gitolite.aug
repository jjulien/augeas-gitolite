(*

Copyright (C) 2013 John Julien <john@julienfamily.com>

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

*)

module Gitolite =

  autoload xfm

  (* Useful Primatives *)
  let eol = del /\n/ "\n"
  let empty = [ del /^[ \t]*\n/ "\n" ]

  (* 
     Gitolite Specific Syntax - Based on Gitolite version 3
     Soure: http://gitolite.com/gitolite/syntax.html
 
     NOTE: Configs that use syntatic sugar are not supported by this module.
           http://gitolite.com/gitolite/cust.html#sugar *)
  let user_syntax = store /\@?[0-9a-zA-Z][-0-9a-zA-Z._\@+]*/
  let group_syntax = del /^@/ "@" . store /[a-zA-Z0-9]+[a-zA-Z0-9._\-]*/ . del /[ \t]*=/ " ="
  let reponame_syntax = store /\@?[0-9a-zA-Z][-0-9a-zA-Z._\@\/+]*/

  (* Setup Group Lens *)
  let user = label "user" . Util.del_ws_spc . user_syntax
  let group = label "group" . group_syntax
  let groups = [ group . [ user ]+ ] . eol+

  (* Setup Repo Lens *)
  let repo = label "repo" . del /^repo[ \t]+/ "repo " . reponame_syntax . eol

  (* TODO: It might be nice to break the access rules down into nodes (rule -> ref -> access)
           1st iteration will just plop a string in place for the access rule.  It's up to 
           to user to make sure the syntax is correct  *)
  let access_rule = [ label "accessrule" . del /[ \t]+/ "  " . store /[^ \t][^\n]+/ . eol ]
  let repos = [ repo . (access_rule)* ]

  (* TODO: Need to add support for include sections *)
  
  (* Final setup of lens *)
  let lns = ( empty | repos | groups )*

  let filter = incl "/home/*/gitolite-admin/conf/gitolite.conf" . incl "/var/lib/gitolite3/gitolite-admin/conf/gitolite.conf"  

  let xfm = transform lns filter
