From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 12 Nov 2020 17:00:08 +0000
Subject: Re: [PATCH 0/5 V5] vhost-scsi: IO error fixups
Message-Id: <20201112170008.GB1555653@stefanha-x1.localdomain>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="xXmbgvnjoT4axfJE"
List-Id: <target-devel.vger.kernel.org>
References: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, virtualization@lists.linux-foundation.org

--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 09, 2020 at 11:33:18PM -0600, Mike Christie wrote:
> The following patches were made over Michael's vhost branch:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=3Dvh=
ost
>=20
> They fixe a couple issues where the guest is getting IO errors:
> 1. The admin may set num_queues and cmd_per_lun/virtqueue_size
> in a way that allows the guest to send more IO that vhost-scsi
> was coded for.
>=20
> 2. A race where vhost-scsi completes the cmd to the guest before
> it's fully completed in the target/vhost-scsi layers so if the
> guest sends a new IO too quicky we fail it.
>=20
> 3. If the real/physical storage (lio backend device) hits a transient
> error then vhost-scsi would fail commands instead of relying on
> the lower levels error recovery to do what the admin had set up.
>=20
> V5:
> - Bring back V1 but move flush patches to a separate clean up set
> - Modify test in vhost_vq_is_setup
>=20
> V4:
> - really really fix compile errors
> - dropped threading patches so we can figure that out separately.
>=20
> V3:
> - fix compile errors
> - fix possible crash where cmd could be freed while adding it to
> completion list
> - fix issue where we added the worker thread to the blk cgroup but
> the blk IO was submitted by a driver workqueue.
>=20
> V2:
> - fix use before set cpu var errors
> - drop vhost_vq_is_setup
> - include patches to do a worker thread per scsi IO vq
>=20
>=20

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+tahgACgkQnKSrs4Gr
c8itSwf9GVyHTRV2sAUjFG8BDBKEP3l/jOvX8Fd3PEaYkAfmmX+WgGtTbq1JHFLU
5YpudBKY56GIhQv2gQtzy6yG0IGZLgRfgNSJMIbD3OEdRIfXiwqZXqtmPGyDG8mh
yLK98M0I1dkEV0UTtyMDizZHlJGvDierunEbtAgw0gijw2tZZ4siWtPkvHRUKPX+
vFLB14FoAOEX88ykHQYoN/AgfS4WM4FPhRZ3jy67IK5HwrS5uK/rdGy/bkVx+V0R
NQDlP1FsYGABk6rFD/yK5zFwuJNIqSS+vSxFhdcZkVYczlJkxrY38XCQZTgEmSb/
uMx/xfUfsNad2GEOLlz3rAa3gJUCwQ==
=ERi/
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
