{{$args := parseArgs 0 "Syntax is: -create-event <channel to create event in>"
    (carg "channel" "channel")
}}

{{$helpNotes := "\n\n**EVENT CREATION COMMANDS:**\n\n*___Title:___* `-event-title <eventID> <text>`  ---> `-event-title 1234567890 Event title for awesome event`\n\n*___Description:___* `-event-description <eventID> <text>`  ---> `-event-description 1234567890 description for event. can include markdown and stuff`\n\n*___Max Participants (default indefinite):___* `-event-max <eventID> <int>`  ---> `-event-max 1234567890 10`\n\n*___Date:___* `-event-date <eventID> <dd-MMM-YYYY>`  ---> `-event-date 1234567890 25-dec-2020`\n\n*___Time (24h):___* `-event-time <eventID> <hh:mm>`  ---> `-event-time 1234567890 20:30`\n\n*___Game:___* `-event-game <eventID> <game>`  ---> `-event-game 1234567890 neverwinter`\n\n*___Channel (if it needs changed):___* `-event-channel <eventID> <channel>`  ---> `-event-channel 1234567890 #channel-name-new`"}}
{{$addNotes := "\n\n\n**When you're ready to post event,** `-publish-event 1234567890`\n\nIf a one of the following fields needs updated after event is published. Update the field and run the publish command again.\n\n\n\n"}}

{{$channelID := .Message.ChannelID}}

{{ if $args.IsSet 0}}
    {{$channelID = ($args.Get 0).ID}}
{{end}}

{{.User.Mention}}, you have begun the creation process for a new event in here, <#{{$channelID}}>! I have messaged you some important information.
{{sendDM (joinStr "" "\nYour event ID is `" .Message.ID "` do not lose this! It is needed to configure the event!\n\nThe event will be posted in: <#" $channelID ">" $helpNotes $addNotes )}}

{{dbSet 4999 .Message.ID (joinStr "" .User.ID)}}
{{dbSet 5000 (joinStr "_" .Message.ID .User.ID) (joinStr "" $channelID)}}
{{dbSet 5002 (joinStr "_" .Message.ID .User.ID) (joinStr "" "Custom Event!")}}
{{dbSet 5003 (joinStr "_" .Message.ID .User.ID) ""}}
{{dbSet 5004 (joinStr "_" .Message.ID .User.ID) 0}}
{{dbSet 5006 (joinStr "_" .Message.ID .User.ID) "dd-MMM-YYYY"}}
{{dbSet 5007 (joinStr "_" .Message.ID .User.ID) "00:00"}}
{{dbSet 5008 (joinStr "_" .Message.ID .User.ID) (cslice "Yes" "No")}}
{{dbSet 5009 (joinStr "_" .Message.ID .User.ID) "default"}}

{{deleteTrigger 0}}
{{deleteResponse 60}}