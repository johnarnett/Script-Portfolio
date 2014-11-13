<html>
<title>
Store Taxes
</title>
<body>
<font face="Calibri">

<?php

$USEREMAIL= $_POST['useremail'];
$RUNNING='/var/www/html/scripts/taxes/running';

if (file_exists($RUNNING)) {
        system ("cat running.txt");
}       else {
        system ("./taxes.sh $USEREMAIL &");
        system ("cat confirmation.txt");
}
?>
</body>
</html>
