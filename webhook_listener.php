<?php
require_once 'config.php';

//make sure all required values are passed
if(!isset($_POST['unique_id'])) return false;
if(!isset($_POST['credential'])) return false;
if(!isset($_POST['event'])) return false;

//for now you only want to support new-waiver events
if($_POST['event'] != "new-waiver") return false;

//check that the credential is correct
if($_POST['credential'] != md5(API_KEY . $_POST['unique_id'])) return false;

//determine API URL
//&rest_includependingwaivers will tell the API to return the waiver's information even if it's pending email validation
$api_url = "https://www.smartwaiver.com/api/?rest_request=" . API_KEY . "&rest_uniqid=" . urlencode($_POST['unique_id']) . "&rest_includependingwaivers";

$api_result = simplexml_load_file($api_url);
foreach($api_result as $document) {
    //the next 2 lines are just examples of how to obtains each participant's information.  For a full list of values please go to: https://www.smartwaiver.com/p/API
    $unique_id = $document->unique_id;
    $full_name = $document->firstname . " " . $document->lastname;

    //INSERT INTO DATABASE OR DO REQUIRED LOGIC HERE
}
