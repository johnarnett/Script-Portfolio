#!/bin/bash

# Get tax rate from corporate
function corp.tax {

. aprset
C_TAX1=$(echo "select st_tax_rate from stores where st_id = $1" | dbaccess atb 2>/dev/null | grep -v st_tax_rate)
C_TAX2=$(echo "select st_tax_rate2 from stores where st_id = $1" | dbaccess atb 2>/dev/null | grep -v st_tax_rate)
C_TAX3=$(echo "select st_tax_rate3 from stores where st_id = $1" | dbaccess atb 2>/dev/null | grep -v st_tax_rate)
C_TAX4=$(echo "select st_tax_rate4 from stores where st_id = $1" | dbaccess atb 2>/dev/null | grep -v st_tax_rate)

}

# Get tax rate from store system
function store.tax {

sudo ssh root@z$1 << EOF
cd /u/apropos
. ./getset

dbaccess apropos << ENDSQL

unload to /tmp/t1.unl
select st_tax_rate1 from store;

unload to /tmp/t2.unl
select st_tax_rate2 from store;

unload to /tmp/t3.unl
select st_tax_rate3 from store;

unload to /tmp/t4.unl
select st_tax_rate4 from store;

ENDSQL

sed -i 's/|//g' /tmp/t1.unl
sed -i 's/|//g' /tmp/t2.unl
sed -i 's/|//g' /tmp/t3.unl
sed -i 's/|//g' /tmp/t4.unl

EOF

S_TAX1=$(sudo ssh root@z$1 cat /tmp/t1.unl)
S_TAX2=$(sudo ssh root@z$1 cat /tmp/t2.unl)
S_TAX3=$(sudo ssh root@z$1 cat /tmp/t3.unl)
S_TAX4=$(sudo ssh root@z$1 cat /tmp/t4.unl)


}


# Get count of item taxability
function inv.taxable {

sudo ssh root@z$1 <<EOF
rm -rf /tmp/inv_taxable*

cd /u/apropos
. ./getset
dbaccess apropos << ENDSQL

unload to /tmp/inv1.unl
select count(*) from inventory
where inv_taxable = 'Y';

unload to /tmp/inv2.unl
select count(*) from inventory
where inv_taxable = 'N';

unload to /tmp/inv3.unl
select count(*) from inventory
where inv_taxable = '1';

unload to /tmp/inv4.unl
select count(*) from inventory
where inv_taxable = '2';

ENDSQL

sed -i 's/|//g' /tmp/inv1.unl
sed -i 's/|//g' /tmp/inv2.unl
sed -i 's/|//g' /tmp/inv3.unl
sed -i 's/|//g' /tmp/inv4.unl

EOF

INV1=$(sudo ssh root@z$1 cat /tmp/inv1.unl)
INV2=$(sudo ssh root@z$1 cat /tmp/inv2.unl)
INV3=$(sudo ssh root@z$1 cat /tmp/inv3.unl)
INV4=$(sudo ssh root@z$1 cat /tmp/inv4.unl)

}


corp.tax 123
echo $C_TAX1
echo $C_TAX2
echo $C_TAX3
echo $C_TAX4

store.tax 123
echo $S_TAX1
echo $S_TAX2
echo $S_TAX3
echo $S_TAX4

inv.taxable 123
echo $INV1
echo $INV2
echo $INV3
echo $INV4
