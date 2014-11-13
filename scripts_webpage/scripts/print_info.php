<html>
<title>
Printer Info
</title>
<body>
<font face="Calibri">

<?php
$store= $_POST['store'];
print "Store $store Printer Info<br><br>";
system ("./print_info.sh $store");
system ("sed 's/$/<br>/g' tmp.out >> tmp2.out");
system ("cat tmp2.out");
system ("rm tmp.out");
system ("rm tmp2.out");
?>

</body>
</html>
