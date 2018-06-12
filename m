From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Tue, 12 Jun 2018 20:06:18 +0000
Subject: Re: [PATCH 0/3] Use sbitmap instead of percpu_ida
Message-Id: <27ef5cf260a14606df099ff112a7ab1b36b02395.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180612190545.10781-1-willy@infradead.org>
In-Reply-To: <20180612190545.10781-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>, "jgross@suse.com" <jgross@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

T24gVHVlLCAyMDE4LTA2LTEyIGF0IDEyOjA1IC0wNzAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gUmVtb3ZpbmcgdGhlIHBlcmNwdV9pZGEgY29kZSBuZXRzIG92ZXIgNDAwIGxpbmVzIG9mIHJl
bW92YWwuICBJdCdzIG5vdA0KPiBhcyBzcGVjdGFjdWxhciBhcyBkZWxldGluZyBhbiBlbnRpcmUg
YXJjaGl0ZWN0dXJlLCBidXQgaXQncyBzdGlsbCBhDQo+IHdvcnRoeSByZWR1Y3Rpb24gaW4gbGlu
ZXMgb2YgY29kZS4NCj4gDQo+IFVudGVzdGVkIGR1ZSB0byBsYWNrIG9mIGhhcmR3YXJlIGFuZCBu
b3QgdW5kZXJzdGFuZGluZyBob3cgdG8gc2V0IHVwIGENCj4gdGFyZ2V0IHBsYXRmb3JtLg0KPiAN
Cj4gQ2hhbmdlcyBmcm9tIHYxOg0KPiAgLSBGaXhlZCBidWdzIHBvaW50ZWQgb3V0IGJ5IEplbnMg
aW4gaXNjc2l0X3dhaXRfZm9yX3RhZygpDQo+ICAtIEFic3RyYWN0ZWQgb3V0IHRhZyBmcmVlaW5n
IGFzIHJlcXVlc3RlZCBieSBCYXJ0DQo+ICAtIE1hZGUgaXNjc2l0X3dhaXRfZm9yX3RhZyBzdGF0
aWMgYXMgcG9pbnRlZCBvdXQgYnkgMGRheQ0KDQpGb3IgdGhlIHdob2xlIHNlcmllczoNCg0KUmV2
aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAd2RjLmNvbT4NCg0KVGhh
bmtzLA0KDQpCYXJ0Lg0KDQoNCg0KDQo