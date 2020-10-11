{{$args := parseArgs 2 "Syntax is: -ce-role-add <emoji_name> <role_emote_id>"
    (carg "string" "role")
    (carg "int" "emoteID")
}}

{{$id := 4991}}
{{$role := ($args.Get 0)}}
{{$emoteID := (toInt64 ($args.Get 1))}}
{{$key := (joinStr "" "role_" $role)}}

{{$roleExists := (dbGet $id $key)}}
{{$failedAccessMsg :=  (joinStr "" "A role with **NAME:** `" $role "` ___already exist___ **or** you  ___cannot add/edit roles___.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}

{{if hasRoleID $organizerID}}
    {{dbSet $id $key (joinStr "" $emoteID)}}
    {{$icon := ""}}
    {{if gt $emoteID 0}}
        {{$icon = (joinStr "" "<:" $role ":" $emoteID ">")}}{{end}}
    {{sendDM (joinStr "" "\nRole Updated!\n\n**Role Name:**`" $role "`\n**emoteID:** " $emoteID "\n" $icon )}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}