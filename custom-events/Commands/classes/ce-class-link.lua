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

{{$availableClassesDB := dbGetPattern 4992 "class_%" 100 0}}
{{$availableClasses := ""}}
{{range $availableClassesDB}}
    {{$class := slice .Key 6 (len .Key)}}
    {{$availableClasses = (joinStr " " $availableClasses $class)}}
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

{{$roleExists := dbGet 4991 (joinStr "_" "role" $role)}}
{{if not (eq $roleExists.Key (joinStr "_" "role" $role))}}
    {{$link = "false"}}
    {{$errors = (joinStr "" $errors "\nRole `" $role "` not found.")}}
{{end}}

{{$gameExists := dbGet 4990 (joinStr "_" "game" $game)}}
{{if not (eq (joinStr "" $gameExists.Key) (joinStr "_" "game" $game))}}
    {{$link = "false"}}
    {{$errors = (joinStr "" $errors "\nGame `" $game "` not found.")}}
{{end}}

{{if not (hasRoleID $organizerID)}}
    {{$link = "false"}}
    {{$errors = (joinStr "" $errors "\nPermission Denied.")}}
{{end}}

{{if eq $link "true"}}
    {{dbSet 4991 (joinStr "_" $game $role) $classesToAdd}}
    {{sendDM (joinStr "" "\nClasses linked to the role `" $role "` for the game: `" $game "`\nClasses added: `" $classesToAddPretty "`")}}
{{else}}
    {{sendDM $errors}}
{{end}}

{{deleteTrigger 0}}
{{deleteResponse 0}}