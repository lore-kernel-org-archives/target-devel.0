From: David Disseldorp <ddiss@suse.de>
Date: Fri, 16 Nov 2018 14:59:18 +0000
Subject: Re: [RFC PATCH 0/3] target: remove some unused stats
Message-Id: <20181116155918.0780cd7f@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181017154820.9722-1-ddiss@suse.de>
In-Reply-To: <20181017154820.9722-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Mike

On Tue, 30 Oct 2018 10:54:07 -0500, Mike Christie wrote:

> >> This patchset removes a couple of unused error stat counters and a
> >> redundant cumulative counter.
> >> I've tagged this patchset RFC, as it may be considered a kernel<->user
> >> (configfs) API change.  
> > 
> > Ping, any thoughts on this patchset?
> >   
> 
> I think these stats were supposed to match the iSCSI MIB definitions. It
> was not clear why we didn't just fix them so they report the correct values?

I finally got a chance to look through rfc#4544. It does indeed look
like these counters correspond to:
IscsiInstanceSsnErrorStatsEntry ::= SEQUENCE {
    iscsiInstSsnDigestErrors       Counter32,
    iscsiInstSsnCxnTimeoutErrors   Counter32,
    iscsiInstSsnFormatErrors       Counter32
}

There doesn't appear to be anything stopping us from plumbing them into
the corresponding error paths, so I'll withdraw this patchset.

Cheers, David
