{{$notes := dbGetPattern 4990 "%" 100 0}}
{{$games := ""}}
{{range $notes}}
    {{$game := .Key}}
    {{$games = (joinStr "" $games "\n" $game)}}
{{end}}
{{sendDM (joinStr "" "\n**Available Event games:**\n```" $games "\n```")}}
{{deleteTrigger 0}}