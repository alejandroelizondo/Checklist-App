<?php
//        $id = htmlspecialchars($_POST["id"]);
    //
    //    if ($result->num_rows > 0) {
    //        while($row = $result->fetch_assoc()) {
    //            echo "id: " . $row["id"]. " - Name: " . $row["firstname"]. " " . $row["lastname"]. "<br>";
    //        }
    //    } else {
    //        echo "0 results";
    //    }
    
    header('Content-Type:text/json');
    
    $con = mysqli_connect("mysql.serversfree.com","u580010205_alexe","alex8347","u580010205_alexe");
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    
    //    mysqli_query($con,"UPDATE test SET completed='".$completed."', title='".$title."', date='".$date."' WHERE id='".$id."'");
    $result = mysqli_query($con,"SELECT * FROM checklist");
    $rows = array();
    while($row = mysqli_fetch_assoc($result)){
        $rows[] = $row;
    }
    //    if ($result->num_rows > 0) {
    //        while($row = $result->fetch_assoc()) {
    //            echo "id: " . $row["id"]. " - Title: " . $row["title"]. " - Completed: " . $row["completed"]. "<br>";
    //        }
    //    }
    
    //    mysqli_query($con,"SELECT * FROM Persons");
    //    mysqli_query($con,"INSERT INTO Persons (FirstName,LastName,Age) VALUES ('Glenn','Quagmire',33)");
    
    mysqli_close($con);
    
    exit(json_encode($rows));
?>