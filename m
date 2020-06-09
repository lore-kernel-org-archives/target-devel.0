From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Tue, 09 Jun 2020 10:21:19 +0000
Subject: Re: [PATCH 05/17] vhost scsi: use target_parse_emulated_name
Message-Id: <20200609102119.GB92564@stefanha-x1.localdomain>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="VrqPEDrXMn8OVzN4"
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-6-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-6-git-send-email-michael.christie@oracle.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 07, 2020 at 03:35:52PM -0500, Mike Christie wrote:
> Use target_parse_emulated_name so the acl and SCSI names are
> properly formatted.
>=20
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/vhost/scsi.c | 69 +++++++++-------------------------------------=
------
>  1 file changed, 11 insertions(+), 58 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7fYp8ACgkQnKSrs4Gr
c8jVcwf/dCPPBFnjbBercpCQ+KQvH9cb46oCRgiAVI1ZmNntflqqRZ2Kyz+sg+jw
PyGBF1KQZ+mEVSinhIBPapi7Hqbn9kAHzrfyQZ8BUXOjT7NghRazIyiCdq8MxhoW
r4Y16YseuxyEeV67dYe88VFzH6Bv2LofJDBfItcKTBvSJPDG9yQllbeWCAOk4vby
NUVDr/W64qsczGGwXtOlTLIbqzt6FWOmrIbcqgbqivTWKpdD5FH4s+IKMhByO5JS
+yoD/TryxdmwCO+jCPVpD4rP/Qc/S62Dmo6l27bYJ/1pDsfxruss2ae0erWDZxam
eHNBNlQqEsws97RHGwLn0AkPIkBAOQ==
=rzYj
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
