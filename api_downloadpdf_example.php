<?php
/*
 * This is a basic API example that will download your most recent waiver's PDF into a local directory
 */

//YOU MUST SET YOUR API KEY IN THE CONFIG FILE FIRST
require_once 'config.php';

//SET A WRITABLE DIRECTORY WHERE YOU WANT TO SAVE YOUR PDF
//IMPORTANT: Waivers should not be stored in directories that the public can access (or bots)!  Obviously waivers include private information and therefore should be in private directories.
$writable_dir = "./";

//REQUEST THE MOST RECENT WAIVER
$api_result = simplexml_load_file("https://www.smartwaiver.com/api/?rest_request=" . API_KEY . "&rest_includependingwaivers&rest_limit=1");

foreach($api_result as $document) {
    if(isset($document->pdf_url)) {
        $download_url = "https://www.smartwaiver.com/api/?rest_request=" . API_KEY . "&restapi_viewpdf=" . $document->pdf_url;
        $pdf_src = file_get_contents($download_url);
        if(!$pdf_src) return false;

        //if the next part fails you may not have write permission on teh writable_dir
        if(!file_put_contents($writable_dir . $document->unique_id . ".pdf",$pdf_src)) return false;

        echo "saved " . $document->firstname . " " . $document->lastname . "'s waiver with filename: " . $document->unique_id . ".pdf<br>";
    }
}