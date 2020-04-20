From: Zzy Wysm <zzy@zzywysm.com>
Date: Mon, 20 Apr 2020 19:58:31 +0000
Subject: Re: [PATCH 2/9] fix empty-body warning in posix_acl.c
Message-Id: <F8B969BE-A2B1-4E6D-8746-BBFBE6399328@zzywysm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-3-rdunlap@infradead.org>
 <CAHk-=wjSzuTyyBkmMDG4fx_sXzLJsh+9Xk-ubgbpJzJq_kzPsA@mail.gmail.com>
In-Reply-To: <CAHk-=wjSzuTyyBkmMDG4fx_sXzLJsh+9Xk-ubgbpJzJq_kzPsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1250"
Content-Transfer-Encoding: base64
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel <target-devel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vishal Verma <vishal.l.verma@intel.com>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "open list:NFS, SUNRPC,
 AND..." <linux-nfs@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Johannes Berg <johannes@sipsolutions.net>

Cj4gT24gQXByIDE4LCAyMDIwLCBhdCAxOjUzIFBNLCBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNA
bGludXgtZm91bmRhdGlvbi5vcmc+IHdyb3RlOgo+IAo+IFRoaXJkbHksIHRoZXJlJ3MgYSAqcmVh
c29uKiB3aHkgIi1XZXh0cmEiIGlzbid0IHVzZWQuCj4gCj4gVGhlIHdhcm5pbmdzIGVuYWJsZWQg
YnkgLVdleHRyYSBhcmUgdXN1YWxseSBjb21wbGV0ZSBnYXJiYWdlLCBhbmQKPiB0cnlpbmcgdG8g
Zml4IHRoZW0gb2Z0ZW4gbWFrZXMgdGhlIGNvZGUgd29yc2UuIEV4YWN0bHkgbGlrZSBoZXJlLgo+
IAoKQXMgdGhlIGluc3RpZ2F0b3Igb2YgdGhpcyB3YXJuaW5nIGNsZWFudXAgYWN0aXZpdHksIGV2
ZW4gX0lfIGRvbuKAmXQgcmVjb21tZW5kCmJ1aWxkaW5nIHdpdGggYWxsIG9mIC1XZXh0cmEuICBE
b2luZyBzbyBvbiBhbiBhbGxtb2Rjb25maWcgYnVpbGQgZ2VuZXJhdGVzIAo1MDAgbWVnYWJ5dGVz
IG9mIHdhcm5pbmcgdGV4dCAobm90IGV4YWdnZXJhdGluZyksIHByaW1hcmlseSBkdWUgdG8gCi1X
dW51c2VkLXBhcmFtZXRlciBhbmQgV21pc3NpbmctZmllbGQtaW5pdGlhbGl6ZXJzLgoKSSBzdHJv
bmdseSByZWNvbW1lbmQgZGlzYWJsaW5nIHRoZW0gd2l0aCAtV25vLXVudXNlZC1wYXJhbWV0ZXIg
Ci1Xbm8tbWlzc2luZy1maWVsZC1pbml0aWFsaXplcnMgc2luY2UgdGhlIHNwZXcgaXMgY29tcGxl
dGVseSB1bmFjdGlvbmFibGUuCgpPbiB0aGUgb3RoZXIgaGFuZCwgLVdvdmVycmlkZS1pbml0IGZv
dW5kIGEgbGVnaXQgYnVnIHRoYXQgd2FzIGJyZWFraW5nIERWRApkcml2ZXMsIGZpeGVkIGluIGNv
bW1pdCAwMzI2NGRkZGUyNDUzZjY4NzdhN2Q2MzdkODQwNjgwNzk2MzJhM2M1LgoKSSBiZWxpZXZl
IGZpbmRpbmcgYSBnb29kIHNldCBvZiBjb21waWxlciB3YXJuaW5nIHNldHRpbmdzIGNhbiBsZWFk
IHRvIGxvdHMgb2YgCmdvb2QgYnVncyBiZWluZyBzcG90dGVkIGFuZCAoaG9wZWZ1bGx5KSBmaXhl
ZC4gIFdoeSBsZXQgc3l6Ym90IGRvIGFsbCB0aGUgd29yaz8KCnp6eQo=
