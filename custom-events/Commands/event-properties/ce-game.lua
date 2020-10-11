{{$args := parseArgs 2 "Syntax is: -ce-game <eventID> <game>"
    (carg "string" "event Id")
    (carg "string" "game")
}}

{{$id := 5009}}
{{$key := (joinStr "_" ($args.Get 0) (.User.ID))}}

{{$content := (joinStr " " (slice .CmdArgs 1))}}
{{$eventExists := (dbGet 4999 ($args.Get 0))}}
{{$failedAccessMsg :=  (joinStr "" "An event with **ID:** `" ($args.Get 0) "` ___does not exist___ **or** you  ___do not have access___ to it.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}
{{$hasCorrectPerms := "false"}}

{{if or (eq (toInt64 $eventExists.Value) .User.ID) (hasRoleID $organizerID)}}
    {{$hasCorrectPerms = "allowed"}}
{{end}}

{{$gameExists := (dbGet 4990 (joinStr "" "game_" $content)).Key}}
{{$gameRoles := (dbGet 4990 $content )}}

{{if and (not (eq (toInt64 $eventExists.Value) 0)) (eq $hasCorrectPerms "allowed")}}
    {{ if eq (str $gameExists) (joinStr "" "game_" $content)}}
        {{dbSet $id $key $content}}
        {{if gt (len (str $gameRoles.ID)) 0}}
            {{dbSet (sub $id 1) (joinStr "" ($args.Get 0) "_" (.User.ID) "_roles") $gameRoles.Value}}
        {{end}}
        {{sendDM (joinStr "" "\nEvent Updated!\n\n**EventID:**`" $eventExists.Value "`\n**Game:**\n```" $content "\n```")}}
    {{else}}
        {{sendDM (joinStr "" "Game type " $content " does not exist. See all available games with `-ce-game-list`")}}
    {{end}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}