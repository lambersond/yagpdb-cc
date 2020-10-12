{{$args := parseArgs 1 "Syntax is: -ce-class-delete <class>"
    (carg "string" "class")
}}
{{$classID := 4992}}
{{$class := ($args.Get 0)}}
{{$key := $class}}

{{$classExists := (dbGet $classID $key)}}
{{$failedAccessMsg :=  (joinStr "" "A class with **NAME:** `" $class "` ___does not exist___ **or** you ___cannot delete " $class "___.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}

{{if hasRoleID $organizerID}}
    {{dbDel $classID $key}}
    {{sendDM (joinStr "" "\nClass Deleted!\n\n**Class Name:** `" $class "`" )}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}