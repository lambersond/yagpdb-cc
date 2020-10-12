{{$fields := cslice (sdict "name" "**ce-create**" "value" "This command is used to create a new event. It can be passed the #channel-for-event or be left empty" "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-delete**" "value" "Required Args (**1**) EventID. Remove all instances of the event from the database" "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-publish**" "value" "Required Args (**1**) EventID. Posts the event message" "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-title**" "value" "Required Args (**2**) EventID & title. **Title** can be wrapped in quotes or not." "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-description**" "value" "Required Args (**2**) EventID & description. **Description** can be wrapped in quotes or not. Supports Markdown." "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-max**" "value" "Required Args (**2**) EventID & max. **Max** is an whole number greater than 0. Puts a limit of attendees on event. The event will hold more participants, but will only show up to the max. Default: no limit (0)." "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-date**" "value" "Required Args (**2**) EventID & date. _**Date** is required to publish event_. It is in a `dd-MMM-YYYY` format. Ex: `01-Jan-2025`" "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-time**" "value" "Required Args (**2**) EventID & time. _**Time** is a  24h `hh:mm` format. The timezone link also defaults to GMT-4. Ex: `15:30`" "inline" false)}}
{{$fields = $fields.Append (sdict "name" "**ce-game**" "value" "Required Args (**2**) EventID & game. **Game** is the game or system the event gets it's roles and classes from. To see a list of avaiable games on your server run `ce-game-list`" "inline" false)}}

{{ $embed := cembed
    "title" (joinStr "" "\n Custom Event Help Documentation \n")
    "description" (joinStr "" "**Info:** The suit of custom-event (ce) commands are to enable members to create events for specific games with specific roles and classes.")
    "timestamp" currentTime
    "fields"  $fields
}}

{{sendDM (cembed $embed)}}