{{$timeLeft := .ExecData.T.Sub currentTime}}
{{$formattedTimeLeft := humanizeDurationSeconds $timeLeft}}

{{$t := .ExecData.T}}
{{$mID := .ExecData.MessageID}}
{{$ts := .TimeSecond}}

{{$username := .ExecData.Username}}
{{$avatar := .ExecData.Avatar}}
{{$title := .ExecData.Title}}
{{$description := .ExecData.Description}}
{{$url := .ExecData.url}}
{{$color := .ExecData.color}}
{{$thumbnail := .ExecData.thumbnail}}

{{if lt $timeLeft (mult .TimeSecond 30)}}
  {{range seq 1 (toInt $timeLeft.Seconds)}}
    {{$timeLeft := $t.Sub currentTime}}
    {{$formattedTimeLeft := humanizeDurationSeconds $timeLeft}}
    {{$embed := cembed
      "title" $title
      "description" $description
      "color" $color
      "author" (sdict "name" $username "icon_url" $avatar)
      "fields" (cslice (sdict "name" "Time left:" "value" $formattedTimeLeft "inline" false))
      "thumbnail" (sdict "url" $thumbnail)
      "image" (sdict "url" $url)
      "timestamp" $t
    }}
    {{editMessageNoEscape nil $mID (complexMessageEdit "embed" $embed)}}
    {{if gt $timeLeft $ts}} {{sleep 1}} {{end}}
  {{end}}
  {{$embed := cembed
    "title" $title
    "description" $description
    "color" $color
    "author" (sdict "name" $username "icon_url" $avatar)
    "fields" (cslice (sdict "name" "Time left:" "value" "**ENDED**" "inline" false))
    "image" (sdict "url" $url)
    "thumbnail" (sdict "url" $thumbnail)
    "timestamp" $t
  }}
  {{editMessageNoEscape nil $mID (complexMessageEdit "embed" $embed)}}
{{else}}
  {{$embed := cembed
    "title" $title
    "description" $description
    "color" $color
    "author" (sdict "name" $username "icon_url" $avatar)
    "fields" (cslice (sdict "name" "Time left:" "value" $formattedTimeLeft "inline" false))
    "image" (sdict "url" $url)
    "thumbnail" (sdict "url" $thumbnail)
    "timestamp" $t
  }}
  {{editMessageNoEscape nil $mID (complexMessageEdit "embed" $embed)}}
  {{execCC .CCID nil 10 .ExecData}}
{{end}}