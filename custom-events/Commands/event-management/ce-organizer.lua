{{$args := parseArgs 1 "role ID"
    (carg "int" "roleID")
}}

{{if (hasRoleID (toInt64 .CmdArgs))}}
    {{dbSet 4999 "organizerID" (str (toInt64 .CmdArgs))}}
    {{sendDM (joinStr "" "<@&" (toInt64 .CmdArgs) "> is now the role that can manage events" )}}

{{else}}
    {{sendDM "You do not have correct role to update custom event organizer role"}}
{{end}}

{{deleteTrigger 0}}