From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Date: Wed, 25 Apr 2018 13:46:23 +0000
Subject: Re: MaxTransferLength
Message-Id: <64d0a230-e7ce-8b0b-e38f-ca2b7d86358a@linux.vnet.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180424122512.GQ27687@hydro.skol.ch>
In-Reply-To: <20180424122512.GQ27687@hydro.skol.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



On 4/25/18 5:13 AM, Nicolas D wrote:

> Hello,
>
> On Tue, Apr 24, 2018 at 07:53:53AM -0500, Bryant G. Ly wrote:
>> On 4/24/18 7:38 AM, Hannes Reinecke wrote:
>>
>>> 'pscsi' is the SCSI pass-through, so it'll be presenting the
>>> values from the underlying device; I doubt you can change that.
> I have tried to tweak /sys/block/sr0/queue/max_sectors_kb but with no
> luck (sr0 is the backend exported) Can you tell me if targetcli use this
> value? And if yes, when is it taken into account? (on backend creation?
> when the initiator connects? sometime else?)
>
>>> What you could try is to mount the DVD, and export the mountpoint
>>> via the file backend; that way you should be able to tweak the
>>> parameters.
> I forgot to say that the goal is to play dvd/bd video disks and that I
> need the pass-through for all the special commands needed to authenticate
> the drive etc. So using the file backend does not seem to be an option.
>
>> Adding to what Hannes is saying, if you need true dvd/cd emulation you can
>> use file optical media backstore via user:fbo from tcmu-runner.
> Does the user:fbo handle the necessary special command for video dvd/bd?
>
>
Yes, user:fbo was written specifically to emulate optical drives, so it should
handle all the commands you need for dvd.

Bryant

