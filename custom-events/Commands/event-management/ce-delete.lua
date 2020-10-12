{{$args := parseArgs 1 "Syntax is: -event-delete <eventID>"
    (carg "string" "event Id")
}}

{{$eventExists := (dbGet 4999 ($args.Get 0))}}
{{$failedAccessMsg :=  (joinStr "" "An event with **ID:** `" ($args.Get 0) "` ___does not exist___ **or** you  ___do not have access___ to it.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}
{{$hasCorrectPerms := "false"}}

{{if or (eq (toInt64 $eventExists.Value) .User.ID) (hasRoleID $organizerID)}}
    {{$hasCorrectPerms = "allowed"}}
{{end}}

{{if and (not (eq (toInt64 $eventExists.Value) 0)) (eq $hasCorrectPerms "allowed")}}
    {{$eventID := $eventExists.Key}}
    {{$creatorID := $eventExists.Value}}
    {{dbDel 4999 $eventID}}
    {{dbDel 5000 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5001 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5002 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5003 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5004 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5005 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5006 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5007 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5008 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5009 (joinStr "_" $eventID $creatorID)}}
    {{dbDel 5010 $eventID}}
{{else}}
    {{sendDM $failedAccessMsg }}
{{end}}

{{deleteTrigger 0}}