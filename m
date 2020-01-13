From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Date: Mon, 13 Jan 2020 16:51:28 +0000
Subject: Cannot log in from BIOS to linux target
Message-Id: <20200113165128.GC4113@kitsune.suse.cz>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello,

my system BIOS support booting from iSCSI.

I set up readonly target with no authentication:

targetcli shell version 2.1.fb49

grub .................................................................. [/scratch/ISO/GRUB (1.8MiB) write-back activated]
  | |   o- alua ................................................................................................. [ALUA Groups: 1]
  | |     o- default_tg_pt_gp ..................................................................... [ALUA state: Active/optimized]

 | | o- tpg1 ................................................................................................ [gen-acls, no-auth]
  | |   |   o- mapped_lun0 ............................................................................... [lun0 fileio/grub (rw)]
The readonly flag does not seem to be honored                                                                                 ^^^

Anyway, the initiator cannot log in:

3,1360,2329588663878,-;Initiator sent zero length security payload, login failed
3,1361,2329588663897,-;iSCSI Login negotiation failed.

How can I export a LUN without a password?

Thanks

Michal
