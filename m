From: Nicolas D <nd@saitis.net>
Date: Wed, 23 May 2018 20:48:17 +0000
Subject: Re: MaxTransferLength
Message-Id: <20180523204817.GC6577@hydro.skol.ch>
List-Id: <target-devel.vger.kernel.org>
References: <20180424122512.GQ27687@hydro.skol.ch>
In-Reply-To: <20180424122512.GQ27687@hydro.skol.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Hi,

we finally found time to set up tcmu with user:fbo

On Wed, Apr 25, 2018 at 08:46:23AM -0500, Bryant G. Ly wrote:
> 
> Yes, user:fbo was written specifically to emulate optical drives, so it should
> handle all the commands you need for dvd.

But can I find somewhere some documentation, I am lost (my dvd drive is
/dev/sr0):

  # targetcli 
  tgrgetcli shell version 2.1.fb43
  Copyright 2011-2013 by Datera, Inc and others.
  For help on commands, type 'help'.
  /backstores/user:fbo> create name=dvdfbo 
  cfgstring=  size=       wwn=        
  /backstores/user:fbo> create name=dvdfbo 
  Missing required parameters 'cfgstring', 'size'
  /backstores/user:fbo> create name=dvdfbo cfgstring=/dev/sr0
  Missing required parameter size

And also why size should be mandatory on an existing device?

Thanks for your help

Nicolas
