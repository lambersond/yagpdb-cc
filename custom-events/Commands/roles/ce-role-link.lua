{{$args := parseArgs 2 "Syntax is: -ce-role-link <game> <role(s)>"
    (carg "string" "game")
    (carg "string" "roles")
}}
 
{{($game := $args.Get 0)}}
{{$rolesToAdd := (slice .CmdArgs 1)}}
{{$availableRolesDB := dbGetPattern 4991 "role_%" 100 0}}
{{$availableRoles := ""}}

{{range $availableRolesDB}}
    {{$role := slice .Key 5 (len .Key)}}
    {{$availableRoles = (joinStr " " $availableRoles $role)}}
{{end}}

{{$gameExists := dbGet 4990 (joinStr "" "game_" $game)}}
{{$link := "true"}}
{{$availableRoles := split $availableRoles " "}}
{{$rolesToAddPretty := ""}}

{{range $rolesToAdd}}
    {{$rolesToAddPretty = (joinStr ", " $rolesToAddPretty .)}}
{{end}}

{{if not (eq $gameExists.Key (joinStr "" "game_" $game))}}
    {{$link = "false"}}
{{end}}

{{range $rolesToAdd}}
    {{if not (inFold $availableRoles .)}}
        {{$link = "false"}}
        {{sendDM (joinStr "" "The passed role: `" . "` is not a valid role!")}}
    {{end}}
{{end}}

{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}

{{if and (eq $link "true") (hasRoleID $organizerID)}}
    {{dbSet 4990 $game $rolesToAdd}}
    {{sendDM (joinStr "" "\nRoles linked to the game `" $game "`\nRoles added: `" $rolesToAddPretty "`")}}
{{end}}

{{deleteResponse 0}}
{{deleteTrigger 0}}