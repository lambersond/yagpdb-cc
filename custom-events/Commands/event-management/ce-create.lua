{{$args := parseArgs 0 "Syntax is: -create-event <channel to create event in>"
    (carg "channel" "channel")
}}

{{$channelID := .Message.ChannelID}}

{{ if $args.IsSet 0}}
    {{$channelID = ($args.Get 0).ID}}
{{end}}

{{.User.Mention}}, you have begun the creation process for a new event in here, <#{{$channelID}}>! I have messaged you some important information.

{{$fields := cslice (sdict "name" "**ce-delete**" "value" (joinStr "" "Required Args (**1**) EventID. Remove all instances of the event from the database. Ex. `-ce-delete " .Message.ID "`") "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-publish**" "value" (joinStr "" "Required Args (**1**) EventID. Posts the event message. Ex. `-ce-publish " .Message.ID "`") "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-title**" "value" (joinStr "" "Required Args (**2**) EventID & title. **Title** can be wrapped in quotes or not. Ex. `-ce-title " .Message.ID " My far out title!`") "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-description**" "value" (joinStr "" "Required Args (**2**) EventID & description. **Description** can be wrapped in quotes or not. Supports Markdown. Ex. `-ce-description " .Message.ID " This event will be out of this galaxy!`") "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-max**" "value" (joinStr "" "Required Args (**2**) EventID & max. **Max** is an whole number greater than 0. Puts a limit of attendees on event. The event will hold more participants, but will only show up to the max. Default: no limit (0). Ex. `-ce-max " .Message.ID " 5`") "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-date**" "value" (joinStr "" "Required Args (**2**) EventID & date. _**Date** is required to publish event_. It is in a `dd-MMM-YYYY` format.  Ex. `-ce-date " .Message.ID " 01-JAN-2025`") "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-time**" "value" (joinStr "" "Required Args (**2**) EventID & time. _**Time** is a  24h `hh:mm` format. The timezone link also defaults to GMT-4.  Ex. `-ce-delete " .Message.ID " 17:30`") "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-game**" "value" "Required Args (**2**) EventID & game. **Game** is the game or system the event gets it's roles and classes from. To see a list of avaiable games on your server run `-ce-game-list`" "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-help**" "value" "Help documentation. Ex. `-ce-help`" "inline" false)}}

{{ $embed := cembed
    "title" (joinStr "" .User.Username ", you've created a new custom event!\n")
    "description" (joinStr "" "The **eventID** for this event is `" .Message.ID "`")
    "timestamp" currentTime
    "fields"  $fields
}}

{{dbSet 4999 .Message.ID (joinStr "" .User.ID)}}
{{dbSet 5000 (joinStr "_" .Message.ID .User.ID) (joinStr "" $channelID)}}
{{dbSet 5002 (joinStr "_" .Message.ID .User.ID) (joinStr "" "Custom Event!")}}
{{dbSet 5003 (joinStr "_" .Message.ID .User.ID) ""}}
{{dbSet 5004 (joinStr "_" .Message.ID .User.ID) 0}}
{{dbSet 5006 (joinStr "_" .Message.ID .User.ID) "dd-MMM-YYYY"}}
{{dbSet 5007 (joinStr "_" .Message.ID .User.ID) "00:00"}}
{{dbSet 5008 (joinStr "_" .Message.ID .User.ID) (cslice "Yes" "No")}}
{{dbSet 5009 (joinStr "_" .Message.ID .User.ID) "default"}}

{{sendDM (cembed $embed)}}
{{deleteTrigger 0}}
{{deleteResponse 60}}