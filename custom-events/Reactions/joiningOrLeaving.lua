{{/* CONFIGURATION - YOUR_CC_ID */}}
{{$publishEventCustomCommandID := 31}}

{{/* Handles joining or leaving an event */}}
{{$reaction := .Reaction}}
{{$reactionMessage := .ReactionMessage}}
{{$publishedEvent := (dbGet 5011 $reactionMessage.ID)}}

{{/* If event has been published and user not YAGPDB */}}
{{if and (gt (len (str $publishedEvent.ID)) 0) (not (eq .User.ID 204255221017214977))}}
    {{$msgID := $publishedEvent.Key}}
    {{$eventID := $publishedEvent.Value}}
    {{$creatorID := (dbGet 4999 $eventID).Value}}
    {{$channelID := $reaction.ChannelID}}
    {{$attendeeID := .User.ID}}
    {{$allowedRolesForEvent := (dbGet 5008 (joinStr "_" $eventID $creatorID "roles")).Value}}

    {{if not (inFold $allowedRolesForEvent $reaction.Emoji.Name)}}
        {{deleteMessageReaction nil $msgID $attendeeID (joinStr ":" $reaction.Emoji.Name $reaction.Emoji.ID)}}
    {{else}}
        {{$publish := "true"}}

        {{$participantList := (str (dbGet 5010 $eventID).Value)}}
        {{$participant := reFind (joinStr "" "[a-z,A-Z,0-9]{1,}_" .User.ID "_[a-z,A-Z,0-9]{0,}") $participantList}}

        {{if .ReactionAdded }}
            {{if eq (len $participant) 0 }}
                {{$newParticipant := (joinStr "_" $reaction.Emoji.Name .User.ID "")}}
                {{$participantList = (joinStr " " $participantList $newParticipant)}}
            {{else}}
                {{/* Delete old role emoji and update participant list for new role */}}
                {{$oldRole := index (split $participant "_") 0}}
                {{$oldRoleID :=  (dbGet 4991 (joinStr "_" "role" $oldRole)).Value}}
                {{deleteMessageReaction nil $msgID $attendeeID (joinStr ":" $oldRole $oldRoleID)}}
                {{$participantList = reReplace $participant $participantList (joinStr "_" $reaction.Emoji.Name .User.ID "")}}

                {{/* Check if game role has classes assigned */}}
                {{$gameName := (dbGet 5009 (joinStr "_" $msgID $creatorID "game")).Value}}
                {{$classRoles := cslice}}
                {{$classes := dbGet 4991 (joinStr "_" $gameName $reaction.Emoji.Name)}}
                {{if gt (len (str $classes.ID)) 0}}
                    {{$classRoles = $classes.Value}}
                {{end}}

                {{/* Send message to get attendees class */}}
                {{if gt (len $classRoles) 0}}
                    {{$publish = false}}
                    
                    {{/* Build message for class request */}}
                    {{$description := (joinStr "" "Choose one of the following classes that fit the " $reaction.Emoji.Name " role.\n\n")}}
                    {{range $classRoles}}
                        {{$class := dbGet 4992 (joinStr "_" "class" .)}}
                        {{$classDetails := (dbGet 4993 $class.Value).Value}}
                        {{$classDescription := (reReplace $class.Key (str $classDetails) "")}}
                        {{$description = (joinStr "" $description "<:" . ":" $class.Value "> | " $classDescription "\n")}}
                    {{end}}
                    {{ $embed := cembed
                        "title" (joinStr "`" "Choose a class to play for role, " $reaction.Emoji.Name " with the game: " $gameName ".")
                        "description" (joinStr "" "**Info:**" $description)
                        "timestamp" currentTime
                        "author" (sdict "name" (joinStr "" .User.Username "#" .User.Discriminator) "url" "" "icon_url" (.User.AvatarURL "512"))
                    }}

                    {{/* Remove old request from db */}}
                    {{$userClassRequests := dbGetPattern 5012 (joinStr "_" "%" .User.ID) 10 0}}
                    {{range $userClassRequests}}
                        {{$id := index (split .Key "_") 0}}
                        {{if gt (toInt64 $id) 0}} 
                            {{deleteMessage nil $id 0}}
                            {{dbDelByID 5012 .ID}}
                        {{end}}
                    {{end}}

                    {{/* Send message and add classes as reactions */}}
                    {{$classMsgID := sendMessageNoEscapeRetID nil $embed}}
                    {{range $classRoles}}
                        {{ $classID := (dbGet 4992 (joinStr "_" "class" .)).Value }}
                        {{addMessageReactions nil $classMsgID (joinStr ":" . $classID )}}
                    {{end}}

                    {{dbSetExpire 5012 (joinStr "_" $classMsgID .User.ID) (joinStr "_" $reaction.Emoji.Name $msgID) 3600}}
                    {{deleteMessage nil $classMsgID 3600}}
                {{end}}
            {{end}}
        {{else}}
            {{deleteMessageReaction nil $msgID $attendeeID (joinStr ":" $reaction.Emoji.Name $reaction.Emoji.ID)}}

            {{if gt (len (reFindAll $reaction.Emoji.Name $participant)) 0}}
                {{$participantList = reReplace $participant $participantList ""}}
            {{else}}
                {{$publish = "false"}}
            {{end}}
        {{end}}
        {{dbSet 5010 $eventID (reReplace " $" (reReplace " {2,}" $participantList " ") "")}}
        {{if eq $publish "true"}}
            {{execCC $publishEventCustomCommandID nil 0 (sdict "creatorID" $creatorID "eventID" $eventID)}}
        {{end}}
    {{end}}
{{end}}