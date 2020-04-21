From: NeilBrown <neilb@suse.de>
Date: Tue, 21 Apr 2020 01:20:53 +0000
Subject: Re: [PATCH 5/9] usb: fix empty-body warning in sysfs.c
Message-Id: <87368xskga.fsf@notabene.neil.brown.name>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: <target-devel.vger.kernel.org>
References: <Pine.LNX.4.44L0.2004181549020.8036-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.2004181549020.8036-100000@netrider.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>, Matthew Wilcox <willy@infradead.org>
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Zzy Wysm <zzy@zzywysm.com>, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18 2020, Alan Stern wrote:

> On Sat, 18 Apr 2020, Matthew Wilcox wrote:
>
>> On Sat, Apr 18, 2020 at 11:41:07AM -0700, Randy Dunlap wrote:
>> > +++ linux-next-20200327/drivers/usb/core/sysfs.c
>> > @@ -1263,7 +1263,7 @@ void usb_create_sysfs_intf_files(struct
>> >  	if (!alt->string && !(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
>> >  		alt->string =3D usb_cache_string(udev, alt->desc.iInterface);
>> >  	if (alt->string && device_create_file(&intf->dev, &dev_attr_interfac=
e))
>> > -		;	/* We don't actually care if the function fails. */
>> > +		do_empty(); /* We don't actually care if the function fails. */
>> >  	intf->sysfs_files_created =3D 1;
>> >  }
>>=20
>> Why not just?
>>=20
>> +	if (alt->string)
>> +		device_create_file(&intf->dev, &dev_attr_interface);
>
> This is another __must_check function call.
>
> The reason we don't care if the call fails is because the file
> being created holds the USB interface string descriptor, something
> which is purely informational and hardly ever gets set (and no doubt
> gets used even less often).
>
> Is this another situation where the comment should be expanded and the=20
> code modified to include a useless test and cast-to-void?
>
> Or should device_create_file() not be __must_check after all?

One approach to dealing with __must_check function that you don't want
to check is to cause failure to call
   pr_debug("usb: interface descriptor file not created");
or similar.  It silences the compiler, serves as documentation, and
creates a message that is almost certainly never seen.

This is what I did in drivers/md/md.c...

	if (mddev->kobj.sd &&
	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
		pr_debug("pointless warning\n");

(I give better warnings elsewhere - I must have run out of patience by
 this point).

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl6eSnUACgkQOeye3VZi
gbn4EQ//WLEH1OYjzYF3ZAV16KgjXghaIeaNMOhGWUi79iqI/c9Zfe7VUDBPE5ip
xTdZh+pKAubrzHjja6sbwXCEpY1XaGBeyKxl8lc/w8bsG6yMdN0n3eP7jgMucCtN
U7DuAjjSjFvMLYDUBs6jhPbko+Qse3InDgyZH0gTueYI1QMmSag7EZs0xdvv6dAz
NgtTQbJ7MBv3CQTg3Y+O6pMvRQbwSYuUb118jv9BH5ktkRmfJ5lP0LGfDD1d/AeR
Z9oH8asOZK2ZprUXg6cuI/lf1kxFCNDGwXI9x0eDWpyt8akceeXLsxhg7Jw2KlZA
Ry4UOB//Ehxq5ZtqxQAcHNzbfXJM1JaZjbyk+Im8F3q0/i2aE2/9pGvREe91rX3u
gq2UO+5djv+TxKg1nZcFIHV/ycfdw4HWT6jKnYwOTahceJxkcswrRYqWBDePNqws
oeWTPfUxQIIMUAYl0Zsf8EXLCqKvOmVqRI3cY2jIZHOJraynmtfL+/FRsg3PNu5T
m5nSJbLvQMzITNuBTOf8BvdeAasCfR6v4RlIJYbonBJxXtUrXL7yeX0FclVpJ98+
noaE1F/eUxnG5t+n3Gr6C9ttT/avXsr7Gm7okuNwkY1vvZSoXbFPZG0VIW0SiLWY
kiqSFLeEDXCaNk4yYZlcNe17qTuJiZxx4RnTkF1IykZIcQv8haE=
=K7Ae
-----END PGP SIGNATURE-----
--=-=-=--
