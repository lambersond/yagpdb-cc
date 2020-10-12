This suit of commands is similar to the already existing event function available within YAGBDB, however it adds the ability to add games, roles to games, and classes to those roles.

This is a WIP
---
There are plenty of bugs and places to improve this code. I will be working when available to improve and patch. Feel free to contribute.

Database 
----

* EventID = Message.ID of message that executed `-ce-create`
* OwnerID = User.ID of message that executed `-ce-create`
* MessageID = Message.ID of published event message


|ID|KEY FORMAT|VALUE|NOTES|
|---|---|---||
|4990|"game_name"|Available Game||
|4991|"role_name"|Available Roles||
|4992|"class_name"|Available Classes||
|4999|"EventID"|OwnerID|All events|
|5000|"EventID_OwnerID"|ChannelID|channel to publish event|
|5001|"EventID_OwnerID"|MessageID|messageID of publushed event|
|5002|"EventID_OwnerID"|Title|Title of event|
|5003|"EventID_OwnerID"|Description|Description of event|
|5004|"EventID_OwnerID"|Max|Max number of participants for event--default:Indef|
|5005|"EventID_OwnerID"|Participant Count |Number of participants|
|5006|"EventID_OwnerID"|Date|Date of event DD-MMM-YYYY|
|5007|"EventID_OwnerID"|Time|Time in 24h format|
|5008|"EventID_OwnerID"|Roles|Auto determined by 5009|
|5009|"EventID_OwnerID"|Game|game for event--default:default|
|5010|"EventID"|ParticipantList|List of all participants with their role and class|
|5011|"MessageID"|EventID|Used to manage joining/leaving event|
|5012|"ClassMessageID_ParticipantID"|ClassName_ClassMessageID|Used if there are classes to choose from--TTL 10m|


TODO
----

* [ ]  Lock down setting the organizer role so that anybody cannot just change it.
* [ ]  When adding games to events it should not be case sensitive
* [ ]  date & time should be required to publish event
* [ ]  event-properties need to handle ExecData
* [ ]  add a quick create