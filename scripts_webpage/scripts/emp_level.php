<html>
<title>
Security Level
</title>
<body>
<font face="Calibri">

<?php
$store= $_POST['store'];
$level= $_POST['level'];
$slcode= $_POST['slcode'];

print "New Security Level";
system ("./emp_level.sh $store $level $slcode");
system ("sed 's/$/<br>/g' tmp.out >> tmp2.out");
system ("cat tmp2.out | grep -v sl");
system ("rm tmp.out");
system ("rm tmp2.out");
?>

</body>
</html>
