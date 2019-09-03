From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 03 Sep 2019 07:00:13 +0000
Subject: Re: [RFC PATCH 0/4] iscsi: chap: introduce support for SHA1 and SHA3-256
Message-Id: <20190903070013.GA12256@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190829155929.27701-1-mlombard@redhat.com>
In-Reply-To: <20190829155929.27701-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: cleech@redhat.com, mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Black, David" <David.Black@dell.com>

On Thu, Aug 29, 2019 at 05:59:25PM +0200, Maurizio Lombardi wrote:
> iSCSI with the Challenge-Handshake Authentication Protocol is not FIPS compliant.
> This is due to the fact that CHAP currently uses MD5 as the only supported
> digest algorithm and MD5 is not allowed by FIPS.
> 
> When FIPS mode is enabled on the target server, the CHAP authentication
> won't work because the target driver will be prevented from using the MD5 module.
> 
> Given that CHAP is agnostic regarding the algorithm it uses, this
> patchset introduce support for two new alternatives: SHA1 and SHA3-256.
> 
> SHA1 has already its own assigned value for its use in CHAP, as reported by IANA:
> https://www.iana.org/assignments/ppp-numbers/ppp-numbers.xml#ppp-numbers-9
> On the other hand the use of SHA1 on FIPS-enabled systems has been deprecated
> and therefore it's not a vialable long term option.
> 
> We could consider introducing a more modern hash algorithm like SHA3-256, as
> this patchset does.

But we'll need IANA assignments and IETF consensus before adding new
algorithms to ensure we have interoperable implementations.

Adding Dave Black who has helped with IANA interaction in NVMe recently.
