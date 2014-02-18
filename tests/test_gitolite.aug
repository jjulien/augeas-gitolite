module Test_gitolite =

let conf = "
# Test config
@stooges = moe larry curly
@admins = healy
@composers = friend monaco
@cast_and_crew = @stooges @admins @composers
repo souptonuts
   RW+                 = @admins
   RW                  = goldberg
   R                   = @stooges
   RW music/           = @composers
   -  VREF/NAME/music  = @admins
   -  VREF/NAME/music  = goldberg
repo meto
  RW  = joe
"

(* Parse the above sample config and verify the results *)
test Gitolite.lns get conf =   {  }
  { "comment" = " Test config" }
  { "group" = "stooges"
    { "user" = "moe" }
    { "user" = "larry" }
    { "user" = "curly" }
  }
  { "group" = "admins"
    { "user" = "healy" }
  }
  { "group" = "composers"
    { "user" = "friend" }
    { "user" = "monaco" }
  }
  { "group" = "cast_and_crew" 
    { "user" = "@stooges"   }
    { "user" = "@admins"    }
    { "user" = "@composers" }
  }
  { "repo" = "souptonuts"
    { "accessrule" = "RW+                 = @admins" }
    { "accessrule" = "RW                  = goldberg" }
    { "accessrule" = "R                   = @stooges" }
    { "accessrule" = "RW music/           = @composers" }
    { "accessrule" = "-  VREF/NAME/music  = @admins" }
    { "accessrule" = "-  VREF/NAME/music  = goldberg" }
  }
  { "repo" = "meto"
    { "accessrule" = "RW  = joe" }
  }

(* Testing the addition of a read rule to a specific repo node *)
test Gitolite.lns put "repo pranks\n  RW+  = @stooges\n" after
    set "/repo[. = 'pranks']/accessrule[. = 'R = goldberb']" "R = goldberg" =
    "repo pranks\n  RW+  = @stooges\n  R = goldberg\n"

(* Testing the removal of a user node from a group node *)
test Gitolite.lns put "@mygroup = user1 user2\n" after
    rm "/group[. = 'mygroup']/user[. = 'user1']" =
    "@mygroup = user2\n"

(* Testing the automatic appending of a user node when a match is not found *)
test Gitolite.lns put "@mygroup = user1 user2\n" after
    set "/group[. = 'mygroup']/user[. = 'user3']" "user3" =
    "@mygroup = user1 user2 user3\n"

(* Testing the idempotent nature of matching a user *)
test Gitolite.lns put "@mygroup = user1 user2\n" after
    set "/group[. = 'mygroup']/user[. = 'user2']" "user2" =
    "@mygroup = user1 user2\n"

(* Testing the use of set to add groups to a groups *)
test Gitolite.lns put "@group_of_groups = @group1 @group2\n" after
    set "/group[. = 'group_of_groups']/user[. = '@group3']" "@group3" =
    "@group_of_groups = @group1 @group2 @group3\n"

(* Testing the use of set to manage comments *)
test Gitolite.lns put "#first comment\n" after
    set "/comment" "modified comment" =
    "#modified comment\n"

(* Testing the use of set to add additional comment nodes *)
test Gitolite.lns put "# existing comment\n" after
    set "/comment[last()+1]" "new comment" =
    "# existing comment\n#new comment\n"
