<?php
/*
 * API Version: 3.0
 * This is a basic API example that will download your most recent waiver's PDF into a local directory
 */

//YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
require_once 'config.php';

//SET A WRITABLE DIRECTORY WHERE YOU WANT TO SAVE YOUR PDF
//IMPORTANT: Waivers should not be stored in directories that the public can access (or bots)!  Obviously waivers include private information and therefore should be in private directories.
$writable_dir = "./";

//REQUEST THE MOST RECENT WAIVER
$api_result = simplexml_load_file("https://www.smartwaiver.com/api/" . API_VERSION . "/?rest_request=" . API_KEY . "&rest_limit=1");

//DO YOU HAVE ANY WAIVERS?
if(!isset($api_result->participants)) {
    return false; //if you don't have any waivers it'll fail here
}

//DOWNLOAD EACH WAIVER (You can bulk download up to 100 waivers at a time by modifying &rest_limit above to the desired # of participants)
foreach($api_result->participants->participant as $participant) {
   //create the download url
   $download_url = "https://www.smartwaiver.com/api/?rest_request=" . API_KEY . "&restapi_viewpdf=" . $participant->pdf_url;
   //downlaod it
   $pdf_src = file_get_contents($download_url);
   //check if successful
   if(!$pdf_src) return false;

    //if the next part fails you may not have write permission on teh writable_dir
    if(!file_put_contents($writable_dir . $participant->waiver_id . ".pdf",$pdf_src)) return false;

    //TIP: saving the file as ->waiver_id.pdf is just an example but this will guarantee that all file names are unique.  Feel free to save your files as anything that's convenient (i.e. your internal customer id).

    echo "saved " . $participant->firstname . " " . $participant->lastname . "'s waiver with filename: " . $participant->waiver_id . ".pdf<br>";
}