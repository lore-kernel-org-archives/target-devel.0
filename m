From: "Bryant G. Ly" <bryantly@linux.ibm.com>
Date: Thu, 24 May 2018 13:46:46 +0000
Subject: Re: MaxTransferLength
Message-Id: <69420f66-137f-79d4-b453-7db5f487dd38@linux.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180424122512.GQ27687@hydro.skol.ch>
In-Reply-To: <20180424122512.GQ27687@hydro.skol.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



On 5/23/18 3:48 PM, Nicolas D wrote:

> Hi,
>
> we finally found time to set up tcmu with user:fbo
>
> On Wed, Apr 25, 2018 at 08:46:23AM -0500, Bryant G. Ly wrote:
>> Yes, user:fbo was written specifically to emulate optical drives, so it should
>> handle all the commands you need for dvd.
> But can I find somewhere some documentation, I am lost (my dvd drive is
> /dev/sr0):
>
>   # targetcli 
>   tgrgetcli shell version 2.1.fb43
>   Copyright 2011-2013 by Datera, Inc and others.
>   For help on commands, type 'help'.
>   /backstores/user:fbo> create name=dvdfbo 
>   cfgstring=  size=       wwn=        
>   /backstores/user:fbo> create name=dvdfbo 
>   Missing required parameters 'cfgstring', 'size'
>   /backstores/user:fbo> create name=dvdfbo cfgstring=/dev/sr0
>   Missing required parameter size
>
> And also why size should be mandatory on an existing device?
>
>
The use of user:fbo is to emulate an optical device... So you would want to map an ISO9660 filesystem.

In this case you would do:

sudo targetcli /backstores/user:fbo create name=test_name cfgstring=/home/test/path.iso size000

Then you would map this backstore device to a fabric lun. Afterwards, on the client
VM you would see this as dev/sr0 when you boot up.


-Bryant

