{{$args := parseArgs 2 ""
  (carg "duration" "countdown-duration")
  (carg "role" "countdown-role")
}}

{{$ccID := YOUR-TIMER-EXEC-CUSTOM-COMMAND-ID-HERE}}
{{$avatar := print "https://cdn.discordapp.com/avatars/" .User.ID "/" .User.Avatar ".png"}}
{{$username := .User.Username}}
{{$title := "YOUR TITLE HERE"}}
{{$color := 2624768}}
{{$description := "This is a countdown timer that mentions a role."}}
{{$thumbnail := "https://cdn.discordapp.com/embed/avatars/0.png"}}
{{$imageUrl := "https://cdn.discordapp.com/embed/avatars/0.png"}}

{{$t := currentTime.Add ($args.Get 0)}}
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
{{execCC $ccID nil 0 (sdict "MessageID" $mID "T" $t "Title" $title "Description" $description "Username" $username "Avatar" $avatar "url" $url "color" $color "thumbnail" $thumbnail)}}
{{deleteTrigger 0}}