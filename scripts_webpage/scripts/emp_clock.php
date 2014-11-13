<html>
<title>
Currently Clocked-In
</title>
<body>
<font face="Calibri">

<?php
$store= $_POST['store'];
print "View Employees Currently Clocked-In<br>";
system ("./emp_clock.sh $store");
system ("cat tmp.out | awk '{ print $1 }' >> tmp1.out");
system ("cat tmp.out | cut -d ' ' -f2- >> tmp2.out");
system ("sed -i 's/$/<br>/g' tmp1.out");
system ("sed -i 's/t_slsid/Sales Code/g' tmp1.out");
system ("sed -i 's/$/<br>/g' tmp2.out");
system ("sed -i 's/t_name/Name/g' tmp2.out");
?>

<div id="content" style="background-color:#FFFFFF;height:200px;width:150px;float:left;">
<?php system ("cat tmp1.out"); ?>
</div>

<div id="content" style="background-color:#FFFFFF;height:200px;width:200px;float:left;">
<?php system ("cat tmp2.out"); ?>
</div>

<?php
system ("rm tmp.out");
system ("rm tmp1.out");
system ("rm tmp2.out");
?>
