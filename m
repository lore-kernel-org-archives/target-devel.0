From: Will Deacon <will@kernel.org>
Date: Thu, 29 Aug 2019 21:51:32 +0000
Subject: Re: Bug report: KFIFO kfifo_init() may introduce buffer overflow
Message-Id: <20190829215131.GA2404@brain-police>
List-Id: <target-devel.vger.kernel.org>
References: <20190722114700.GE3089@kadam>
In-Reply-To: <20190722114700.GE3089@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On Thu, Aug 29, 2019 at 01:00:21PM -0700, Linus Torvalds wrote:
> [ at the dentist, sorry for mobile html gunk ]
>=20
> On Thu, Aug 29, 2019, 12:42 Kees Cook <keescook@chromium.org> wrote:
>=20
>     On Thu,=A0
>=20
>     I don't know this code at all, but note below...
>=20
>     > +=A0 =A0 =A0__kfifo->mask =3D __KFIFO_MASK_SIZE(fifo); \
>=20
>     I think this should be:
>=20
>     +=A0 =A0 =A0 =A0__kfifo->mask =3D __KFIFO_MASK_SIZE(*__tmp); \
>=20
>     ?=A0
>=20
>=20
> If it matters, we're in deep doo-doo. It only uses the type of the thing,=
 not
> the value, so it's immaterial. I think it's easier to use the original ty=
pe
> rather than the temporary that we created using it..
>=20
> But that's the least of my worries in that code.

If it makes you feel any better [perhaps as a distraction from the dreaded
dentist], the memory ordering side of things is suspicious as well:

https://lore.kernel.org/lkml/CAGXu5jKkqf-9ksvNTCS5xgB_JtfvCc=3DEot2uWYYP8rp=
oKLw=3Dmg@mail.gmail.com/

When I started pulling on it, it all fell apart, so I haven't had a
chance to do a proper set of fixes.

Will
