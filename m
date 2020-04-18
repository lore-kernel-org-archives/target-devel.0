From: Trond Myklebust <trondmy@hammerspace.com>
Date: Sat, 18 Apr 2020 22:28:26 +0000
Subject: Re: [PATCH 6/9] nfsd: fix empty-body warning in nfs4state.c
Message-Id: <d2e2f7967804446a825ec0ff61095e6640b5a968.camel@hammerspace.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-7-rdunlap@infradead.org>
 <CDCF7717-7CBC-47CA-9E83-3A18ECB3AB89@oracle.com>
In-Reply-To: <CDCF7717-7CBC-47CA-9E83-3A18ECB3AB89@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "rdunlap@infradead.org" <rdunlap@infradead.org>, "chuck.lever@oracle.com" <chuck.lever@oracle.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "zzy@zzywysm.com" <zzy@zzywysm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bfields@fieldses.org" <bfields@fieldses.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "dave.jiang@intel.com" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "johannes@sipsolutions.net" <johannes@sipsolutions.net>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>, "tiwai@suse.com" <tiwai@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>

T24gU2F0LCAyMDIwLTA0LTE4IGF0IDE0OjQ1IC0wNDAwLCBDaHVjayBMZXZlciB3cm90ZToNCj4g
PiBPbiBBcHIgMTgsIDIwMjAsIGF0IDI6NDEgUE0sIFJhbmR5IER1bmxhcCA8cmR1bmxhcEBpbmZy
YWRlYWQub3JnPg0KPiA+IHdyb3RlOg0KPiA+IA0KPiA+IEZpeCBnY2MgZW1wdHktYm9keSB3YXJu
aW5nIHdoZW4gLVdleHRyYSBpcyB1c2VkOg0KPiA+IA0KPiA+IC4uL2ZzL25mc2QvbmZzNHN0YXRl
LmM6Mzg5ODozOiB3YXJuaW5nOiBzdWdnZXN0IGJyYWNlcyBhcm91bmQgZW1wdHkNCj4gPiBib2R5
IGluIGFuIOKAmGVsc2XigJkgc3RhdGVtZW50IFstV2VtcHR5LWJvZHldDQo+ID4gDQo+ID4gU2ln
bmVkLW9mZi1ieTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQo+ID4gQ2M6
IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gPiBDYzog
QW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gPiBDYzogIkouIEJy
dWNlIEZpZWxkcyIgPGJmaWVsZHNAZmllbGRzZXMub3JnPg0KPiA+IENjOiBDaHVjayBMZXZlciA8
Y2h1Y2subGV2ZXJAb3JhY2xlLmNvbT4NCj4gPiBDYzogbGludXgtbmZzQHZnZXIua2VybmVsLm9y
Zw0KPiANCj4gSSBoYXZlIGEgcGF0Y2ggaW4gbXkgcXVldWUgdGhhdCBhZGRyZXNzZXMgdGhpcyBw
YXJ0aWN1bGFyIHdhcm5pbmcsDQo+IGJ1dCB5b3VyIGNoYW5nZSB3b3JrcyBmb3IgbWUgdG9vLg0K
PiANCj4gQWNrZWQtYnk6IENodWNrIExldmVyIDxjaHVjay5sZXZlckBvcmFjbGUuY29tPg0KPiAN
Cj4gVW5sZXNzIEJydWNlIG9iamVjdHMuDQo+IA0KPiANCj4gPiAtLS0NCj4gPiBmcy9uZnNkL25m
czRzdGF0ZS5jIHwgICAgMyArKy0NCj4gPiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gLS0tIGxpbnV4LW5leHQtMjAyMDA0MTcub3JpZy9m
cy9uZnNkL25mczRzdGF0ZS5jDQo+ID4gKysrIGxpbnV4LW5leHQtMjAyMDA0MTcvZnMvbmZzZC9u
ZnM0c3RhdGUuYw0KPiA+IEBAIC0zNCw2ICszNCw3IEBADQo+ID4gDQo+ID4gI2luY2x1ZGUgPGxp
bnV4L2ZpbGUuaD4NCj4gPiAjaW5jbHVkZSA8bGludXgvZnMuaD4NCj4gPiArI2luY2x1ZGUgPGxp
bnV4L2tlcm5lbC5oPg0KPiA+ICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+DQo+ID4gI2luY2x1ZGUg
PGxpbnV4L25hbWVpLmg+DQo+ID4gI2luY2x1ZGUgPGxpbnV4L3N3YXAuaD4NCj4gPiBAQCAtMzg5
NSw3ICszODk2LDcgQEAgbmZzZDRfc2V0Y2xpZW50aWQoc3RydWN0IHN2Y19ycXN0ICpycXN0cA0K
PiA+IAkJY29weV9jbGlkKG5ldywgY29uZik7DQo+ID4gCQlnZW5fY29uZmlybShuZXcsIG5uKTsN
Cj4gPiAJfSBlbHNlIC8qIGNhc2UgNCAobmV3IGNsaWVudCkgb3IgY2FzZXMgMiwgMyAoY2xpZW50
IHJlYm9vdCk6ICovDQo+ID4gLQkJOw0KPiA+ICsJCWRvX2VtcHR5KCk7DQoNClVyZ2guLi4gVGhp
cyBpcyBqdXN0IGZvciBkb2N1bWVudGF0aW9uIHB1cnBvc2VzIGFueXdheSwgc28gd2h5IG5vdCBq
dXN0DQp0dXJuIGl0IGFsbCBpbnRvIGEgY29tbWVudCBieSBtb3ZpbmcgdGhlICdlbHNlJyBpbnRv
IHRoZSBjb21tZW50IGZpZWxkPw0KDQppLmUuDQoJfSAvKiBlbHNlIGNhc2UgNCAoLi4uLiAqLw0K
DQoJbmV3LT5jbF9taW5vcnZlcnNpb24gPSAwOw0KPiA+IAlnZW5fY2FsbGJhY2sobmV3LCBzZXRj
bGlkLCBycXN0cCk7DQo+ID4gCWFkZF90b191bmNvbmZpcm1lZChuZXcpOw0KPiANCj4gLS0NCj4g
Q2h1Y2sgTGV2ZXINCj4gDQo+IA0KDQotLSANClRyb25kIE15a2xlYnVzdA0KTGludXggTkZTIGNs
aWVudCBtYWludGFpbmVyLCBIYW1tZXJzcGFjZQ0KdHJvbmQubXlrbGVidXN0QGhhbW1lcnNwYWNl
LmNvbQ0KDQoNCg=
