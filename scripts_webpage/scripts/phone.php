<html>
<title>
Phone Lookup
</title>
<body>
<font face="Calibri">
Store Lookup by Phone Number<br>
<br>
<br>

<?php
$phnum= $_POST['phnum'];
system ("./phone.sh $phnum");
system ("cat tmp.out | cut -d ' ' -f2- >> tmp2.out");
system ("sed -i '/^$/d' tmp2.out");
system ("sed -i 's/$/<br>/g' tmp2.out");
system ("cat tmp2.out");
system ("rm tmp.out");
system ("rm tmp2.out");
?>
</font>
</body>
</html>
