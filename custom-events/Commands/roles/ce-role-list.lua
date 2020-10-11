{{$notes := dbGetPattern 4991 "role_%" 100 0}}
{{$roles := ""}}
{{range $notes}}
    {{$role := slice .Key 5 (len .Key)}}
    {{$roles = (joinStr "" $roles "\n" $role)}}
{{end}}
{{sendDM (joinStr "" "\n**Available Event games:**\n```" $roles "\n```")}}
{{deleteTrigger 0}}