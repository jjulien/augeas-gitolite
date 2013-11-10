module Test_gitolite =

let conf = "
@stooges = moe larry curly
@admins = healy
@composers = friend monaco
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

test Gitolite.lns get conf =   {  }
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

test Gitolite.lns put "repo pranks\n  RW+  = @stooges\n" after
    set "/repo[. = 'pranks']/accessrule[. = 'R = goldberb']" "R = goldberg" =
    "repo pranks\n  RW+  = @stooges\n  R = goldberg\n"

test Gitolite.lns put "@mygroup = user1 user2\n" after
    rm "/group[. = 'mygroup']/user[. = 'user1']" =
    "@mygroup = user2\n"

test Gitolite.lns put "@mygroup = user1 user2\n" after
    set "/group[. = 'mygroup']/user[. = 'user3']" "user3" =
    "@mygroup = user1 user2 user3\n"

test Gitolite.lns put "@mygroup = user1 user2\n" after
    set "/group[. = 'mygroup']/user[. = 'user2']" "user2" =
    "@mygroup = user1 user2\n"
