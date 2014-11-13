<html>
<title>
PO Generator
</title>
<body>
<font face="Calibri">

<?php
$STORE= $_POST['store'];
$COUNTRY= $_POST['country'];
$COST= $_POST['cost'];
$DESC= $_POST['desc'];
$DESC= str_replace(" ", "", $DESC);
print "PO / Reference Numbers:<br><br>";
system ("./po_gen.sh $STORE $COUNTRY $COST $DESC");
system ("sed 's/$/<br>/g' tmp.out >> tmp2.out");
system ("cat tmp2.out");
system ("rm tmp.out");
system ("rm tmp2.out");
?>
</body>
</html>
