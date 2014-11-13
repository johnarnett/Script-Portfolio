<html>
<title>
Locked-Out AD Accounts
</title>
<body>
<font face="Calibri">

<?php
print "Locked-Out AD Accounts:<b>";
system ("./ad_locked.sh");
system ("awk {'print $3'} tmp.out > tmp.tmp");
system ("sed 's/$/<br>/g' tmp.tmp >> tmp2.out");
system ("cat tmp2.out");
system ("rm tmp.out");
system ("rm tmp.tmp");
?>

</body>
</html>
