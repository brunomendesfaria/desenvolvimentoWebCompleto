<?php 
    /* Trabalhando com data */ 

    date_default_timezone_set('America/Sao_Paulo');

    $data = date('d/m/Y h:i:s',time()+(60*10));

    echo "$data";
?>