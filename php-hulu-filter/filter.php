<?php

$cid = NULL;
if (array_key_exists('cid', $_REQUEST)) {
	$cid = $_REQUEST['cid'];
} elseif (array_key_exists('uri', $_REQUEST)) {
	$page = file_get_contents($_REQUEST['uri']);
	$matches = array();
	preg_match('/content_id\"\,\ (\d+)/', $page, $matches);
	$cid = $matches[1];
}

if ( $cid == NULL ) {
	if ( array_key_exists('callback', $_REQUEST) ) {
		exit($_REQUEST['callback'] . '({})');
	} else {
		exit('{}');
	}
}

require_once('redis.php');
require_once('xml.php');
require_once('bad.php');

$redis = new redisent\Redis('localhost');

$from_redis = $redis->get('subtitles_' . $cid);

//var_dump($from_redis);

if ($from_redis != null) {
	$results = unserialize($from_redis);
	$filterlist = unserialize($redis->get('filterlist_' . $cid));
} else {
	$sub_page = file_get_contents("http://www.hulu.com/captions?content_id=$cid");
	$xml = new SimpleXMLElement($sub_page);
	$subtitles_url = $xml->en;
	$subs = file_get_contents($subtitles_url);
	$subs = xml2array($subs);
	$subs = $subs['SAMI']['BODY']['SYNC'];
	$results = array();

	foreach ($subs as $key => $sub) {
		if (!is_array($sub)) {
			$cmd = dirname(__FILE__) . '/subtitle.pm ' . $sub;
			#info('Command is ' . $cmd);
			$translated = exec($cmd);
			if (trim($translated) != '') {
				$start = $subs[$key . '_attr']['start'];
				$end = $subs[($key+1) . '_attr']['start'] + 1000;
				$profanity = filter($translated);
				$results[] = array('text' => $translated, 'start' => $start, 'end' => $end, 'has_profanity' => $profanity);
			}
		}
	}

	$filterlist = array();
	foreach ($results as $key => $sub) {
		if ($sub['has_profanity'])
			$filterlist[] = array('start' => $sub['start'], 'end' => $sub['end']);
	}

	$redis->set('subtitles_' . $cid, serialize($results));
	$redis->set('filterlist_' . $cid, serialize($filterlist));
}

if ( array_key_exists('callback', $_REQUEST) ) {
	echo $_REQUEST['callback'] . '(' . json_encode($filterlist) . ')';
} else {
	echo json_encode($filterlist);
}

