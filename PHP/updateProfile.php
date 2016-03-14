<?php
    header('Content-Type:text/json');
    $con = mysqli_connect("mysql.serversfree.com","u580010205_alexe","alex8347","u580010205_alexe");
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    $name = htmlspecialchars($_POST["name"]);
    $data = hash_file('md5', file_get_contents($_FILES['photo']['tmp_name']));
    mysqli_query($con,"UPDATE profiles SET data='".$data."' WHERE name='".$name."'");
    mysqli_close($con);
    exit("Updated " . $name . " profile");
?>