<%
 ' API Version: 2.0 - ASP
 ' This is a basic API example that will print your 10 most recent waiver's participant names
 
'YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
%>
<!--#include file='config.asp'-->
<%
URL = "https://www.smartwaiver.com/api/" & API_VERSION & "/?rest_request=" & API_KEY & "&rest_limit=10"
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
        'the next 2 lines are just examples of how to obtain each participant's information.  For a full list of values please go to: https://www.smartwaiver.com/p/API
        Response.Write participant.getElementsByTagName("waiver_id")(0).childNodes(0).nodeValue & ": " & participant.getElementsByTagName("firstname")(0).childNodes(0).nodeValue & " " & participant.getElementsByTagName("lastname")(0).childNodes(0).nodeValue & "<br />"
Next
%>