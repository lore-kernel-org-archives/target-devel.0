From: Finn Thain <fthain@telegraphics.com.au>
Date: Wed, 17 Jun 2020 02:07:40 +0000
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
Message-Id: <alpine.LNX.2.22.394.2006171104540.11@nippy.intranet>
List-Id: <target-devel.vger.kernel.org>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com> <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet> <7ad14946-5c25-fc49-1e48-72d37a607832@boo.tc> <alpine.LNX.2.22.394.2006150919110.8@nippy.intranet>
 <8da0c285-d707-a3d2-063e-472af5cc560f@boo.tc> <alpine.LNX.2.22.394.2006161929380.8@nippy.intranet> <8cbab988-fba7-8e27-7faf-9f7aa36ca235@acm.org>
In-Reply-To: <8cbab988-fba7-8e27-7faf-9f7aa36ca235@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: Chris Boot <bootc@boo.tc>, linuxppc-dev@lists.ozlabs.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Tue, 16 Jun 2020, Bart Van Assche wrote:

> 
> As far as I know the sbp driver only has had one user ever and that user 
> is no longer user the sbp driver.

So, you estimate the userbase at zero. Can you give a confidence level? 
Actual measurement is hard because when end users encounter breakage, they 
look for quick workarounds before they undertake post mortem, log 
collection, bug reporting, mailing list discussions, analysis etc.

> So why to keep it in the kernel tree?

Answer: for the same reason it was added to the tree.

Here's a different question: "Why remove it from the kernel tree?"

If maintaining this code is a burden, is it not the kind of tax that all 
developers/users pay to all developers/users? Does this driver impose an 
unreasonably high burden for some reason?

The growth of a maintenance burden in general has lead to the invention of 
design patterns and tooling to minize it. So a good argument for removal 
would describe the nature of the problem, because some driver deficiencies 
can be fixed automatically, and some tooling deficiencies can compound an 
otherwise insignificant or common driver deficiency.

There are spin-off benefits from legacy code besides process improvements. 
Building and testing this sort of code has regularly revealed erroneous 
corner cases in commits elsewhere like API changes and refactoring.

Also, legacy code is used by new developers get experience in code 
modernization. And it provides more training material for neural networks 
that need to be taught to recognize patches that raise quality.

Ten or twenty years ago, I doubt that anyone predicted these (and other) 
spin-off benefits. If we can't predict the benefit, how will we project 
the cost, and use that to justify deletion?

Please see also,
http://www.mac.linux-m68k.org/docs/obsolete.php
