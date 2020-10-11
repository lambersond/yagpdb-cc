{{$args := parseArgs 2 "Syntax is: -ce-class-add <emoji_name> <role_emote_id> <class description>"
    (carg "string" "class")
    (carg "int" "emoteID")
    (carg "string" "class description")
}}

{{$id := 4992}}
{{$class := ($args.Get 0)}}
{{$emoteID := (toInt64 ($args.Get 1))}}
{{$description := ($args.Get 2)}}
{{$key := (joinStr "_" "class" $class)}}

{{$classExists := (dbGet  4992 $key)}}
{{$failedAccessMsg :=  (joinStr "" "A class with **NAME:** `" $class "` ___already exist___ **or** you  ___cannot add/edit classes___.")}}
{{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}

{{if hasRoleID $organizerID}}
    {{dbSet 4992 $key (joinStr "" $emoteID)}}
    {{dbSet 4993 $emoteID (joinStr " " $key $description)}}
    {{$icon := ""}}
    {{if gt $emoteID 0}}
        {{$icon = (joinStr "" "<:" $class ":" $emoteID ">")}}{{end}}
    {{sendDM (joinStr "" "\nClass Updated!\n\n**Class Name:**`" $class "`\n**emoteID:** " $emoteID "\n" $icon )}}
{{else}}
    {{sendDM $failedAccessMsg}}
{{end}}

{{deleteTrigger 0}}