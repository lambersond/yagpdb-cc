{{$args := parseArgs 1 "Syntax is: ce-info <eventID>"
    (carg "int" "event Id")
}}

{{$mID := (toInt64  ($args.Get 0))}}
{{$uID := .User.ID}}

**Event Channel ID:** {{(dbGet 5000 (joinStr "_" $mID $uID)).Value}}
**Published Event Message ID:** {{(dbGet 5001 (joinStr "_" $mID $uID)).Value}}
**Title:** {{(dbGet 5002 (joinStr "_" $mID $uID)).Value}}
**Description:** {{(dbGet 5003 (joinStr "_" $mID $uID)).Value}}
**Max Participants:** {{(dbGet 5004 (joinStr "_" $mID $uID)).Value}}
**Participant List:** {{(dbGet 5010 (str $mID)).Value}}
**Date:** {{(dbGet 5006 (joinStr "_" $mID $uID)).Value}}
**Time:** {{(dbGet 5007 (joinStr "_" $mID $uID)).Value}}
**Game:** {{(dbGet 5009 (joinStr "_" $mID $uID)).Value}}
**Game Roles:** {{(dbGet 5008 (joinStr "_" $mID $uID)).Value}}

{{deleteTrigger 0}}