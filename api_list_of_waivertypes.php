<?php
/*
 * This is a basic API example will print the urls to all of your waiver types
 */

//YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
require_once 'config.php';

$api_result = simplexml_load_file("https://www.smartwaiver.com/api/?rest_request=" . API_KEY . "&resetapi_listofwaivertypes");
$count = 0;

foreach($api_result->waivers->waiver as $waiver) {
        //print the title of your waiver
        echo $waiver->title . ": ";
        //determine the waiver's unique identifier
        $guid = $waiver->guid;
        //print links to both the web version & the kiosk version
        echo "<a href='https://www.smartwaiver.com/w/$guid/web/'>web</a> | <a href='https://www.smartwaiver.com/w/$guid/kiosk/'>kiosk</a><br>";

        $count++;
}

echo "You have $count waiver types.";