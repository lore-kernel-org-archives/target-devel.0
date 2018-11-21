From: Martin Svec <martin.svec@zoner.cz>
Date: Wed, 21 Nov 2018 13:16:05 +0000
Subject: Re: SPC-3 persistent reservations race condition
Message-Id: <96d98aa0-441d-bf2a-d7fd-d1c99b3b46a0@zoner.cz>
List-Id: <target-devel.vger.kernel.org>
References: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
In-Reply-To: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi David,

Dne 20.11.2018 v 19:31 David Disseldorp napsal(a):
> Hi Martin,
>
> On Tue, 13 Nov 2018 16:17:36 +0100, Martin Svec wrote:
>
>> Hello,
>>
>> during Hyper-V Cluster Validation tests, we hit a bug in SPC-3 persistent reservations
>> implementation where LIO iSCSI target started to loop indefinitely while freeing
>> a PR registration.
> Any chance you could capture and share a network trace for the specific
> test that triggers the deadlock. Having something to turn into a
> libiscsi regression test would be helpful here.

Thanks for your response, I'll try to capture it tomorrow. Also, the target has two multipathed NPs
now, so I can try to utilize only one to see if it makes a difference.

Martin
