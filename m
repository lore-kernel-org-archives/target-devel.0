From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 28 Jun 2019 12:55:10 +0000
Subject: Re: [PATCH 37/39] docs: adds some directories to the main documentation index
Message-Id: <a89ef0db-211c-1880-e60c-dc599b36feb7@samsung.com>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1561724493.git.mchehab+samsung@kernel.org>
 <CGME20190628123051epcas3p35e0cb4a5a1159dac19bde504ae21b0f3@epcas3p3.samsung.com>
 <b26fc645cb2c81fe88ab13616c65664d2c3cead5.1561724493.git.mchehab+samsung@kernel.org>
In-Reply-To: <b26fc645cb2c81fe88ab13616c65664d2c3cead5.1561724493.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-fbdev@vger.kernel.org, Len Brown <len.brown@intel.com>, linux-fpga@vger.kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, target-devel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, Paul Moore <paul@paul-moore.com>, linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>, linux-watchdog@vger.kernel.org, linux-kbuild@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Moritz Fischer <mdf@kernel.org>, dri-devel@lists.freedesktop.org, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.>


On 6/28/19 2:30 PM, Mauro Carvalho Chehab wrote:
> The contents of those directories were orphaned at the documentation
> body.
> 
> While those directories could likely be moved to be inside some guide,
> I'm opting to just adding their indexes to the main one, removing the
> :orphan: and adding the SPDX header.
> 
> For the drivers, the rationale is that the documentation contains
> a mix of Kernelspace, uAPI and admin-guide. So, better to keep them on
> separate directories, as we've be doing with similar subsystem-specific
> docs that were not split yet.
> 
> For the others, well... I'm too lazy to do the move. Also, it
> seems to make sense to keep at least some of those at the main
> dir (like kbuild, for example). In any case, a latter patch
> could do the move.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

> ---
>  Documentation/cdrom/index.rst           |  2 +-
>  Documentation/fault-injection/index.rst |  2 +-
>  Documentation/fb/index.rst              |  2 +-
>  Documentation/fpga/index.rst            |  2 +-
>  Documentation/ide/index.rst             |  2 +-
>  Documentation/index.rst                 | 14 ++++++++++++++
>  Documentation/kbuild/index.rst          |  2 +-
>  Documentation/livepatch/index.rst       |  2 +-
>  Documentation/netlabel/index.rst        |  2 +-
>  Documentation/pcmcia/index.rst          |  2 +-
>  Documentation/power/index.rst           |  2 +-
>  Documentation/target/index.rst          |  2 +-
>  Documentation/timers/index.rst          |  2 +-
>  Documentation/watchdog/index.rst        |  2 +-
>  14 files changed, 27 insertions(+), 13 deletions(-)
Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
