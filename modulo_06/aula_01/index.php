<?php
	$arr = array('Guilherm','João', 'Felipe', 'Mario');

	foreach ($arr as $key => $value) {
		echo $key; 
		echo '=>';
		echo $value; 
		echo '<hr>';
	}

	$total = count($arr); 
	echo "<hr>";
	echo "<hr>";
	echo "<hr>";
	for($i = 0; $i< $total; $i++) { 
		echo $arr[$i];
		echo "<hr>";
	}
?>