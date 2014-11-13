<html>
<title>
Store Info
</title>
<body>
<font face="Calibri">

<?php
$store= $_POST['store'];
print "Store $store Information:<br>";
system ("./store_info.sh $store > tmp.out");
system ("cat tmp.out | awk '{ print $1 }' >> tmp1.out");
system ("cat tmp.out | cut -d ' ' -f2- >> tmp2.out");
system ("sed -i 's/$/<br>/g' tmp1.out");
system ("sed -i 's/$/<br>/g' tmp2.out");
?>

<div id="content" style="background-color:#FFFFFF;height:200px;width:150px;float:left;">
<?php system ("cat tmp1.out"); ?>
</div>

<div id="content" style="background-color:#FFFFFF;height:200px;width:300px;float:left;">
<?php system ("cat tmp2.out"); ?>
</div>

<?php
system ("rm tmp.out");
system ("rm tmp1.out");
system ("rm tmp2.out");
?>

</body>
</html>
