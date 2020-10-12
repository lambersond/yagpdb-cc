{{/* CONFIGURATION - YOUR_CC_ID */}}
{{$publishEventCustomCommandID := 31}}

{{$args := parseArgs 2 "Syntax is: -ce-time <eventID> <HH:mm>"
    (carg "string" "event Id")
    (carg "string" "content")
}}

{{$id := 5007}}
{{$eventID := $args.Get 0}}
{{$ownerID := .User.ID}}
{{$key := (joinStr "_" $eventID $ownerID)}}

{{$raw := ($args.Get 1)}}
{{$raw_split := (split $raw ":")}}
{{$inputValid := "null"}}
{{$hour :=  (toInt (index $raw_split 0))}}
{{$minute :=  (toInt (index $raw_split 1))}}

{{if and (and (ge $hour 0) (lt $hour 24)) (and (ge $minute 0) (lt $minute 60))}}
    {{$inputValid = "valid"}}
{{end}}

{{if eq $inputValid "valid"}}
    {{$eventExists := (dbGet 4999 $eventID)}}
    {{$failedAccessMsg :=  (joinStr "" "An event with **ID:** `" $eventID "` ___does not exist___ **or** you  ___do not have access___ to it.")}}
    {{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}
    {{$content := (joinStr "" $hour ":" $minute)}}
    {{$hasCorrectPerms := "false"}}

    {{if or (eq (toInt64 $eventExists.Value) $ownerID) (hasRoleID $organizerID)}}
        {{$hasCorrectPerms = "allowed"}}
        {{$ownerID = $eventExists.Value}}
    {{end}}

    {{if and (not (eq (toInt64 $eventExists.Value) 0)) (eq $hasCorrectPerms "allowed")}}
        {{dbSet $id $key $content}}
        {{sendDM (joinStr "" "\nEvent Updated!\n\n**EventID:**`" $eventExists.Value "`\n**Time:**\n```" $content "\n```")}}

        {{$publishedEvent = dbGet 5001 (joinStr "_" $eventID $ownerID)}}
        {{if gt (len (str $publishedEvent.ID)) 0}}
            {{execCC $publishEventCustomCommandID nil 0 (sdict "creatorID" $creatorID "eventID" $eventID )}}
        {{end}}
    {{else}}
        {{sendDM $failedAccessMsg}}
    {{end}}
{{else}}
    {{sendDM "An invalid time has been passed. Correct format is `[0-23]:[0-59]`"}}
{{end}}

{{deleteTrigger 0}}