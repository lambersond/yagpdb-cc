{{$args := parseArgs 1 ""
  (carg "duration" "countdown-duration")
}}

{{$ccID := YOUR-TIMER-EXEC-CUSTOM-COMMAND-ID-HERE}}
{{$avatar := print "https://cdn.discordapp.com/avatars/" .User.ID "/" .User.Avatar ".png"}}
{{$username := .User.Username}}
{{$title := "Kingdom VS Kingdom"}}
{{$color := 16098851}}
{{$description := ""}}
{{$thumbnail := "https://static.wikia.nocookie.net/lordsmobile/images/e/e6/Site-logo.png"}}
{{$imageUrl := "https://i.ytimg.com/vi/S5mwEDt3724/maxresdefault.jpg"}}

{{$t := currentTime.Add ($args.Get 0)}}
{{$d := $t.Add (toDuration "23h30m")}}

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
{{execCC $ccID nil 0 (sdict "MessageID" $mID "T" $t "D" $d "Title" $title "Description" $description "Username" $username "Avatar" $avatar "url" $imageUrl "color" $color "thumbnail" $thumbnail)}}
{{deleteTrigger 0}}