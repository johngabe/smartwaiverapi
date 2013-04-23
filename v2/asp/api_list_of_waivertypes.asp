<%
 ' API Version: 2.0 - ASP
 ' This is a basic API example will print the urls to all of your waiver types

'YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
%>
<!--#include file='config.asp'-->
<%
URL = "https://www.smartwaiver.com/api/" & API_VERSION & "/?rest_request=" & API_KEY & "&resetapi_listofwaivertypes"
Set api_result = Server.CreateObject("MSXML2.ServerXMLHTTP")
api_result.open "GET", URL, false
api_result.setRequestHeader "Content-Type", "text/xml; charset=utf-8" 
api_result.Send ""


count = 0

Set waivers = api_result.responseXML.getElementsByTagName("waivers")



for each waiver in waivers(0).getElementsByTagName("waiver")
        'print the title of your waiver
        Response.Write waiver.getElementsByTagName("title")(0).childNodes(0).nodeValue & ": "
        //determine the waiver's unique identifier
        guid = waiver.getElementsByTagName("guid")(0).childNodes(0).nodeValue
        'print links to both the web version & the kiosk version
        Response.Write "<a href='https://www.smartwaiver.com/w/$guid/web/'>web</a> | <a href='https://www.smartwaiver.com/w/$guid/kiosk/'>kiosk</a><br>"

        count = count + 1
Next

Response.Write "You have " & count & " waiver types."
%>