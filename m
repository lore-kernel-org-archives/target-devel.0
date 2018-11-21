From: David Disseldorp <ddiss@suse.de>
Date: Wed, 21 Nov 2018 13:33:25 +0000
Subject: Re: SPC-3 persistent reservations race condition
Message-Id: <20181121143325.252a4895@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
In-Reply-To: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 21 Nov 2018 14:16:05 +0100, Martin Svec wrote:

> >> during Hyper-V Cluster Validation tests, we hit a bug in SPC-3 persistent reservations
> >> implementation where LIO iSCSI target started to loop indefinitely while freeing
> >> a PR registration.  
> > Any chance you could capture and share a network trace for the specific
> > test that triggers the deadlock. Having something to turn into a
> > libiscsi regression test would be helpful here.  
> 
> Thanks for your response, I'll try to capture it tomorrow. Also, the target has two multipathed NPs
> now, so I can try to utilize only one to see if it makes a difference.

Thanks.
FWIW, given your preliminary analysis it looks as though concurrent MPIO
PR requests will be needed to trigger the race.

Cheers, David
