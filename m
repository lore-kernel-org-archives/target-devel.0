From: David Disseldorp <ddiss@suse.de>
Date: Tue, 30 Oct 2018 14:07:12 +0000
Subject: Re: [PATCH v3] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <20181030150712.5779ad83@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180625185658.31141-1-ddiss@suse.de>
In-Reply-To: <20180625185658.31141-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Mike,

On Thu, 28 Jun 2018 14:34:38 -0500, Mike Christie wrote:

> On 06/28/2018 09:48 AM, David Disseldorp wrote:
...
> > So how should we proceed here? Separate emulate_pr and pgr_support
> > interfaces would imply that this change could go in as-is, while a
> > multi-state interface would probably require more thought.
> >   
> 
> I think separate is going to be easier.
...
> If we do multiple files then emulate_pr is very clear what is meant
> across all backends and works like other device attributes.

I think we reached consensus here, but I don't have any acks for this
patch so will rebase against current mainline and resend.

Cheers, David
