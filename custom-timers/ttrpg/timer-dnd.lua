{{$args := parseArgs 2 ""
  (carg "duration" "countdown-until")
  (carg "role" "countdown-role")
  (carg "string" "countdown-duration")
}}

{{$ccID := YOUR-TIMER-EXEC-CUSTOM-COMMAND-ID-HERE}}
{{$avatar := print "https://cdn.discordapp.com/avatars/" .User.ID "/" .User.Avatar ".png"}}
{{$username := .User.Username}}
{{$title := "Dungeons & Dragons (5e)"}}
{{$color := 12006912}}
{{$description := "This is a countdown timer for an upcoming D&D 5e session."}}
{{$thumbnail := "https://assets1.ignimgs.com/thumbs/userUploaded/2019/5/29/dndmobilebr-1559158864269.jpg"}}
{{$imageUrl := ""}}

{{$t := currentTime.Add ($args.Get 0)}}
{{$d := $t.Add (toDuration (or ($args.Get 2) "0m"))}}

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