<?php
    header('Content-Type:text/json');
    $con = mysqli_connect("mysql.serversfree.com","u580010205_alexe","alex8347","u580010205_alexe");
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    $name = htmlspecialchars($_POST["name"]);
    $result = mysqli_query($con,"SELECT * FROM checklist WHERE name='".$name."'");
    $rows = array();
    while($row = mysqli_fetch_assoc($result)){
        $rows[] = $row;
    }
    mysqli_close($con);
    exit(json_encode($rows));
?>