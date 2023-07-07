<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulário</title>
</head>
<body>
        <?php
        /*
            if (isset($_GET['acao'])){
                $nome= @$_GET['nome'];
                $email = @$_GET['email']; 
    
                echo $nome; 
                echo "<br>";
                echo $email;
            }
            */
            if (isset($_POST['acao'])){
                $nome= @$_POST['nome'];
                $email = @$_POST['email']; 
    
                echo $nome; 
                echo "<br>";
                echo $email;
            }          
            
        ?>
        <form method="post">
            <input type="text" name="nome" />
            <input type="text" name="email"/>
            <input type="submit" name="acao" value="Enviar" />
        </form>    
</body>
</html>