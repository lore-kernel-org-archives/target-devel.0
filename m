From: David Disseldorp <ddiss@suse.de>
Date: Fri, 06 Apr 2018 12:09:34 +0000
Subject: Re: [PATCH 1/1] target:separate tx/rx cmd_puds
Message-Id: <20180406140934.2dfafd45@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <1521625963-657195-1-git-send-email-zhangzhuoyu@cmss.chinamobile.com>
        <20180405131212.3f26339d@suse.de>
In-Reply-To: <20180405131212.3f26339d@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
To: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 5 Apr 2018 13:12:12 +0200, David Disseldorp wrote:

> > -CONFIGFS_ATTR_RO(target_stat_tgt_port_, in_cmds);
> > +CONFIGFS_ATTR_RO(target_stat_tgt_port_, tx_cmds);
> > +CONFIGFS_ATTR_RO(target_stat_tgt_port_, rx_cmds); =20
>=20
> I don't think the in_cmds metric should be deleted here. It could be
> calculated on the fly via tx_cmds + rx_cmds + nodata_cmds.

@Zhang Zhuoyu: How about something like the following?
https://git.samba.org/?p=DDiss/linux.git;a=3Dcommitdiff;hs723ccf43342472183=
0797d70cfb88d4596e0fc

...this keeps the in_cmds metric, and renames tx/rx_cmds read/write_cmds
respectively. read/write_cmds is still a bit ambiguous, as it refers to
the command data direction rather than SCSI READ/WRITE CDBs, but IMO
it's clearer, and more consistent with the read/write_mbytes metrics.

Cheers, David
