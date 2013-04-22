<?php
/*
 * API Version: 2.0
 * This is an example of a webhook listener that you would place on your server.
 * After you set it up go to: https://www.smartwaiver.com/m/rest/?webhooks and set your Webhook URL to: https://www.YOURDOMAIN.com/webhook_listener.php or whatever you titled this script.
 */

//YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
require_once 'config.php';

//make sure all required values are passed
if(!isset($_POST['unique_id'])) return false;
if(!isset($_POST['credential'])) return false;
if(!isset($_POST['event'])) return false;

//for now you only want to support new-waiver events.  This was added so that we can add future web hooks without conflict.
if($_POST['event'] != "new-waiver") return false;

//check that the credential is correct
if($_POST['credential'] != md5(API_KEY . $_POST['unique_id'])) return false;

//determine API URL
$api_url = "https://www.smartwaiver.com/api/" . API_VERSION . "/?rest_request=" . API_KEY . "&rest_waiverid=" . urlencode($_POST['unique_id']);

$api_result = simplexml_load_file($api_url);

if(!$api_result->participants) return false;

foreach($api_result->participants->participant as $participant) {
    //the next 3 lines are just examples of how to obtain each participant's information.  For a full list of values please go to: https://www.smartwaiver.com/p/API
    $waiver_id = $participant->waiver_id;
    $firstname = $participant->firstname;
    $lastname = $participant->lastname;

    //INSERT INTO DATABASE HERE
}