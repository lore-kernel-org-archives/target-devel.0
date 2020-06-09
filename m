From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Tue, 09 Jun 2020 10:11:43 +0000
Subject: Re: [PATCH 02/17] target: separate acl name from port ids
Message-Id: <20200609101143.GA92564@stefanha-x1.localdomain>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-3-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-3-git-send-email-michael.christie@oracle.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Juergen Gross <jgross@suse.com>

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 07, 2020 at 03:35:49PM -0500, Mike Christie wrote:
> The PGR code assumes the ACL name is going to be based on the SPC4
> transportID type of values. The problem is that for iSCSI we have an extr=
a
> session id as part of the SCSI port id and some fabric modules support or
> would like to support non transportID values for the ACL name. For exampl=
e,
> iSCSI and SRP would like to use the source address for the ACL name, but
> that is not a valud transportID value that you can get in a PGR request.
>=20
> This patch adds a new transport_id struct which maps to the SPC4
> transportID. In the future it will be used for PGR commands instead of th=
e
> ACL name. In this patchset it is used to export the initiator info in the
> session's sysfs dir, so tools can display the info and daemons that execu=
te
> commands like PGRs in userspace can build a session id to I_T nexus mappi=
ng.
>=20
> In this patch only srp is passing in different values for the transport i=
d
> and acl name. The next patches will convert loop, scsi vhost and xen
> scsiback that are more complex due to their initiator name emulation.
>=20
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Juergen Gross <jgross@suse.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c    | 10 +++++---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  4 +--
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c       |  2 +-
>  drivers/target/loopback/tcm_loop.c       |  3 ++-
>  drivers/target/sbp/sbp_target.c          |  2 +-
>  drivers/target/target_core_fabric_lib.c  | 41 ++++++++++++++++++++++++++=
+++++
>  drivers/target/target_core_transport.c   | 42 ++++++++++++++++++++++++--=
------
>  drivers/target/tcm_fc/tfc_sess.c         |  3 ++-
>  drivers/usb/gadget/function/f_tcm.c      |  3 ++-
>  drivers/vhost/scsi.c                     |  1 +
>  drivers/xen/xen-scsiback.c               |  3 ++-
>  include/target/target_core_base.h        | 12 +++++++++
>  include/target/target_core_fabric.h      |  5 +++-
>  13 files changed, 108 insertions(+), 23 deletions(-)

For drivers/vhost/scsi.c:
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7fYF8ACgkQnKSrs4Gr
c8gEawgAkeinOFUIiE7aOXNyKyV2gK+P9Y1YWfSDoErYzKLn6Va3v6jd41O9g19o
m6hBCOfB78sAjgCuUy0w6qSlBKZykWtNH3xd3ODLWkBQOwCtdh0ABf/ujsSi0gqq
b/fV9SFHiJrX3ipr0qlckq93VILT6a60MwT7tbw5E/vpmFpOB1sFxjfaRqhyyV38
dDuY7+WIR0ltVdLxkDh9Tx1Pg9Zs/lF1Lu0FGRat1wIaT027rtCdYakEasNqSoCP
5z+UYaHX2t4TaURtep3iOjGjLzmvB1YJTW8kza+zUrkCDV7KhXDcFoxXIVlUHX6L
TNA54otTU8z9nawIqDC1F3Bhyz3u/w==
=F629
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
