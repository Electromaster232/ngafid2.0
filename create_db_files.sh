
echo "ngafid
db-host
root
ngafid" > db/db_info

echo """<?php
\$ngafid_db_user = 'root';
\$ngafid_db_name = 'ngafid';
\$ngafid_db_host = 'db-host';
\$ngafid_db_password = 'ngafid';
?>""" > db/db_info.php
