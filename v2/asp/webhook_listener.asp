<%
 ' API Version: 2.0 - ASP
 ' This is an example of a webhook listener that you would place on your server.
 ' After you set it up go to: https://www.smartwaiver.com/m/rest/?webhooks and set your Webhook URL to: https://www.YOURDOMAIN.com/webhook_listener.php or whatever you titled this script.

'YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
%>
<!--#include file='config.asp'-->
<!--#include file="md5.asp"-->
<%

'make sure all required values are passed
If IsNull(Request("unique_id")) Then
Response.End
End If

If IsNull(Request("credential")) Then
Response.End
End If

If IsNull(Request("event")) Then
 Response.End
 End If

'for now you only want to support new-waiver events.  This was added so that we can add future web hooks without conflict.
If Request("event") <> "new-waiver" Then
Response.End
 End If

'check that the credential is correct
If Request("credential") <> md5(API_KEY & Request("unique_id")) Then
 Response.End
 End If

'determine API URL
URL = "https://www.smartwaiver.com/api/" & API_VERSION & "/?rest_request=" & API_KEY & "&rest_waiverid=" & Server.URLEncode(Request("unique_id"))

Set api_result = Server.CreateObject("MSXML2.ServerXMLHTTP")
api_result.open "GET", URL, false
api_result.setRequestHeader "Content-Type", "text/xml; charset=utf-8" 
api_result.Send ""

Set participants = api_result.responseXML.getElementsByTagName("participants")

'DO YOU HAVE ANY WAIVERS?
if participants(0).getElementsByTagName("participant").length < 1 Then
    Response.End 'if you don't have any waivers it'll fail here
End If

For Each participant in participants(0).getElementsByTagName("participant")
    'the next 3 lines are just examples of how to obtain each participant's information.  For a full list of values please go to: https://www.smartwaiver.com/p/API
    waiver_id = participant.getElementsByTagName("waiver_id")(0).childNodes(0).nodeValue
    firstname = participant.getElementsByTagName("firstname")(0).childNodes(0).nodeValue
    lastname = participant.getElementsByTagName("lastname")(0).childNodes(0).nodeValue

    'INSERT INTO DATABASE HERE
Next
%>