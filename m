From: Felipe Balbi <felipe.balbi@linux.intel.com>
Date: Thu, 23 Nov 2017 08:33:56 +0000
Subject: Re: [PATCH 11/11] usb/gadget: Make it again possible to enable the legacy drivers without enabling U
Message-Id: <87lgixmm17.fsf@linux.intel.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: <target-devel.vger.kernel.org>
References: <20171031180319.19258-12-bart.vanassche@wdc.com>
In-Reply-To: <20171031180319.19258-12-bart.vanassche@wdc.com>
To: target-devel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Bart Van Assche <Bart.VanAssche@wdc.com> writes:
> On Tue, 2017-10-31 at 11:03 -0700, Bart Van Assche wrote:
>> Considerable time ago the legacy gadget menu was added inside the
>> USB_ETH choice. I think this was a mistake and that the legacy
>> gadget menu should have been added after "endchoice" instead of
>> before. Hence this patch.
>>=20
>> Fixes: commit 8443f2d2b778 ("usb: gadget: Gadget directory cleanup - gro=
up legacy gadgets")
>> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
>> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
>> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: linux-usb@vger.kernel.org
>
> Hello Andrzej and Felipe,
>
> Can one or both of you have a look at this patch?

sure thing, as soon as the merge window closes :-)

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAloWh/QACgkQzL64meEa
mQYBeA//VhekBv0VXazxdnbDtttJQqmuy5MuR42rih8KGPWmc4AYo9TaNar4viAw
vgO+SGpTIfeFc8ur1cR3sk/kMu5Zt10OCqx6oSd9K/6FCpnvGGmYqDsUGhEuwWtq
u5Pj4bmpoeF94LkcQ/Bx+7zGYAq8puRHpyf1hy5MNVNy48oscm8O0cjzSn53XtLs
tACHaJPyPFCQJd58/DGNxcW8WNfld/juNLrhrgFzzlPskwAuFI7WD+1OyvDMqOJI
HuJ4ANKxSvtc1TyB3+5lZgeQlCbDpPqeRweT7tFqDSXizWH3tXszB3aCUr1IYCqJ
y48sb92SmDDyE30BFBzMUMo5W6P8dfD00gJJ8rN5+Amscvll7vJbOoanLEahFjFW
j1JKMepOG+AL9DE3blY7BNgTOkluNz6Dpq8efm3NpO7tms0k1sxf6Nctd/ZfeidN
RVmtlB6xzy6mut+RKgbtQFyjMS44+XiIv/f0814BqQyc/JguqN2d7vwHTFLT1F3A
qAA/IC8JySnfU+qZL9DSrL3hTLzhf2TYfXeMPPsf/CPJ2N5PowyK7/2zoZmg5mom
bCCP2qIL+U/c0IfjMhIClxm9zqWhdtfKCa83BbeR3/ucsab0TrU7e2+trtsrQTEW
lByayMWsaudJ9p36NpVVudGRKDxUoHZS+Bb2yCf/oVI2HGs2fAg=
=0UXJ
-----END PGP SIGNATURE-----
--=-=-=--
