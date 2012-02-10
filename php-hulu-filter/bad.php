<?php

require_once('words.php');

function filter(&$text) {

	global $bad_words;
	$remember = $text;
	foreach ( $bad_words as $bad ) {
		$text = preg_replace( '/\b(' . $bad . ')\b/i', '', $text);
	}

	if ( $remember != $text ) return true;
	else return false;

}