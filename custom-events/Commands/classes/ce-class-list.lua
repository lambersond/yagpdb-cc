{{$notes := dbGetPattern 4992 "%" 100 0}}
{{$classes := "**Class list for custom event game roles:**"}}

{{range $notes}}
    {{$className := .Key}}
    {{$classID := .Value }}
    {{$classes = (joinStr "" $classes "\n<:" $className ":" $classID "> **" $className "**" )}}
{{end}}

{{sendDM (joinStr "" $classes)}}
{{deleteTrigger 0}}