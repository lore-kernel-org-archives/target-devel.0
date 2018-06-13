From: Nicolas D <nd@saitis.net>
Date: Wed, 13 Jun 2018 11:31:15 +0000
Subject: Re: MaxTransferLength
Message-Id: <20180613113115.GA22509@hydro.skol.ch>
List-Id: <target-devel.vger.kernel.org>
References: <20180424122512.GQ27687@hydro.skol.ch>
In-Reply-To: <20180424122512.GQ27687@hydro.skol.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Hello,

On Thu, May 24, 2018 at 08:46:46AM -0500, Bryant G. Ly wrote:
> 
> The use of user:fbo is to emulate an optical device... So you would
> want to map an ISO9660 filesystem.
> 
> In this case you would do:
> 
> sudo targetcli /backstores/user:fbo create name=test_name
> cfgstring=/home/test/path.iso size000
> 
> Then you would map this backstore device to a fabric lun. Afterwards,
> on the client VM you would see this as dev/sr0 when you boot up.

So I won't be able to solve my problem at all. I just read again what I
wrote in this thread and I think I was clear enough, tell me if I am
wrong. In my use case:

- Optical media (CD, DVD, BluRay) have to be served directly
- All commands related to optical drive authentication should be
  supported (and it works well with pscsi), it is needed to play
  protected content.

I still don't understand why this problenm can't be solved easily. AFAIK
maxtransferlength is negociated on login and seems to be
MIN(initiator,target)

Also, tell me if you think there's a better place to ask for help about
this case.

Nicolas
