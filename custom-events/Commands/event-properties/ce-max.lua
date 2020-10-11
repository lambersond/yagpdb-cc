{{$args := parseArgs 2 "Syntax is: -ce-max <eventID> <int>"
    (carg "string" "event Id")
    (carg "int" "content")
}}
{{$id := 5004}}
{{$key := (joinStr "_" ($args.Get 0) (.User.ID))}}

{{$content := (joinStr " " (slice .CmdArgs 1))}}
{{$eventExists := (dbGet 4999 ($args.Get 0))}}
{{$failedAccessMsg :=  (joinStr "" "An event with **ID:** `" ($args.Get 0) "` ___does not exist___ **or** you  ___do not have access___ to it.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}
{{$hasCorrectPerms := "false"}}

{{if or (eq (toInt64 $eventExists.Value) .User.ID) (hasRoleID $organizerID)}}
    {{$hasCorrectPerms = "allowed"}}
{{end}}

{{if and (not (eq (toInt64 $eventExists.Value) 0)) (eq $hasCorrectPerms "allowed")}}
    {{dbSet $id $key $content}}
    {{sendDM (joinStr "" "\nEvent Updated!\n\n**EventID:**`" $eventExists.Value "`\n**Max Participants:**\n```" $content "\n```")}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}