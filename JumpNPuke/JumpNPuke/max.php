#!/usr/bin/php
<?php

$f = file_get_contents($argv[1]);

$xml = simplexml_load_string($f);
//print_r($xml);

$x = 0;
$node = 0;

foreach ($xml->xpath('//object') as $i) {
	if ($x+0.0 < $i['x']+0.0 ) {
		$x = $i['x'];
		$node = $i;
	}
}

echo "max:".$x;
print_r($node);




?>
