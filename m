From: "Ly, Bryant" <bly@catalogicsoftware.com>
Date: Tue, 16 Oct 2018 14:37:58 +0000
Subject: Re: [PATCH 2/2] target: Fix target_wait_for_sess_cmds breakage with active signals
Message-Id: <01F789A9-AF3F-4226-B9D1-9BB160AC4947@catalogicsoftware.com>
List-Id: <target-devel.vger.kernel.org>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
 <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
 <5BBE2FBF.7080804@redhat.com>
 <1539237365.6150.32.camel@haakon3.daterainc.com>
 <F43269BA-4D7B-486C-87C6-0FB48FF890EA@catalogicsoftware.com>
 <yq1lg6yv899.fsf@oracle.com>
In-Reply-To: <yq1lg6yv899.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Bart Van Assche <bvanassche@acm.org>

TWFydGluLCANCg0KPiBPbiBPY3QgMTUsIDIwMTgsIGF0IDExOjEzIFBNLCBNYXJ0aW4gSy4gUGV0
ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+IA0KPiBCcnlh
bnQsDQo+IA0KPj4gVk1zIGRvIG5vdCByZW1vdmUgdGhlIElfVCBuZXh1cyB3aGlsZSB0aGUgVk0g
aXMgYWN0aXZlLCBzbyB3ZSBjYW4gcmVtb3ZlDQo+PiB0aGUgdGFyZ2V0X3dhaXRfZm9yX3Nlc3Nf
Y21kKCkgY2FsbC4gDQo+IA0KPiBQYXRjaCBmb3J0aGNvbWluZz8NCg0KSSBjYW4gcHV0IG91dCBh
IHBhdGNoLCBJ4oCZbSB0cnlpbmcgdG8gZ2V0IHNvbWVvbmUgYXQgSUJNIHRvIHRlc3QgaXQgdGhv
dWdoLg0KDQotQnJ5YW50
