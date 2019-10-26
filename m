From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 26 Oct 2019 17:09:18 +0000
Subject: Re: Possible LIO crash under heavy ESXi 6.7U3 load with iSCSI
Message-Id: <c4d3c949-4d19-5867-f3dc-7b6d2abeabbc@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <CAHTmSeTfOjVDMMtG6mVPKJyRWeMgvnCowq5Uyze=vMzPiQ4S5Q@mail.gmail.com>
In-Reply-To: <CAHTmSeTfOjVDMMtG6mVPKJyRWeMgvnCowq5Uyze=vMzPiQ4S5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2019-10-26 08:32, Thomas wrote:
> Hi Christoph, are you referring to the fact that I am using ZoL as the
> backend? To confirm, are you saying that the LIO community has no
> interest in supporting ZoL as a backend device, despite it being in
> major distros like Ubuntu? Just want to make sure I understand your
> reply fully.

Hi Thomas,

I think Christoph's reply means that you will have some more work to do
before anyone will have a closer look at your report. Bugs encountered
with the Ubuntu kernel should be reported to Canonical. If you
cherry-pick patches on top of that kernel then you are on your own. When
posting a report on a kernel mailing list like target-devel it helps to
grab attention if a bug report is about an unmodified recent upstream
kernel and without having loaded any out-of-tree kernel modules. Because
ZoL is an out-of-tree kernel module it is always behind the latest
kernel API changes. As you probably know API mismatches can be a source
of misbehavior by itself.

Bart.
