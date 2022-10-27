{{$args := parseArgs 2 ""
  (carg "duration" "countdown-until")
  (carg "string" "countdown-title")
}}

{{$ccID := YOUR-TIMER-EXEC-CUSTOM-COMMAND-ID-HERE}}
{{$avatar := print "https://cdn.discordapp.com/avatars/" .User.ID "/" .User.Avatar ".png"}}
{{$username := .User.Username}}
{{$title := ($args.Get 1)}}
{{$color := 867083}}
{{$description := ""}}
{{$thumbnail := "https://static.wikia.nocookie.net/lordsmobile/images/8/84/Darknest.png"}}
{{$imageUrl := ""}}

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

{{$mID := sendMessageNoEscapeRetID nil (complexMessage "content" "" "embed" $embed)}}
{{execCC $ccID nil 0 (sdict "MessageID" $mID "T" $t "D" $t "Title" $title "Description" $description "Username" $username "Avatar" $avatar "url" $imageUrl "color" $color "thumbnail" $thumbnail)}}
{{deleteTrigger 0}}