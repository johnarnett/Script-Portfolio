<html>
<title>
AD Info
</title>
<body>
<font face="Calibri">

<?php
$aduser= $_POST['aduser'];
print "Info for $aduser";
system ("./ad_info.sh $aduser");
system ("sed 's/$/<br>/g' tmp.out >> tmp2.out");
system ("cat tmp2.out");
system ("rm tmp.out");
system ("rm tmp2.out");
?>

</body>
</html>

