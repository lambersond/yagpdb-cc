{{/* CONFIGURATION - YOUR_CC_ID */}}
{{$publishEventCustomCommandID := 31}}

{{$args := parseArgs 2 "Syntax is: -ce-date <eventID> <dd-MMM-YYYY>"
    (carg "string" "event Id")
    (carg "string" "content")
}}

{{$id := 5006}}
{{$eventID := $args.Get 0}}
{{$ownerID := .User.ID}}
{{$key := (joinStr "_" $eventID $ownerID)}}

{{$raw := ($args.Get 1)}}
{{$raw_split := (split $raw "-")}}
{{$day := index $raw_split 0}}
{{$month := index $raw_split 1}}
{{$year := index $raw_split 2}}
{{$allowedMonths := (cslice "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")}}
{{$allowedYears := (cslice "2020" "2021" "2022" "2023" "2024" "2025" "2026" "2027" "2028" "2029" "2030")}} {{/* only a decade because this should be obsolete by that point */}}
{{$allowedDays := 0}}
{{$failedAccessMsg := (joinStr "" "An event with **ID:** `" $eventID "` ___does not exist___ **or** you  ___do not have access__ to it.")}}

{{if and (inFold $allowedMonths $month) (inFold $allowedYears $year)}}
    {{if (inFold (cslice "Jan" "Mar" "May" "Jul" "Aug" "Oct" "Dec") $month)}}
        {{$allowedDays = 31}}
    {{else if (inFold (cslice "Feb") $month)}}
        {{if (inFold (cslice "2020" "2024" "2028") $year)}}
            {{$allowedDays = 29}}
        {{else}}
            {{$allowedDays = 28}}
        {{end}}		
    {{else}}
        {{$allowedDays = 30}}
    {{end}}

    {{$day := (toInt $day)}}

    {{if and  (le $day $allowedDays) (ge $day 1)}}
        {{$eventExists := (dbGet 4999 $eventID)}}
        {{$failedAccessMsg :=  (joinStr "" "An event with **ID:** `" $eventID "` ___does not exist___ **or** you  ___do not have access___ to it.")}}
        {{$organizerID := (toInt64 (dbGet 4999 "organizerID").Value)}}
        {{$content := (joinStr "-" $day (title $month) $year)}}
        {{$hasCorrectPerms := "false"}}

        {{if or (eq (toInt64 $eventExists.Value) $ownerID) (hasRoleID $organizerID)}}
            {{$hasCorrectPerms = "allowed"}}
            {{$ownerID = $eventExists.Value}}
        {{end}}

        {{if and (not (eq (toInt64 $eventExists.Value) 0)) (eq $hasCorrectPerms "allowed")}}
            {{dbSet $id $key $content}}
            {{sendDM (joinStr "" "\nEvent Updated!\n\n**EventID:**`" $eventExists.Value "`\n**Date:**\n```" $content "\n```")}}

            {{$publishedEvent := dbGet 5001 (joinStr "_" $eventID $ownerID)}}
            {{if gt (len (str $publishedEvent.ID)) 0}}
                {{execCC $publishEventCustomCommandID nil 0 (sdict "creatorID" $ownerID "eventID" $eventID )}}
            {{end}}
        {{else}}
            {{sendDM $failedAccessMsg}}
        {{end}}

    {{else}}
        {{sendDM (joinStr "" "**Invalid day** -- must be `greater than 0` and `less than or equal to " $allowedDays "` for " $month " " $year)}}
    {{end}}
{{else}}
    {{sendDM "**Invalid month and/or year** -- proper format is `dd-MMM-YYYY` (max year is 2030)"}}
{{end}}

{{deleteTrigger 0}}