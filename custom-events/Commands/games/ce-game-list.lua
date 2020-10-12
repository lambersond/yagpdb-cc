{{$notes := dbGetPattern 4990 "%" 100 0}}
{{$games := ""}}
{{range $notes}}
    {{$game := .Key}}
    {{$games = (joinStr "" $games "\n" $game)}}
    {{$aliasesPretty := ""}}

    {{$aliases := dbGetPattern 4996 (joinStr "" $game "_%") 100 0}}
    {{range $aliases}}
        {{$alias := (reReplace (joinStr "" $game "_") .Key "")}}
        {{$aliasesPretty = (joinStr ", " $aliasesPretty $alias)}}
    {{end}}

    {{if gt (len $aliasesPretty) 0}}
        {{$games = (joinStr "" $games " [" $aliasesPretty "]")}}
    {{end}}
{{end}}
{{sendDM (joinStr "" "\n**Available Event games:**\n```" $games "\n```")}}
{{deleteTrigger 0}}