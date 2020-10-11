{{$notes := dbGetPattern 4992 "class_%" 100 0}}
{{$classes := "**Class list for custom event game roles:**"}}

{{range $notes}}
    {{$className := slice .Key 6 (len .Key)}}
    {{$classID := .Value }}
    {{$classes = (joinStr "" $classes "\n<:" $className ":" $classID "> **" (upper $className) "**" )}}
{{end}}

{{sendDM (joinStr "" $classes)}}
{{deleteTrigger 0}}