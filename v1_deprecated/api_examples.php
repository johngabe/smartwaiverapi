<?php
/*
 * This is a basic API example that will print your 10 most recent waiver's participant names
 */

//YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
require_once 'config.php';

$api_result = simplexml_load_file("https://www.smartwaiver.com/api/?rest_request=" . API_KEY . "&rest_includependingwaivers&rest_limit=10");
foreach($api_result as $document) {
    if(isset($document->unique_id)) {
        //the next 2 lines are just examples of how to obtain each participant's information.  For a full list of values please go to: https://www.smartwaiver.com/p/API
        echo $document->unique_id . ": ";
        echo $document->firstname . " " . $document->lastname . "<br />";
    }
}