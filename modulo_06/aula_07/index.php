<?php
    $nome = "Guilherme"; 

    switch($nome){
        case "Guilherme":
            echo "Minha varável é Guilherme";
            break; 
        case "Joao":
            echo "Minha variável é Joâo";
            break;
    }

    for ($i=0; $i < 10; $i++) { 
        echo $i; 
        echo "<hr>";

        if ($i==5)
            break;
    }
?>