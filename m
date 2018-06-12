From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Tue, 12 Jun 2018 15:22:42 +0000
Subject: Re: [PATCH 1/2] Convert target drivers to use sbitmap
Message-Id: <da5220a5ed4bed210c31a7517389e787a3b1a01f.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180515160043.27044-1-willy@infradead.org>
	<20180515160043.27044-2-willy@infradead.org>
In-Reply-To: <20180515160043.27044-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>, "jgross@suse.com" <jgross@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "mawilcox@microsoft.com" <mawilcox@microsoft.com>

T24gVHVlLCAyMDE4LTA1LTE1IGF0IDA5OjAwIC0wNzAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYyBiL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYw0KPiBpbmRleCAwMjVkYzJkM2YzZGUuLmNkZjY3
MWMyYWY2MSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5j
DQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYw0KPiBAQCAtMzcxOSw3
ICszNzE5LDggQEAgdm9pZCBxbHRfZnJlZV9jbWQoc3RydWN0IHFsYV90Z3RfY21kICpjbWQpDQo+
ICAJCXJldHVybjsNCj4gIAl9DQo+ICAJY21kLT5qaWZmaWVzX2F0X2ZyZWUgPSBnZXRfamlmZmll
c182NCgpOw0KPiAtCXBlcmNwdV9pZGFfZnJlZSgmc2Vzcy0+c2Vfc2Vzcy0+c2Vzc190YWdfcG9v
bCwgY21kLT5zZV9jbWQubWFwX3RhZyk7DQo+ICsJc2JpdG1hcF9xdWV1ZV9jbGVhcigmc2Vzcy0+
c2Vfc2Vzcy0+c2Vzc190YWdfcG9vbCwgY21kLT5zZV9jbWQubWFwX3RhZywNCj4gKwkJCWNtZC0+
c2VfY21kLm1hcF9jcHUpOw0KPiAgfQ0KPiAgRVhQT1JUX1NZTUJPTChxbHRfZnJlZV9jbWQpOw0K
DQpQbGVhc2UgaW50cm9kdWNlIGZ1bmN0aW9ucyBpbiB0aGUgdGFyZ2V0IGNvcmUgZm9yIGFsbG9j
YXRpbmcgYW5kIGZyZWVpbmcgYSB0YWcNCmluc3RlYWQgb2Ygc3ByZWFkaW5nIHRoZSBrbm93bGVk
Z2Ugb2YgaG93IHRvIGFsbG9jYXRlIGFuZCBmcmVlIHRhZ3Mgb3ZlciBhbGwNCnRhcmdldCBkcml2
ZXJzLg0KIA0KPiAraW50IGlzY3NpdF93YWl0X2Zvcl90YWcoc3RydWN0IHNlX3Nlc3Npb24gKnNl
X3Nlc3MsIGludCBzdGF0ZSwgaW50ICpjcHVwKQ0KPiArew0KPiArCWludCB0YWcgPSAtMTsNCj4g
KwlERUZJTkVfV0FJVCh3YWl0KTsNCj4gKwlzdHJ1Y3Qgc2JxX3dhaXRfc3RhdGUgKndzOw0KPiAr
DQo+ICsJaWYgKHN0YXRlID09IFRBU0tfUlVOTklORykNCj4gKwkJcmV0dXJuIHRhZzsNCj4gKw0K
PiArCXdzID0gJnNlX3Nlc3MtPnNlc3NfdGFnX3Bvb2wud3NbMF07DQo+ICsJZm9yICg7Oykgew0K
PiArCQlwcmVwYXJlX3RvX3dhaXRfZXhjbHVzaXZlKCZ3cy0+d2FpdCwgJndhaXQsIHN0YXRlKTsN
Cj4gKwkJaWYgKHNpZ25hbF9wZW5kaW5nX3N0YXRlKHN0YXRlLCBjdXJyZW50KSkNCj4gKwkJCWJy
ZWFrOw0KDQpUaGlzIGxvb2tzIHdlaXJkIHRvIG1lLiBTaG91bGRuJ3QgdGFyZ2V0IGNvZGUgaWdu
b3JlIHNpZ25hbHMgaW5zdGVhZCBvZiBjYXVzaW5nDQp0YWcgYWxsb2NhdGlvbiB0byBmYWlsIGlm
IGEgc2lnbmFsIGlzIHJlY2VpdmVkPw0KDQo+ICsJCXNjaGVkdWxlKCk7DQo+ICsJCXRhZyA9IHNi
aXRtYXBfcXVldWVfZ2V0KCZzZV9zZXNzLT5zZXNzX3RhZ19wb29sLCBjcHVwKTsNCj4gKwl9DQo+
ICsNCj4gKwlmaW5pc2hfd2FpdCgmd3MtPndhaXQsICZ3YWl0KTsNCj4gKwlyZXR1cm4gdGFnOw0K
PiArfQ0KDQpUaGFua3MsDQoNCkJhcnQuDQoNCg0KDQo