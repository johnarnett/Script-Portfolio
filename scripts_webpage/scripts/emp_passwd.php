<html>
<title>
Reset Employee Password
</title>
<body>
<font face="Calibri">

<?php
$store= $_POST['store'];
$emp= $_POST['emp'];
print "Reset Employee Password<br><br><br>";
system ("./emp_passwd.sh $store $emp");
system ("sed 's/$/<br>/g' tmp.out >> tmp2.out");
print "Password Confirmation:";
system ("cat tmp2.out | grep -v passwd");
system ("sed -i '/^$/d' tmp2.out");
system ("rm tmp.out");
system ("rm tmp2.out");
?>

</body>
</html>
