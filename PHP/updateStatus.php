<?php
    $con = mysqli_connect("mysql.serversfree.com","u580010205_alexe","alex8347","u580010205_alexe");
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    $name = htmlspecialchars($_POST["name"]);
    $status = htmlspecialchars($_POST["status"]);
    mysqli_query($con,"UPDATE status SET status='".$status."' WHERE name='".$name."'");
    mysqli_close($con);
    exit("Updated status from " . $name)
?>