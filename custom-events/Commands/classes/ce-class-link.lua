{{$args := parseArgs 2 "Syntax is: -ce-class-link <game> <role> <class(es)>"
    (carg "string" "game")
    (carg "string" "role")
    (carg "string" "classes")
}}

{{$game := $args.Get 0}}
{{$role := $args.Get 1}}
{{$classesToAdd := (slice .CmdArgs 2)}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}
{{$link := "true"}}
{{$errors := ""}}
{{$gameID := 4990}}
{{$roleID := 4991}}
{{$classID := 4992}}
{{$linkGameRoleToClassID := 4995}}

{{$availableClassesDB := dbGetPattern $classID "%" 100 0}}
{{$availableClasses := ""}}
{{range $availableClassesDB}}
    {{$availableClasses = (joinStr " " $availableClasses .Key)}}
{{end}}
{{$availableClasses := split $availableClasses " "}}
{{$classesToAddPretty := ""}}
{{range $classesToAdd}}
    {{$classesToAddPretty = (joinStr ", " $classesToAddPretty .)}}
{{end}}

{{range $classesToAdd}}
    {{if not (inFold $availableClasses .)}}
        {{$link = "false"}}
        {{sendDM (joinStr "" "The passed class: `" . "` is not a valid class!")}}
    {{end}}
{{end}}

{{$roleExists := dbGet $roleID $role}}
{{if eq (len (str $roleExists.ID)) 0}}
    {{$link = "false"}}
    {{$errors = (joinStr "" $errors "\nRole `" $role "` not found.")}}
{{end}}

{{$gameExists := dbGet $gameID $game}}
{{if eq (len (str $gameExists.ID)) 0}}
    {{$link = "false"}}
    {{$errors = (joinStr "" $errors "\nGame `" $game "` not found.")}}
{{end}}

{{if not (hasRoleID $organizerID)}}
    {{$link = "false"}}
    {{$errors = (joinStr "" $errors "\nPermission Denied.")}}
{{end}}

{{if eq $link "true"}}
    {{dbSet $linkGameRoleToClassID (joinStr "_" $game $role) $classesToAdd}}
    {{sendDM (joinStr "" "\nClasses linked to the role `" $role "` for the game: `" $game "`\nClasses added: `" $classesToAddPretty "`")}}
{{else}}
    {{sendDM $errors}}
{{end}}

{{deleteTrigger 0}}
{{deleteResponse 0}}