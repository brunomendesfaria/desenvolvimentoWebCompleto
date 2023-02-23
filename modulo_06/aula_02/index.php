<?php 
	$arr = ['Guilherme', 'João'];
	$arr = array ('Guilherme', 'chave2'=>'João'); 

	$arr[] = 'Guilherme'; 
	$arr[] =  'João';

	$arr2 = array(array('Guilherme','João'),array(23,45));

	echo $arr2[1][0];
?>