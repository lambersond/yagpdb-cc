{{$args := parseArgs 2 ""
  (carg "duration" "countdown-until")
  (carg "string" "countdown-title")
  (carg "string" "countdown-description")
  (carg "string" "countdown-image_url")
  (carg "string" "countdown-duration")
}}

{{$ccID := YOUR-TIMER-EXEC-CUSTOM-COMMAND-ID-HERE}}
{{$avatar := print "https://cdn.discordapp.com/avatars/" .User.ID "/" .User.Avatar ".png"}}
{{$username := .User.Username}}
{{$title := ($args.Get 1)}}
{{$description := ($args.Get 2)}}
{{$imageUrl := ($args.Get 3)}}
{{$color := 4645612}}
{{$thumbnail := ""}}

{{$t := currentTime.Add ($args.Get 0)}}
{{$d := $t.Add (toDuration (or ($args.Get 5) "0m"))}}

{{$embed := cembed
  "title" $title
  "description" $description
  "color" 4645612
  "author" (sdict "name" $username "icon_url" $avatar)
  "image" (sdict "url" $imageUrl)
  "fields" (cslice (sdict "name" "Time left:" "value" (humanizeDurationSeconds ($t.Sub currentTime)) "inline" false))
  "timestamp" $t
}}

{{$mID := sendMessageNoEscapeRetID nil $embed}}
{{execCC $ccID nil 0 (sdict "MessageID" $mID "T" $t "D" $d "Title" $title "Description" $description "Username" $username "Avatar" $avatar "url" $imageUrl "thumbnail" $thumbnail "color" $color)}}
{{deleteTrigger 0}}