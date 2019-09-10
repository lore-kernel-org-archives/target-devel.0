From: Maurizio Lombardi <mlombard@redhat.com>
Date: Tue, 10 Sep 2019 14:07:37 +0000
Subject: Re: [RFC PATCH 0/4] iscsi: chap: introduce support for SHA1 and SHA3-256
Message-Id: <78692dca-949b-dcf2-3b69-a1755956f216@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190829155929.27701-1-mlombard@redhat.com>
 <20190903070013.GA12256@infradead.org>
 <CE03DB3D7B45C245BCA0D24327794936306D540B@MX307CL04.corp.emc.com>
In-Reply-To: <CE03DB3D7B45C245BCA0D24327794936306D540B@MX307CL04.corp.emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Black, David" <David.Black@dell.com>, Christoph Hellwig <hch@infradead.org>
Cc: "cleech@redhat.com" <cleech@redhat.com>, "mchristi@redhat.com" <mchristi@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

Hello David,

first of all, thank for your reply and your offer to help with this.
We appreciate this a lot.


Dne 4.9.2019 v 01:59 Black, David napsal(a):
> Christoph,
> 
>> Adding Dave Black who has helped with IANA interaction in NVMe recently.
> 
> I see my cue ... please keep me cc:'d on this conversation, as I'm not on either of the mailing lists.
> 
>> But we'll need IANA assignments and IETF consensus before adding new
>> algorithms to ensure we have interoperable implementations.
> 
> In reverse order ...
> 
> -- IETF Consensus: 
> 
> My sense of the IETF view on secure hashes is that MD5 and SHA1 are broken, whereas the SHA2 algorithms are proving to be longer-lived (more resistant to attack) than expected, and the SHA3 algorithms are fine.
> 
> That suggests that registration of codepoints for both SHA2 and SHA3 would be a good thing to do, as opposed to only SHA3.  I'd suggest starting with either SHA-256 or SHA-512/256 (both are SHA2 hashes) in addition to SHA3-256, as all three have the same 256-bit output size.

Agree. Having SHA-256 would make sense.

> 
> Figuring out exactly what should be done here (e.g., which SHA2 variant to register) would benefit from some discussion at IETF.  I would start with the Security Area's saag@ietf.org mailing list.  In addition, as iSCSI falls within IETF's Transport Area, the Transport Area Directors ought to be looped in beforehand.  Fortunately, publication of an RFC is not necessary, because ...

Ok, I am going to send an email for the SAAG mailing list to see what they think about it.

> 
> -- IANA assignments
> 
> ... the Registration Procedure for PPP Authentication Algorithms is Expert Review.   The long version of what that means is in Section 4.5 of RFC 8126: https://tools.ietf.org/html/rfc8126#section-4.5.  The short version is that a request for allocation of these codepoints is submitted to IANA, whose designated expert then makes a decision.  It's probably a good idea for that request to state that the intended usage is iSCSI, and say that it's ok to restrict the resulting registrations solely to use by iSCSI.
> 
> As Christoph notes, I've helped with IANA interactions at NVMe, and would be likewise willing to help here.  My name is attached to the SHA1 registration, so it would make sense for me to ask for the SHA2 and SHA3 registrations, and I know a number of the people who will be involved in ensuring that the proverbial "right thing" happens, e.g., the Transport Area Directors.

Thank you very much for the help!
Maurizio Lombardi
