{{$args := parseArgs 1 "Syntax is: -ce-game-delete <game>"
    (carg "string" "game")
}}

{{$gameID := 4990}}
{{$game := ($args.Get 0)}}
{{$key := $game}}

{{$gameExists := (dbGet $gameID $key)}}
{{$failedAccessMsg :=  (joinStr "" "A game with **NAME:** `" $game "` ___does not exist___ **or** you ___cannot delete " $game "___.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}

{{if and (hasRoleID $organizerID) (not (eq $game "default"))}}
    {{dbDel $gameID $key}}
    {{sendDM (joinStr "" "\nGame Deleted!\n\n**Game Name:** `" $game "`" )}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}