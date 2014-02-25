<?php
/*
 * API Version: 3.0
 * This is a basic API example that will print your 10 most recent waiver's participant names
 */

//YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
require_once 'config.php';

$api_result = simplexml_load_file("https://www.smartwaiver.com/api/" . API_VERSION . "/?rest_request=" . API_KEY . "&rest_limit=10");

//DO YOU HAVE ANY WAIVERS?
if(!isset($api_result->participants)) {
    return false; //if you don't have any waivers it'll fail here
}

foreach($api_result->participants->participant as $participant) {
        //the next 2 lines are just examples of how to obtain each participant's information.  For a full list of values please go to: https://www.smartwaiver.com/p/API
        echo $participant->waiver_id . ": " . $participant->firstname . " " . $participant->lastname . "<br />";
}