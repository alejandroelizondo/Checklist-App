<?php
    $con = mysqli_connect("mysql.serversfree.com","u580010205_alexe","alex8347","u580010205_alexe");
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    $id = htmlspecialchars($_POST["id"]);
    $title = htmlspecialchars($_POST["title"]);
    $date = htmlspecialchars($_POST["date"]);
    $completed = htmlspecialchars($_POST["completed"]);
    mysqli_query($con,"UPDATE checklist SET completed='".$completed."', title='".$title."', date='".$date."' WHERE id='".$id."'");
    mysqli_close($con);
    exit("Updated " . $id)
?>