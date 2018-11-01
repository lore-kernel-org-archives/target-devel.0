From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 01 Nov 2018 09:51:39 +0000
Subject: [bug report] iscsi-target: Fix panic when adding second TCP connection to iSCSI session
Message-Id: <20181101095139.ntoxxswfc3tsal54@kili.mountain>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Feng Li,

This is a semi-automatic email about new static checker warnings.

The patch 8abc718de6e9: "iscsi-target: Fix panic when adding second 
TCP connection to iSCSI session" from Jul 12, 2016, leads to the 
following Smatch complaint:

    drivers/target/iscsi/iscsi_target_login.c:1405 __iscsi_target_login_thread()
     error: we previously assumed 'conn->sess' could be null (see line 1394)

drivers/target/iscsi/iscsi_target_login.c
  1393	
  1394		if (conn->sess)
                    ^^^^^^^^^^
We added a check here.

  1395			conn->sess->se_sess->sup_prot_ops   1396				conn->conn_transport->iscsit_get_sup_prot_ops(conn);
  1397	
  1398		tpg = conn->tpg;
  1399		if (!tpg) {
  1400			pr_err("Unable to locate struct iscsi_conn->tpg\n");
  1401			goto new_sess_out;
  1402		}
  1403	
  1404		if (zero_tsih) {
  1405			if (iscsi_login_zero_tsih_s2(conn) < 0)
                                                     ^^^^
But conn->sess is dereferenced here.  Perhaps the zero_tsih check implies
that conn->sess is non-NULL but I don't know the code well enough to say
for sure.

  1406				goto new_sess_out;
  1407		} else {

regards,
dan carpenter
