From: "Zhang Zhuoyu" <zhangzhuoyu@cmss.chinamobile.com>
Date: Sun, 08 Apr 2018 03:57:18 +0000
Subject: RE: [PATCH 1/1] target:separate tx/rx cmd_puds
Message-Id: <000001d3ceed$b0d9c870$128d5950$@cmss.chinamobile.com>
List-Id: <target-devel.vger.kernel.org>
References: <1521625963-657195-1-git-send-email-zhangzhuoyu@cmss.chinamobile.com>       <20180405131212.3f26339d@suse.de> <20180406140934.2dfafd45@suse.de>
In-Reply-To: <20180406140934.2dfafd45@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
To: 'David Disseldorp' <ddiss@suse.de>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Disseldorp [mailto:ddiss@suse.de]
> Sent: Friday, April 6, 2018 8:10 PM
> To: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
> Cc: nab@linux-iscsi.org; linux-scsi@vger.kernel.org; target-
> devel@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] target:separate tx/rx cmd_puds
>=20
> On Thu, 5 Apr 2018 13:12:12 +0200, David Disseldorp wrote:
>=20
> > > -CONFIGFS_ATTR_RO(target_stat_tgt_port_, in_cmds);
> > > +CONFIGFS_ATTR_RO(target_stat_tgt_port_, tx_cmds);
> > > +CONFIGFS_ATTR_RO(target_stat_tgt_port_, rx_cmds);
> >
> > I don't think the in_cmds metric should be deleted here. It could be
> > calculated on the fly via tx_cmds + rx_cmds + nodata_cmds.
>=20
> @Zhang Zhuoyu: How about something like the following?
> https://git.samba.org/?p=DDiss/linux.git;a=3Dcommitdiff;hs723ccf433424721
> 830797d70cfb88d4596e0fc
>=20

Mmm... This patch is much better.=20
Looks good to me.

Zhuoyu

> ...this keeps the in_cmds metric, and renames tx/rx_cmds read/write_cmds
> respectively. read/write_cmds is still a bit ambiguous, as it refers to
the
> command data direction rather than SCSI READ/WRITE CDBs, but IMO it's
> clearer, and more consistent with the read/write_mbytes metrics.
>=20
> Cheers, David



