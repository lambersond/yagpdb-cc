{{/* CONFIGURATION - YOUR_CC_ID */}}
{{$publishEventCustomCommandID := 31}}

{{$args := parseArgs 2 "Syntax is: -ce-max <eventID> <int>"
    (carg "string" "event Id")
    (carg "int" "content")
}}

{{$id := 5004}}
{{$eventID := $args.Get 0}}
{{$ownerID := .User.ID}}
{{$key := (joinStr "_" $eventID $ownerID)}}

{{$content := (joinStr " " (slice .CmdArgs 1))}}
{{$eventExists := (dbGet 4999 $eventID)}}
{{$failedAccessMsg :=  (joinStr "" "An event with **ID:** `" $eventID "` ___does not exist___ **or** you  ___do not have access___ to it.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}
{{$hasCorrectPerms := "false"}}

{{if or (eq (toInt64 $eventExists.Value) $ownerID) (hasRoleID $organizerID)}}
    {{$hasCorrectPerms = "allowed"}}
    {{$ownerID = $eventExists.Value}}
{{end}}

{{if and (not (eq (toInt64 $eventExists.Value) 0)) (eq $hasCorrectPerms "allowed")}}
    {{dbSet $id $key $content}}
    {{sendDM (joinStr "" "\nEvent Updated!\n\n**EventID:**`" $eventID "`\n**Max Participants:**\n```" $content "\n```")}}

    {{$publishedEvent := dbGet 5001 (joinStr "_" $eventID $ownerID)}}
    {{if gt (len (str $publishedEvent.ID)) 0}}
        {{execCC $publishEventCustomCommandID nil 0 (sdict "creatorID" $ownerID "eventID" $eventID )}}
    {{end}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}