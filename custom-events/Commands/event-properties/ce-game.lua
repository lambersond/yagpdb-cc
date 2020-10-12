{{/* CONFIGURATION - YOUR_CC_ID */}}
{{$publishEventCustomCommandID := 31}}

{{$args := parseArgs 2 "Syntax is: -ce-game <eventID> <game>"
    (carg "string" "event Id")
    (carg "string" "game")
}}

{{$id := 5009}}
{{$eventID := $args.Get 0}}
{{$ownerID := .User.ID}}
{{$aliasID := 4996}}
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
    {{$game := (index (dbGetPattern $aliasID (joinStr "" "%" $content) 1 0) 0).Value}}
    {{$gameExists := dbGet 4990 $game}}
    {{$gameRoles := dbGet 4994 $game}}

    {{if gt (len (str $gameExists.ID)) 0}}
        {{dbSet $id $key $game}}
        {{$publishedEvent := dbGet 5001 (joinStr "_" $eventID $ownerID)}}

        {{if gt (len (str $publishedEvent.ID)) 0}}
            {{$publishedChannel := dbGet 5000 (joinStr "_" $eventID $ownerID)}}
            {{deleteAllMessageReactions $publishedChannel.Value $publishedEvent.Value}}
            {{dbDel 5010 $eventID}}
            {{dbSet (sub $id 1) (joinStr "_" $eventID $ownerID) $gameRoles.Value}}

            {{execCC $publishEventCustomCommandID nil 0 (sdict "creatorID" $ownerID "eventID" $eventID )}}
        {{end}}
        {{sendDM (joinStr "" "\nEvent Updated!\n\n**EventID:**`" $eventID "`\n**Game:**\n```" $content " [" $game "]\n```")}}
    {{else}}
        {{sendDM (joinStr "" "Game type " $content " [" $game "] does not exist. See all available games with `-ce-game-list`")}}
    {{end}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}