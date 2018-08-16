From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Thu, 16 Aug 2018 12:11:16 +0000
Subject: Re: iscsi target: Let initiator decide whether it wants to authenticate target
Message-Id: <20180816121116.130cc7ce@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <97479a0ccf17d8ad7a8ba7a0f7e8190da6ddc72e.1534334933.git.plr.vincent@gmail.com>
In-Reply-To: <97479a0ccf17d8ad7a8ba7a0f7e8190da6ddc72e.1534334933.git.plr.vincent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 16 Aug 2018 00:00:35 -0500, Mike Christie <mchristi@redhat.com>
wrote:
> I just worry some users have set this and expect the extra layer of
> checks.

Now that you mention it, it is very possible indeed. The original code
could help spot an initiator misconfiguration.

> I can see how it is more convenient though. I think this is
> something I really am not sure about because I have not worked on the
> code for a long time. It is better if Nick were around.

FWIW, I do not have a noteworthy use-case behind this - I merely have a
home NAS with 2 LUNs exported. It is rather from a "I just noticed this
going over the code and the RFC does not seem to require this" and a "I
guess this confused/will confuse someone trying it out" point of view.

> I saw some targets/initiators allow you to configure this type of thing
> as optional where in that mode it works like in your patch. What about that?

That would indeed be nicer than my patch. And then it can remain
enforced by default.

> I guess you can wait for other reviewers or maybe some distro packagers
> to chime in too.

I certainly can wait, yes. No worries.
-- 
Vincent Pelletier
