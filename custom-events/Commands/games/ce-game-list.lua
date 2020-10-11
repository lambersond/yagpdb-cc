{{$notes := dbGetPattern 4990 "game_%" 100 0}}
{{$games := ""}}
{{range $notes}}
    {{$game := slice .Key 5 (len .Key)}}
    {{$games = (joinStr "" $games "\n" $game)}}
{{end}}
{{sendDM (joinStr "" "\n**Available Event games:**\n```" $games "\n```")}}
{{deleteTrigger 0}}