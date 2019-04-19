From: Jonathan Corbet <corbet@lwn.net>
Date: Fri, 19 Apr 2019 22:10:58 +0000
Subject: Re: Avoiding merge conflicts while adding new docs - Was: Re: [PATCH 00/57] Convert files to ReST
Message-Id: <20190419161058.3628a29b@lwn.net>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1555382110.git.mchehab+samsung@kernel.org>
        <20190418091526.00e074d1@coco.lan>
In-Reply-To: <20190418091526.00e074d1@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, linux-fbdev@vger.kernel.org, linux-s390@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-watchdog@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-samsung-soc@vger.kernel.org, linux-acpi@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, bpf@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kbuild@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Thu, 18 Apr 2019 09:42:23 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:

> After thinking a little bit and doing some tests, I think a good solution
> would be to add ":orphan:" markup to the new .rst files that were not
> added yet into the main body (e. g. something like the enclosed example).

Interesting...I didn't know about that.  Yes, I think it makes sense to
put that in...

jon
