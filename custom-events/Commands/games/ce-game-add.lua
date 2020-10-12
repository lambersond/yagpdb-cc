{{$args := parseArgs 1 "Syntax is: -ce-game-add <game> <icon_url>"
    (carg "string" "game")
    (carg "string" "url")
}}

{{$gameID := 4990}}
{{$game := ($args.Get 0)}}
{{$url := ($args.Get 1)}}
{{$key := $game}}

{{$gameExists := (dbGet $gameID $key)}}
{{$failedAccessMsg :=  (joinStr "" "A game with **NAME:** `" $game "` ___already exist___ **or** you  ___cannot add/edit games___.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}

{{if hasRoleID $organizerID}}
    {{dbSet $gameID $key $url}}
    {{sendDM (joinStr "" "\nGame Updated!\n\n**Game Name:**`" $game "`\n**iconURL:** " $url )}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}