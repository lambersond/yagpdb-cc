{{/* CONFIGURATION - YOUR_CC_ID */}}
{{$publishEventCustomCommandID := 31}}

{{/* Handles adding class to event joining */}}
{{$aID :=  .ReactionMessage.Author.ID }}
{{$eventClassMsg := dbGet 5012 (joinStr "_" .ReactionMessage.ID .User.ID)}}
{{if and (eq $aID 204255221017214977) (gt (len (str $eventClassMsg.Value)) 0)}} {{/* YAGPDB ID */}}
    {{$key := split $eventClassMsg.Key "_"}}
    {{$value := split $eventClassMsg.Value "_"}}
    {{$roleName := index $value 0}}
    {{$eventID := index $value 1}}
    {{$eventOwner := (dbGet 4999 $eventID).Value}}

    {{$participantList := (dbGet 5010 $eventID).Value}}
    {{$classID := (dbGet 4992 (joinStr "_" "class" .Reaction.Emoji.Name)).Value}}
    {{$classDetails := dbGet 4993 .Reaction.Emoji.ID}}
    {{$className := reReplace " .*" (reReplace "class_" $classDetails.Value "") ""}}
    {{ index (split " " $classDetails.Value) 0}}
    {{$participantList = reReplace (joinStr "" "[a-z,A-Z,0-9]{1,}_" .User.ID "_[a-z,A-Z,0-9]{0,}") $participantList (joinStr "_" $roleName .User.ID $className) }}

    {{dbSet 5010 $eventID $participantList}}
    {{execCC $publishEventCustomCommandID nil 0 (sdict "creatorID" $eventOwner "eventID" $eventID)}}
    {{deleteMessage nil .ReactionMessage.ID 0}}
{{end}}