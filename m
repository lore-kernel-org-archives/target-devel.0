From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:16 +0000
Subject: [RFC PATCH 00/15] target: export session info
Message-Id: <1531696591-8558-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Currently, session info is in 3 places:

1. iscsi has the info file under initiator acls.

2. In the tpg dir iscsi and qla have the dynamic sessions.

3. Some lun stat files return some initiator info.

The problem with these is for:

1 and 3 - They only display 1 session's info per target port.
In multipath and HA setups you will have multiple initiator ports
connected to each target port, so for iscsi the isid will be different
for each session.

2 - We only get the initiator name. For iscsi we want the isid. Also
if we have a lot of sessions we are limited by the PAGE_SIZE file limit.

To handle all these issues these patches add session info under

/sys/kernel/config/target/iscsi/$target_name/tpgt_$N/sessions

This only a RFC right now. There is still a bug in the iscsi code
where if configfs registration fails we have to cleanup the
session.

