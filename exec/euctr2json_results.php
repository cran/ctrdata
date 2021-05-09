<?php

// file: euctr2json_results.php
// ralf.herold@gmx.net
// part of https://github.com/rfhb/ctrdata
// last edited: 2017-07-28
// time euctr2json_results.php:
// 2017-07-30: 0.23 s for 3 trials ~ 75 ms per trial

// note line endings are to be kept by using in
// .gitattributes for compatibility with cygwin:
// *.sh  text eol=lf
// *.php text eol=lf

if ($argc <= 1) {
  die("Usage: php -n -f euctr2json_results.php <directory_path_with_xml_files>\n");
} else {
  $xmlDir = $argv[1];
}

file_exists($xmlDir) or die('Directory or file does not exist: ' . $xmlDir);

// chunk and trial counters
$cn = 0;
$tn = 0;

// euctr format for file name is for example: "EU-CTR 2008-003606-33 v1 - Results.xml"
foreach (array_chunk(glob("$xmlDir/EU*Results.xml"), 20) as $chunkFileNames) {

  $cn = $cn + 1;

  foreach ($chunkFileNames as $inFileName) {

    $fileContents = file_get_contents($inFileName);

    // normalise contents and remove whitespace
    $fileContents = str_replace(array("\n", "\r", "\t"), '', $fileContents);

    // https://stackoverflow.com/questions/44765194/how-to-parse-invalid-bad-not-well-formed-xml
    $fileContents = preg_replace('/[^\x{0009}\x{000a}\x{000d}\x{0020}-\x{D7FF}\x{E000}-\x{FFFD}]+/u', ' ', $fileContents);

    // escapes
    $fileContents = preg_replace('/ +/', ' ', $fileContents);
    $fileContents = trim(str_replace("'", " &apos;", $fileContents));
    $fileContents = trim(str_replace("&", " &amp;", $fileContents));

    // use single escapes for xml
    $fileContents = trim(str_replace('"', "'", $fileContents));

    // turn repeat elements
    $simpleXml = simplexml_load_string($fileContents, 'SimpleXMLElement', LIBXML_COMPACT | LIBXML_NOBLANKS | LIBXML_NOENT);

    // save in file
    file_put_contents("$xmlDir/EU_Results_" . $cn . ".json", json_encode($simpleXml) . "\n", FILE_APPEND | LOCK_EX);

    $tn = $tn + 1;
  }
}

print $tn;
