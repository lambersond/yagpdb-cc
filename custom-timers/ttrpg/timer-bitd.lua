{{$args := parseArgs 2 ""
  (carg "duration" "countdown-until")
  (carg "role" "countdown-role")
  (carg "string" "countdown-duration")
}}

{{$ccID := YOUR-TIMER-EXEC-CUSTOM-COMMAND-ID-HERE}}
{{$avatar := print "https://cdn.discordapp.com/avatars/" .User.ID "/" .User.Avatar ".png"}}
{{$username := .User.Username }}
{{$title := "Blades In the Dark"}}
{{$color := 2624768}}
{{$description := "This is a countdown timer for an upcoming Blades in the Dark session."}}
{{$thumbnail := "https://img.itch.zone/aW1nLzMzMTY2NTgucG5n/original/BWh368.png"}}
{{$imageUrl := ""}}

{{$t := currentTime.Add ($args.Get 0)}}
{{$d := $t.Add (toDuration (or ($args.Get 3) "0m"))}}
{{$embed := cembed
  "title" $title
  "description" $description
  "color" $color
  "author" (sdict "name" $username "icon_url" $avatar)
  "image" (sdict "url" $imageUrl)
  "thumbnail" (sdict "url" $thumbnail)
  "fields" (cslice (sdict "name" "Time left:" "value" (humanizeDurationSeconds ($t.Sub currentTime)) "inline" false))
  "timestamp" $t
}}

{{$mID := sendMessageNoEscapeRetID nil (complexMessage "content" (mentionRoleID ($args.Get 1).ID) "embed" $embed)}}
{{execCC $ccID nil 0 (sdict "MessageID" $mID "T" $t "D" $d "Title" $title "Description" $description "Username" $username "Avatar" $avatar "url" $imageUrl "color" $color "thumbnail" $thumbnail)}}
{{deleteTrigger 0}}