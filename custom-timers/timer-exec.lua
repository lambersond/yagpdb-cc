{{$timeUntil := .ExecData.T.Sub currentTime}}
{{$formattedTimeUntil := humanizeDurationSeconds $timeUntil}}
{{$timeLeft := .ExecData.D.Sub currentTime}}
{{$formattedTimeLeft := humanizeDurationSeconds $timeLeft}}

{{$t := .ExecData.T}}
{{$d := .ExecData.D}}
{{$mID := .ExecData.MessageID}}
{{$ts := .TimeSecond}}

{{$username := .ExecData.Username}}
{{$avatar := .ExecData.Avatar}}
{{$title := .ExecData.Title}}
{{$description := .ExecData.Description}}
{{$url := .ExecData.url}}
{{$color := .ExecData.color}}
{{$thumbnail := .ExecData.thumbnail}}

{{if gt $timeUntil 0}}
  {{if lt $timeUntil (mult .TimeSecond 30)}}
    {{range seq 1 (toInt $timeUntil.Seconds)}}
      {{$timeUntil := $t.Sub currentTime}}
      {{$formattedTimeUntil := humanizeDurationSeconds $timeUntil}}
      {{$embed := cembed
        "title" $title
        "description" $description
        "color" $color
        "author" (sdict "name" $username "icon_url" $avatar)
        "fields" (cslice (sdict "name" "Time Until:" "value" $formattedTimeUntil "inline" false))
        "thumbnail" (sdict "url" $thumbnail)
        "image" (sdict "url" $url)
        "timestamp" $t
      }}
      {{editMessageNoEscape nil $mID (complexMessageEdit "embed" $embed)}}
      {{if gt $timeUntil $ts}} {{sleep 1}} {{end}}
    {{end}}
    {{if gt (sub $timeLeft $timeUntil) 1}}
      {{execCC .CCID nil 10 .ExecData}}
    {{else}}
      {{$embed := cembed
        "title" $title
        "description" $description
        "color" $color
        "author" (sdict "name" $username "icon_url" $avatar)
        "fields" (cslice (sdict "name" "Time Until:" "value" "**ENDED**" "inline" false))
        "image" (sdict "url" $url)
        "thumbnail" (sdict "url" $thumbnail)
        "timestamp" $t
      }}
      {{editMessageNoEscape nil $mID (complexMessageEdit "embed" $embed)}}
    {{end}}
  {{else}}
    {{$embed := cembed
      "title" $title
      "description" $description
      "color" $color
      "author" (sdict "name" $username "icon_url" $avatar)
      "fields" (cslice (sdict "name" "Time Until:" "value" $formattedTimeUntil "inline" false))
      "image" (sdict "url" $url)
      "thumbnail" (sdict "url" $thumbnail)
      "timestamp" $t
    }}
    {{editMessageNoEscape nil $mID (complexMessageEdit "embed" $embed)}}
    {{execCC .CCID nil 10 .ExecData}}
  {{end}}
{{else}}
  {{if gt $timeLeft 0}}
    {{if lt $timeLeft (mult .TimeSecond 30)}}
      {{range seq 1 (toInt $timeLeft.Seconds)}}
        {{$timeLeft := $d.Sub currentTime}}
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
        "timestamp" $d
      }}
      {{editMessageNoEscape nil $mID (complexMessageEdit "embed" $embed)}}
      {{execCC .CCID nil 10 .ExecData}}
    {{end}}
  {{end}}
{{end}}
