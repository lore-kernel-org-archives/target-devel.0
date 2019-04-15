From: David Disseldorp <ddiss@suse.de>
Date: Mon, 15 Apr 2019 10:51:38 +0000
Subject: Re: [PATCH 1/1] target:separate tx/rx cmd_puds
Message-Id: <20190415125138.2f0d09b7@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <1521625963-657195-1-git-send-email-zhangzhuoyu@cmss.chinamobile.com>
In-Reply-To: <1521625963-657195-1-git-send-email-zhangzhuoyu@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

[replying to an old thread]

On Sun, 8 Apr 2018 11:57:18 +0800, Zhang Zhuoyu wrote:

> > On Thu, 5 Apr 2018 13:12:12 +0200, David Disseldorp wrote:
> >  =20
> > > > -CONFIGFS_ATTR_RO(target_stat_tgt_port_, in_cmds);
> > > > +CONFIGFS_ATTR_RO(target_stat_tgt_port_, tx_cmds);
> > > > +CONFIGFS_ATTR_RO(target_stat_tgt_port_, rx_cmds); =20
> > >
> > > I don't think the in_cmds metric should be deleted here. It could be
> > > calculated on the fly via tx_cmds + rx_cmds + nodata_cmds. =20
> >=20
> > @Zhang Zhuoyu: How about something like the following?
> > https://git.samba.org/?p=DDiss/linux.git;a=3Dcommitdiff;hs723ccf4334247=
21
> > 830797d70cfb88d4596e0fc
> >  =20
>=20
> Mmm... This patch is much better.=20
> Looks good to me.

Looks like I never followed up with a proper submission for this patch.
I'll do so later today.

Cheers, David
