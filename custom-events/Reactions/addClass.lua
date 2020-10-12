{{/* CONFIGURATION - YOUR_CC_ID */}}
{{$publishEventCustomCommandID := 31}}

{{/* Handles adding class to event joining */}}
{{$aID := .ReactionMessage.Author.ID }}
{{$eventClassMsg := dbGet 5012 (joinStr "_" .ReactionMessage.ID .User.ID)}}
{{if and (eq $aID 204255221017214977) (gt (len (str $eventClassMsg.Value)) 0)}} {{/* YAGPDB ID */}}
    {{$key := split $eventClassMsg.Key "_"}}
    {{$value := split $eventClassMsg.Value "_"}}
    {{$roleName := index $value 0}}
    {{$eventID := (dbGet 5011 (index $value 1)).Value}}
    {{$creatorID := (dbGet 4999 $eventID).Value}}

    {{$participantList := (dbGet 5010 $eventID).Value}}
    {{$participantList = reReplace (joinStr "" "[a-z,A-Z,0-9]{1,}_" .User.ID "_[a-z,A-Z,0-9]{0,}") (str $participantList) (joinStr "_" $roleName .User.ID .Reaction.Emoji.Name) }}

    {{dbSet 5010 $eventID $participantList}}
    {{execCC $publishEventCustomCommandID nil 0 (sdict "creatorID" $creatorID "eventID" $eventID)}}
    {{deleteMessage nil .ReactionMessage.ID 0}}
{{end}}