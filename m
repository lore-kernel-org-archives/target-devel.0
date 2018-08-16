From: Mike Christie <mchristi@redhat.com>
Date: Thu, 16 Aug 2018 05:00:35 +0000
Subject: Re: iscsi target: Let initiator decide whether it wants to authenticate target
Message-Id: <5B7504F3.1000903@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <97479a0ccf17d8ad7a8ba7a0f7e8190da6ddc72e.1534334933.git.plr.vincent@gmail.com>
In-Reply-To: <97479a0ccf17d8ad7a8ba7a0f7e8190da6ddc72e.1534334933.git.plr.vincent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/15/2018 07:08 AM, Vincent Pelletier wrote:
> Do not fail authentication after target is happy with initiator's
> credentials, when target is configured to authenticate itself to an
> initiator but current initiator did not provide required values.
> Also, downgrade "Could not find CHAP_I." to a debug level message, as it
> will happen normally in such case.
> 

I just worry some users have set this and expect the extra layer of
checks. I can see how it is more convenient though. I think this is
something I really am not sure about because I have not worked on the
code for a long time. It is better if Nick were around.

I saw some targets/initiators allow you to configure this type of thing
as optional where in that mode it works like in your patch. What about that?

I guess you can wait for other reviewers or maybe some distro packagers
to chime in too.
