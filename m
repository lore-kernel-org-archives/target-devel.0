From: =?UTF-8?B?5LqT5q2m5by6?= <octor.qi@gmail.com>
Date: Sun, 20 May 2018 09:10:00 +0000
Subject: tcmu data consistency
Message-Id: <CAF2hZrm9AQtzAFKRk5Z9cbX0KAy7crJp1+RDXJMPUivV19_58Q@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

hi：
    i have some questions about the tcmu, consider following scenario：

1，Iscsi initiator establishes two session connection with gw1,gw2 at
the same time. gw1  is the active path.

2,  The active path is switched to gw 2 due to the interruption of the
connection from the initiator to gw1.

3, gw2  acquire exclusive lock and write some data to lun0.  then gw1
update the exclusive lock to UNLOCKED.

4, after step 3,   some old  iscsi session  inflight write ios
arrival gw1 , gw1  acquire the exclusive lock again, the old data will
  overwrite new data.
