From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 07 Mar 2018 16:23:39 +0000
Subject: Re: [PATCH 6/6] lib/scatterlist: Drop order argument from sgl_free_n_order
Message-Id: <1520439817.2890.21.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180307124712.14963-1-tvrtko.ursulin@linux.intel.com>
         <20180307124712.14963-7-tvrtko.ursulin@linux.intel.com>
In-Reply-To: <20180307124712.14963-7-tvrtko.ursulin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tursulin@ursulin.net" <tursulin@ursulin.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tvrtko.ursulin@intel.com" <tvrtko.ursulin@intel.com>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>

T24gV2VkLCAyMDE4LTAzLTA3IGF0IDEyOjQ3ICswMDAwLCBUdnJ0a28gVXJzdWxpbiB3cm90ZToN
Cj4gV2UgY2FuIGRlcml2ZSB0aGUgb3JkZXIgZnJvbSBzZy0+bGVuZ3RoIGFuZCBzbyBkbyBub3Qg
bmVlZCB0byBwYXNzIGl0IGluDQo+IGV4cGxpY2l0bHkuIFJlbmFtZSB0aGUgZnVuY3Rpb24gdG8g
c2dsX2ZyZWVfbi4NCg0KVXNpbmcgZ2V0X29yZGVyKCkgdG8gY29tcHV0ZSB0aGUgb3JkZXIgbG9v
a3MgZmluZSB0byBtZSBidXQgdGhpcyBwYXRjaCB3aWxsDQpoYXZlIHRvIHJlYmFzZWQgaW4gb3Jk
ZXIgdG8gYWRkcmVzcyB0aGUgY29tbWVudHMgb24gdGhlIHByZXZpb3VzIHBhdGNoZXMuDQoNClRo
YW5rcywNCg0KQmFydC4NCg0KDQo