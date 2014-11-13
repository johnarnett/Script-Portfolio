<html>
<title>
Bug Buddy Fix
</title>
<body>
<font face="Calibri">

<?php
$store= $_POST['store'];
print "Bug Buddy Fix ";
system ("./bug_buddy.sh $store");
print "Completed";
?>

</body>
</html>

