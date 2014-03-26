<%
' API Version: 3.0 - ASP
' This is a basic API example that will download your most recent waiver's PDF into a local directory


'YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
%>
<!--#include file='config.asp'-->
<%

function SaveFileFromUrl(Url, FileName)
    dim objXMLHTTP, objADOStream, objFSO

    Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP.3.0")

    objXMLHTTP.open "GET", Url, false
    objXMLHTTP.send()

    If objXMLHTTP.Status = 200 Then 
        Set objADOStream = CreateObject("ADODB.Stream")
        objADOStream.Open
        objADOStream.Type = 1 'adTypeBinary

        objADOStream.Write objXMLHTTP.ResponseBody
        objADOStream.Position = 0 'Set the stream position to the start

        Set objFSO = Createobject("Scripting.FileSystemObject")
        If objFSO.Fileexists(FileName) Then objFSO.DeleteFile FileName
        Set objFSO = Nothing

        objADOStream.SaveToFile FileName
        objADOStream.Close
        Set objADOStream = Nothing

        SaveFileFromUrl = objXMLHTTP.getResponseHeader("Content-Type")
    else
        SaveFileFromUrl = ""
    End if

    Set objXMLHTTP = Nothing
end function


'SET A WRITABLE DIRECTORY WHERE YOU WANT TO SAVE YOUR PDF
'IMPORTANT: Waivers should not be stored in directories that the public can access (or bots)!  Obviously waivers include private information and therefore should be in private directories.
writable_dir = "C:\bass24\"

'REQUEST THE MOST RECENT WAIVER
URL = "https://www.smartwaiver.com/api/" & API_VERSION & "/?rest_request=" & API_KEY & "&rest_limit=1"
Set api_result = Server.CreateObject("MSXML2.ServerXMLHTTP")
api_result.open "GET", URL, false
api_result.setRequestHeader "Content-Type", "text/xml; charset=utf-8" 
api_result.Send ""



Set participants = api_result.responseXML.getElementsByTagName("participants")


'DO YOU HAVE ANY WAIVERS?
if participants(0).getElementsByTagName("participant").length < 1 Then
    Response.End 'if you don't have any waivers it'll fail here
End If

'DOWNLOAD EACH WAIVER (You can bulk download up to 100 waivers at a time by modifying &rest_limit above to the desired # of participants)
For Each participant in participants(0).getElementsByTagName("participant")
   'create the download url
   download_url = "https://www.smartwaiver.com/api/" & API_VERSION & "/?rest_request=" & API_KEY & "&restapi_viewpdf=" & participant.getElementsByTagName("pdf_url")(0).childNodes(0).nodeValue
   
   'download it

    dim objXMLHTTP, objADOStream, objFSO

    Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP.3.0")

    objXMLHTTP.open "GET", download_url, false
    objXMLHTTP.send()

    If objXMLHTTP.Status = 200 Then 
        Set objADOStream = CreateObject("ADODB.Stream")
        objADOStream.Open
        objADOStream.Type = 1 'adTypeBinary

        objADOStream.Write objXMLHTTP.ResponseBody
        objADOStream.Position = 0 'Set the stream position to the start

        Set objFSO = Createobject("Scripting.FileSystemObject")
        If objFSO.Fileexists(writable_dir & participant.getElementsByTagName("waiver_id")(0).childNodes(0).nodeValue & ".pdf") Then objFSO.DeleteFile writable_dir & participant.getElementsByTagName("waiver_id")(0).childNodes(0).nodeValue & ".pdf"
        Set objFSO = Nothing

        objADOStream.SaveToFile writable_dir & participant.getElementsByTagName("waiver_id")(0).childNodes(0).nodeValue & ".pdf"
        objADOStream.Close
        Set objADOStream = Nothing

    End if

    Set objXMLHTTP = Nothing
    
    'TIP: saving the file as ->waiver_id.pdf is just an example but this will guarantee that all file names are unique.  Feel free to save your files as anything that's convenient (i.e. your internal customer id).

    Response.Write "Saved " & participant.getElementsByTagName("firstname")(0).childNodes(0).nodeValue & " " & participant.getElementsByTagName("lastname")(0).childNodes(0).nodeValue & "'s waiver with filename: " & participant.getElementsByTagName("waiver_id")(0).childNodes(0).nodeValue & ".pdf<br>"
Next
%>