{{$args := parseArgs 1 "Syntax is: -ce-game-alias <game> <space seperated list of alias>"
    (carg "string" "game")
    (carg "string" "alias")
}}

{{$id := 4996}}
{{$gameID := 4990}}
{{$game := $args.Get 0}}
{{$aliasesToAdd := (slice .CmdArgs 1)}}
{{$key := $game}}

{{$gameExists := (dbGet $gameID $key)}}
{{$failedAccessMsg :=  (joinStr "" "A game with **NAME:** `" $game "` ___doesn't exist___ **or** you  ___cannot add/edit game aliases___.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}

{{if and (hasRoleID $organizerID) (gt (len (str $gameExists.ID)) 0)}}

    {{$currentAliases := dbGetPattern $id (joinStr "" $game "_%") 10 0}}
    {{range $currentAliases}}
        {{dbDel $id .Key}}
    {{end}}
    {{$rolesPretty := ""}}
    {{range $aliasesToAdd}}
        {{dbSet $id (joinStr "_" $game .) $game}}
        {{$rolesPretty = (joinStr " " $rolesPretty .)}}
    {{end}}
    {{dbSet $id $game $game}}

    {{sendDM (joinStr "" "\nGame Updated!\n\n**Game Name:**`" $game "`\n**Aliases:** " $rolesPretty )}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}