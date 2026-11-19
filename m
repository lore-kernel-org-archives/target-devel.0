Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054574;
	b=bY0yt4/JBw6qL2XV1ODTY+5GqgZbg+whvY4ZCR5Hx81GO2NxfbDmTOxtHkTa8mdoMJ6p
	 VFbrVq3Pf4R80ryjOPNrG+QuV45aWwFmuy/w7i5pVTP2DA+yRJsfKtx+43Yqjrq+mDJxE
	 PgyOe5FSyT1IsJCpnGSaOBnkBkR0xyaRr48u7Saus5ueDliysL3/9PMhxWGNSZWqNaQPM
	 mtPDUFl3MW978AH55o7XduW9Te73lZSe1oLh5WJOKjT2aDRs/VOqfPgfi+YQ2pWSqEFme
	 g+2SChfRkNYjtXczm45HBP593K3w0L+HP5Gvp/27SaerzKYJwmpNlBgJsYmKtE7VO2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054574;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=VN0dkAoykjpPyuXs8qS8ALX3/rfMgri8haILYEWluaw=;
	b=cSLf+6tXBSk+qi2b3ajhmCt0N64URfKWzOFaoSCqDjBfgU046xkH1N3e7KsuxAMbeoGS
	 8rxYT6mWsVhkA8fsi0/nu6LM03Tpq6vd2Fnt4VZK6DraLaQy+VRzBio5elqY1fvUB4rEJ
	 gesF7veG5N5HIhlPCAdFYkoNkkiXfv0ggcodT1572atHseIaQw1YAeFBk6JXw0eMF/6X0
	 Dm3despcCcK0IAMMYeHkI6jipchAa8QS5xHO5Jc43eKck9kaBZIaUKq5qNVK+u5428hHV
	 aFN/eHIQmKovh+7lTNSy3GYdSzD4Ap3IClPgLzralsFrNyfSAsXwk3Vway6pE+z3N2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rTGmxNs+;
	arc=none smtp.remote-ip=209.85.210.47
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE7606A332
	for <target-devel@vger.kernel.org>; Thu, 19 Nov 2026 02:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20EE7606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rTGmxNs+
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-862b090e41eso967470a34.0
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 18:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795054572; x=1795659372; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VN0dkAoykjpPyuXs8qS8ALX3/rfMgri8haILYEWluaw=;
        b=rTGmxNs+0ILYq2XHdDrlH1Nkd5KHtMjwlR66OuAL+lH5PU9S0/x2NgCntviKsZ+j4/
         tRa+nuHv5ukymPSxI9cOYttkr6QeXyu1EDW7Q1yhS76Y9SpjnjQ1xQlA24qWVNnCMJsX
         jIDWRZ4me9hfwK1xKzYUJ2LtOPvjIaqap5jyVCg19LEXBNfWoQQBt+efsm3M1iqINyY4
         3MwOlZqamsbQ5iX9f+bsmqgLDfhJnpetmhU86a9hBYVyoitREF5683L5DHtSoBx0rB5V
         K2I8VYrPRrqIrkznnQ6e3oYuq+T5HeyKSxavkZalmHI4TM/k8GOWYC6UJiBQ3dZus4IP
         7TTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795054572; x=1795659372;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VN0dkAoykjpPyuXs8qS8ALX3/rfMgri8haILYEWluaw=;
        b=s+du3+3agmis/epPZgT3njuA32I4i1/tpqOvpITzwqifb3rzflV6kaTHZERrAhQZo0
         RIJjR/GvYLkzkuZ5Jm2tqZX9N59JFRq0pnklKwN+5ejW/ouFb6K0nU6Dad0SmybeTvDV
         O/gEOiIIEoz5XYBh3wNCUadly9kD+Zelwm1qtBuU7AjwJUnskvlKAD0RmD4B/46bPZUT
         SLjmhat7jYmdcoomlcas+cowPH9EfsdEgdvKz8ifwAJMp9P3rIVwcLMgJJM3tNmXeKqg
         sYq+F4ZHSL7bH5X+tq8vgqLsvaerF4BkNrtp35V8HXzgtwPqemTrm0D44jLsW9VyfMkA
         LJJg==
X-Forwarded-Encrypted: i=1; AL+hErF9a4qitYvTn9SUsY/JBPubfkOHze39b3FLkIGlaKwFRzXpuzlbXT9hKXN5rJaHUIFuGzHfaEf+4FJIf2M=@vger.kernel.org
X-Gm-Message-State: APuU4Z8KYjhKB3LkBzIfEPVlvkwjMqyn0xyaRVqPQ1F2Mln8+yzY2naA
	OwW+1kJYM0Jo17rHd0DxlgipMVaYse/vzH9RSpZnHsURCbjP6EO7MZzE
X-Gm-Gg: AYBFou2XbyZ50LPptufAowhJCTQhq0HTQgNLMqKLryA/QDB1+z8zW+zu0vWgcJIs2VT
	+5+ZQh1y688BgPMpmQyH0JvGoRMGHnASgKMDDEgzsffcYaupAO5a/liqzXqFvmTj0EY6646tFfd
	3naeKp2Wh9mg4qIlxWxEp/pbcfUifiZ9DDI8V6wwZN+uoCKdpwXg7MdplxwDyGSp+kxD/F4Ovd7
	p4tlQ5UUMzapG54JNzzFFxDNQ6cEEakiUlVpVCoJb/ylmOsozg/vvCBMvK8yZcfLPX5yylaJfuf
	Rn0PHRnqjjVyJLxUMhiFfBxUbLvIZUm6EalKTesyvyYAMunN5iPGLrhJkjPZO0DDJ0kg9X5c53c
	xC31+O/oNMCky539TdjulYP7lwbm2wgdiDCtU+F9irQrQ+Zssp4riTyc7bkPPpJX5DIQPJupteJ
	VPPNfKjoi2Qd7dRCUJ83LsUmH1Stp2TkF3zVF5D6flswGQ4wXxE8R1BgZZq4uSnvlF3fHnlN76C
	Ev2BgzlXs2TifGR9jyY2up/NlDPE4bT87dW203YnomZnChS+fCJBPX4cqfU73jtcij3hIAAbbdV
	aCLekWNWb8EFsQCNYDyKDKpBrYmuLMZFhq8RODN0BfJhN0elyfAKPUwoZoaY/9nTc4IGJkbZ2ri
	sfBmL0PHaC83zxZAO8iUKZHxPPm9XwyHXfFyaP+0gOU5wuTSDO6RHWQ==
X-Received: by 2002:a05:6830:310b:b0:862:cbe7:668d with SMTP id 46e09a7af769-862f082c9c5mr5695809a34.2.1795054571925;
        Wed, 18 Nov 2026 18:16:11 -0800 (PST)
Received: from fedora-laptop ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862f021298dsm3474480a34.16.2026.11.18.18.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 18:16:11 -0800 (PST)
Date: Wed, 18 Nov 2026 20:16:03 -0600
From: Ming Lei <tom.leiming@gmail.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Mike Christie <michael.christie@oracle.com>,
	Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH RFC 00/18] scsi: target: Add target_core_uring, an
 io_uring based user backstore
Message-ID: <av5b4-b48QNzzyxz@fedora-laptop>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <avprIhtn1TuYLX1b@fedora-laptop>
 <20261117024640.3184554-1-qiliang.yuan@linux.dev>
 <av0CAptnbIZP-53U@fedora-laptop>
 <20261119010233.2917434-1-qiliang.yuan@linux.dev>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119010233.2917434-1-qiliang.yuan@linux.dev>

On Wed, Nov 18, 2026 at 08:02:33PM -0500, Qiliang Yuan wrote:
> On Tue, Nov 17, 2026 at 07:40:18PM -0600, Ming Lei wrote:
> > Can you share your setup? It is supposed that you run fio from VM,
> > otherwise you can just compare ublk with scsi backed with tcmu.
> >
> > But if you run fio from VM, I believe you can setup virtio-scsi backed by
> > ublk block device directly, which should cover your requirement, or maybe
> > I miss something?
> 
> Everything runs in one 32 CPU guest. For tcm_loop and iSCSI (16
> sessions over 127.0.0.1), fio runs in that guest on the initiator
> disks. For vhost-scsi, fio runs in a nested 16 vCPU KVM guest on the
> vhost-scsi disk, with the target and the backstore server in the outer
> guest. In the ublk runs, kublk serves the file as /dev/ublkbN and
> target_core_iblock exports that through the same fabric.
> 
> You are not missing anything. This backstore has block semantics: the
> kernel emulates the SCSI commands, PR and ALUA included, exactly as for
> iblock, so ublk behind target_core_iblock offers the same function on
> every fabric, and for a VM a virtio-scsi or vhost-scsi disk on top of
> the ublk device covers it as well. What the series adds over that is
> only performance, and outside tcm_loop the numbers I sent do not show a
> consistent gain.

But in your last reply, not see the setup(virtio-scsi over ublk) and
perf number/compare with your scsi:target optimization.

> 
> [...]
> 
> > My question is actually why there is regression wrt. 4k randread:
> >
> >  workload               TCM/USER (MB/s)   uring (MB/s)          change
> >   4k randread, 1 job      426 (409-463)      369 (366-384)         -13%
> >
> > Maybe you can focus on single job perf only, which is easy to compare and
> > investigate.
> 
> It comes from the scheduler moving fio between CPUs. The pwrite() I
> pointed to in my last mail is not it: doing that copy inside
> io_uring_enter() instead makes no difference.
> 
> tcm_loop queues the LIO submission and completion work on the CPU that
> submitted the command, so with one job, fio's CPU always has bound
> kworkers and ksoftirqd runnable next to fio. The load balancer cannot
> move those and moves fio instead. This backstore gives it more chances:
> the completion work on fio's CPU handles 14 commands per run here
> against 24 with TCM/USER, so per 1000 I/Os the completion kworker and
> ksoftirqd run about 57 times against 35, fio is preempted as often, and
> it is moved two to three times as often. With balancing on, fio's own
> CPU time per I/O doubles here, from 3.1 to 6.3 us, against 3.4 to 4.9 us
> with TCM/USER, spread over the whole submission path rather than in one
> function.

That is one disadvantage for running IO from kernel space, and it is also one
reason why ioutgt ( https://github.com/io-target/ioutgt ) performs much better
than nvmet, especially for nvmet/tcp, not mention ioutgt doesn't implement
io_uring rxzc yet, and there are also other network optimizations available,
all can be applied flexibly.

> 
> Turning load balancing off for fio's CPUs and nothing else reverses the
> result. Single job, 4k randread at iodepth 32 over tcm_loop, 6 s per run,
> five alternating runs, median (min-max). fio runs in a cpuset of CPUs
> 4-31 and the server threads are pinned to CPUs 0-3; the cpuset is either
> a normal member (balanced) or an isolated partition (not balanced):
> 
>   fio CPUs 4-31, backstore      bandwidth (MB/s)   change
>   balanced, TCM/USER               439 (398-462)
>   balanced, uring                  379 (371-388)   -13.7%
>   not balanced, TCM/USER           662 (544-710)
>   not balanced, uring              760 (575-798)   +14.8%
> 
> Booting the guest with idle=poll removes the gap as well: with fio free
> to move, five runs give a median of 612 MB/s with TCM/USER and 627 MB/s
> here.
> 
> That points at what each switch costs in a guest. An idle vCPU executes
> HLT, which exits to the host and puts the vCPU thread to sleep; waking
> it for a kworker, ksoftirqd or a migrated fio takes an IPI, a host
> wakeup and a VM entry, and the host may run the thread on another
> physical CPU, so the guest code then runs with cold caches. With
> idle=poll the vCPUs spin instead, stay on their physical CPUs and take
> the IPI without an exit. This backstore makes more of those switches
> per I/O, so it pays more of that cost, and fio's slowdown spread over
> the whole submission path looks like cold caches.
> 
> What is measured is that idle=poll removes the gap and that the gap
> follows the switches and migrations. Which part of the cost is the exit
> and wakeup latency and which part is the vCPU thread landing on another
> physical CPU is inferred: I cannot trace the host side here. Waking an
> idle CPU is much cheaper on bare metal, so I expect the gap to be
> smaller there, but I have not measured it. idle=poll is only a
> diagnostic, it burns a host CPU per idle vCPU.
> 
> [...]
> 
> > When userspace target becomes more efficient, I'd suggest you to think
> > about why these applications can't be improved or refactored for the
> > potential (bigger)perf requirement.
> 
> Agreed. Since this backstore only takes block commands, an application
> that can move to it can just as well move to ublk, and one that needs
> SCSI semantics in userspace is not served by it either.

Why? SCSI semantics can be served in userspace, just like existing
virtio-scsi user backend.

Such as, uring-scsi may be supported in guest IO emulation application(qemu),
or one uring-virtqueue bridge, the later may be done in both userspace or
vhost_scsi, I guess.

Thanks,
Ming
