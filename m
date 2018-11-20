From: David Disseldorp <ddiss@suse.de>
Date: Tue, 20 Nov 2018 18:31:13 +0000
Subject: Re: SPC-3 persistent reservations race condition
Message-Id: <20181120193113.4959ad61@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
In-Reply-To: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Martin,

On Tue, 13 Nov 2018 16:17:36 +0100, Martin Svec wrote:

> Hello,
> 
> during Hyper-V Cluster Validation tests, we hit a bug in SPC-3 persistent reservations
> implementation where LIO iSCSI target started to loop indefinitely while freeing
> a PR registration.

Any chance you could capture and share a network trace for the specific
test that triggers the deadlock. Having something to turn into a
libiscsi regression test would be helpful here.

Cheers, David
