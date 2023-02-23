<?php

    $conteudo = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

    echo substr($conteudo,0,30);
    echo "<br>";
    $nome = "Guilherme Cherem Grillo"; 
    $nomes = explode(' ', $nome);
    print_r($nomes);
    echo "<br>";  

    $nomes = implode(' ', $nomes);
    print_r($nomes);
    echo "<br>";  

    $conteudo = "<h1> Guilherme </h1>";
    
    echo $conteudo;
    echo "<br>";  
    echo strip_tags($conteudo);
    //strip_tags retirar todo o codigo html 

    //htmlentities que mostra o codigo html na pagina 
    
    echo "<br>";  
    echo htmlentities($conteudo);
    echo "<br>";      echo "<br>";      echo "<br>";  

    $str = "A 'quote' is <b>bold</b>";

// Outputs: A 'quote' is &lt;b&gt;bold&lt;/b&gt;
echo htmlentities($str);

// Outputs: A &#039;quote&#039; is &lt;b&gt;bold&lt;/b&gt;
echo htmlentities($str, ENT_QUOTES);

?>
