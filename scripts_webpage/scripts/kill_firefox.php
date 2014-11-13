<html>
<title>
Kill Firefox
</title>
<body>
<font face="Calibri">

<?php
$store= $_POST['store'];
system ("./kill_firefox.sh $store");
system ("sed 's/$/<br>/g' tmp.out >> tmp2.out");
system ("cat tmp2.out");
system ("rm tmp.out");
system ("rm tmp2.out");
?>

</body>
</html>
