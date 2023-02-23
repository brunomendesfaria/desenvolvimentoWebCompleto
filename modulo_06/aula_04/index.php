<?php
	function mostrarNome($nome,$idade){
		echo "<H2> Nome é: $nome</H2>";
		echo "<H2> Idade é: $idade</H2>";
	}

	function calculadora($numero1 = 10, $numero2=5){
		echo ($numero1+$numero2);
	}

	calculadora();
	echo "<br>";
	calculadora(11,2);

	function verdade(){
		return true;
	}

	function retornarString(){
		return "Guilherme";
	}
	echo "<br>";
	echo retornarString();

	$variavel1 = verdade(); 

	echo "<br>";
	echo'echo $variavel1=>'.$variavel1;	


	mostrarNome("Bruno Mendes de Faria", "39 anos");

	mostrarNome("Bruno Mendes de Faria", "40 anos");
?>