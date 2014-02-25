<?php
/*
 * API Version: 3.0
 * This is a basic API example that will show a list of your last 20 check-ins
 */

//YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
require_once 'config.php';

$api_result = simplexml_load_file("https://www.smartwaiver.com/api/" . API_VERSION . "/?rest_request=" . API_KEY . "&restapi_checkins=10");

if((!isset($api_result->checkins)) || (!isset($api_result->checkins->checkin))) {
    return false; //if you don't have any checkins it'll fail here
}

foreach($api_result->checkins->checkin as $checkin) {
    echo "Participant ID: " . $checkin->participant_id;
    echo "<br>Date UTC: " . $checkin->date_utc;
    echo "<hr>";
}