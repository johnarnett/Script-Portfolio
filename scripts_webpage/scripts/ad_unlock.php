<html>
<title>
Unlock AD Account
</title>
<body>
<font face="Calibri">

<?php
$aduser= $_POST['aduser'];
print "AD Account Unlock";
system ("./ad_unlock.sh $aduser");
system ("sed 's/$/<br>/g' tmp.out >> tmp2.out");
system ("cat tmp2.out");
system ("rm tmp.out");
system ("rm tmp2.out");
?>

</body>
</html>
