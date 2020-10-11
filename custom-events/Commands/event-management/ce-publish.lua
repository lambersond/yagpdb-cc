{{$args := parseArgs 1 "Syntax is: -ce-publish <eventID>"
    (carg "int" "event Id")
}}

{{$blankValue := "<:empty_blank:744721937397448734>"}}

{{$userID := .User.ID}}
{{$eventID := (toInt64 ($args.Get 0))}}
{{if .ExecData}}
    {{$userID = (toInt64 .ExecData.creatorID)}}
    {{$eventID = (toInt64 .ExecData.eventID)}}
{{else}}
    {{deleteTrigger 60}}
{{end}}

{{$publishingChannelID := (joinStr "" (dbGet 5000 (joinStr "_" $eventID $userID)).Value)}}
{{$publishedEventID := (joinStr "" (dbGet 5001 (joinStr "_" $eventID $userID)).Value)}}

{{$title := (joinStr "" (dbGet 5002 (joinStr "_" $eventID $userID)).Value)}}
{{$description := (joinStr "" (dbGet 5003 (joinStr "_" $eventID $userID)).Value)}}
{{$participantMax := (joinStr "" (dbGet 5004 (joinStr "_" $eventID $userID)).Value)}}
{{$participants := dbGet 5010 $eventID}}
{{$participantCount := 0}}
{{if gt (len (str $participants.ID)) 0}}
    {{if gt (len $participants.Value) 0}}
        {{$participantCount = (len (split $participants.Value " ")) }}
    {{end}}
{{end}}
{{$attending := 0 }}
{{ if le (toInt $participantMax) 0 }} {{$attending = $participantCount}}
    {{ else }}	{{$attending = (joinStr "/" $participantCount $participantMax)}}
{{end}}
{{$eDate := (joinStr "" (dbGet 5006 (joinStr "_" $eventID $userID)).Value)}}
{{$eTime := (joinStr "" (dbGet 5007 (joinStr "_" $eventID $userID)).Value)}}

{{$game := (joinStr "" (dbGet 5009 (joinStr "_" $eventID $userID)).Value)}}
{{$gameIcon :=  (joinStr "" (dbGet 4990 (joinStr "_" "game" $game)).Value)}}
{{$gameRoles := (dbGet 4990 $game).Value }}
{{$fields := (cslice
        (sdict "value" (joinStr "" "<:attending:744705141328052224> **" $attending "**" "") "name" $blankValue "inline" true)
        (sdict "value" (joinStr "" "<:calendar2:744706382275543111> **" $eDate "**" "") "name" $blankValue "inline" true)
        (sdict "value" (joinStr "" "<:time:744705466399195177> [**" $eTime "** [GMT-4]](https://www.thetimezoneconverter.com/?t=" (urlescape $eTime) "&tz=GMT-4)" "") "name" $blankValue "inline" true)
        (sdict "value" $blankValue "name" $blankValue "inline" false)
    )
}}
{{$participantList := cslice}}
{{$participantListArray := cslice}}
{{if gt (len (str $participants.Value)) 2}}
    {{$participantList = $participants.Value}}
    {{$participantListArray = split (str $participantList) " "}}
{{end}}

{{if and (gt (len $participantListArray) (toInt $participantMax)) (gt (toInt $participantMax) 0)}}
    {{$participantListArray = slice $participantListArray 0 (toInt $participantMax)}}
{{end}}
{{range $gameRoles}}
    {{$roleUsers := ""}}
    {{$roleCount := 0}}
    {{$roleName := .}}
    {{if gt (len $participantListArray) 0}}
        {{range $participantListArray}}
            {{$entry := split . "_"}}
            {{if eq (index $entry 0) $roleName}}
                {{$uClass := (index $entry 2)}}
                {{$classIconID := (dbGet 4992 (joinStr "_" "class" $uClass)).Value}}
                {{$userEntry := ""}}
                {{if not (eq (toInt64 $classIconID) 0)}}
                    {{$userEntry = (joinStr "" "<:" $uClass ":" $classIconID "> ")}}
                {{end}}
                {{$userEntry := (joinStr "" $userEntry "<@" (index $entry 1) ">")}}
                {{$roleUsers = joinStr "" $roleUsers "\n" $userEntry}}
                {{$roleCount = add $roleCount 1}}
            {{end}}
        {{end}}
    {{end}}

    {{if eq (len $roleUsers) 0}}
        {{$roleUsers = $blankValue}}
    {{end}}

    {{$headerEmojiID := (toInt64 (dbGet 4991 (joinStr "_" "role" .)).Value)}}
    {{$header := ""}}
    {{if gt $headerEmojiID 0}}
        {{$headerIcon := (joinStr "" "<:" . ":" $headerEmojiID ">")}}
        {{$header = (joinStr "" $headerIcon " __" (upper .) "__ - **" $roleCount "**")}}
    {{else}}
        {{$header = (joinStr "" "__" (upper .) "__ - **" $roleCount "**")}}
    {{end}}
    {{$fields = $fields.Append (sdict "name" $header "value" $roleUsers "inline" true)}}
{{end}}
{{$fields := $fields.Append (sdict "value" $blankValue "name" $blankValue "inline" false)}}
{{$owner := (userArg $userID)}}
{{ $embed := cembed
    "title" (joinStr "" "\n" $title "\n")
    "description" (joinStr "" "**Info:** " $description "")
    "color" 7456357
    "timestamp" currentTime
    "author" (sdict "name" (joinStr "" $owner.Username "#" $owner.Discriminator) "url" "" "icon_url" ($owner.AvatarURL "512"))
    "thumbnail" (sdict "url" $gameIcon)
    "footer" (sdict "text" "A custom event!")
    "fields" $fields
}}

{{if gt (toInt64 $publishedEventID) 0}}
    {{editMessageNoEscape nil $publishedEventID (complexMessageEdit "embed" $embed)}}
{{else}}
    {{$mID := sendMessageNoEscapeRetID nil $embed}}

    {{range $gameRoles}}
        {{$roleDB := dbGet 4991 (joinStr "_" "role" .)}}
        {{$roleName := slice $roleDB.Key 5 (len $roleDB.Key)}}
        {{addMessageReactions nil $mID (joinStr ":" $roleName $roleDB.Value )}}
    {{end}}

    {{/* dbSet 5010 $eventID "" */}}
    {{dbSet 5001 (joinStr "_" $eventID $userID) (joinStr "" $mID)}}
    {{dbSet 5011 $mID (joinStr "" $eventID)}}
{{end}}