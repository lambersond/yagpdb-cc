{{$args := parseArgs 1 "Syntax is: -ce-role-delete <role>"
    (carg "string" "role")
}}

{{$id := 4991}}
{{$role := ($args.Get 0)}}
{{$key := (joinStr "" "role_" $role)}}

{{$roleExists := (dbGet $id $key)}}
{{$failedAccessMsg :=  (joinStr "" "A role with **NAME:** `" $role "` ___does not exist___ **or** you ___cannot delete " $role "___.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}

{{if hasRoleID $organizerID}}
    {{dbDel $id $key}}
    {{sendDM (joinStr "" "\nRole Deleted!\n\n**Role Name:** `" $role "`" )}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}