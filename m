From: Hannes Reinecke <hare@suse.de>
Date: Tue, 24 Apr 2018 12:38:12 +0000
Subject: Re: MaxTransferLength
Message-Id: <1c3a6c87-9afa-3f7c-2c76-24df8f021290@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180424122512.GQ27687@hydro.skol.ch>
In-Reply-To: <20180424122512.GQ27687@hydro.skol.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/24/2018 02:25 PM, Nicolas D wrote:
> 
> Hello everyone,
> 
> I tried googling a lot about this problem, but I had no luck till now.
> 
> I am having some trouble to read from a dvd/bd drive that is configured
> with targetcli with pscsi driver on different not so old linux versions:
>   - debian (version: saddly don't have the computer with me and don't
>     remember exactly but should be Jessie)
>   - ubuntu (14.04/kernel 3.13)
> 
> The problem is the same with all the initiator/os I could play with:
> 
> - Core-iSCSI/Linux
> - MS-initiator/Windows
> - StarWind/Windows
> - Sns GlobalSan/MacOS
> 
> The actual problem is that my target don't react well when the initiator
> ask to read more than 16KB in one read instruction: the response is a
> sense error or unit error (error discovered in pcap trace, thanks to
> wireshark).
> 
> I could lower the MaxTransferLength with the "MS-initiator/Windows" and
> for that initiator/os it works now perfectly.
> 
> https://support.zadarastorage.com/hc/en-us/articles/213024226-Recommended-Windows-iSCSI-initiator-Registry-configuration
> 
> But Sns GlobalSan for example does not support limiting read size on is
> side, and I think it's definitively the target that has to tell the
> initiator about this MaxTransferLength attribute, or I may be wrong?
> 
> I tried to tweak some parameters with targetcli, but:
> - lowering fabric_max_sectors does not seem to help
> - hw_max_sectors%6 hw_block_size 48 are read-only
> 
> I have definitively trouble finding documentation on all other
> backend attributes.
> 
> I have the impression that my problem is more config related, it's why I
> did not took the time to write all exact versions of the os/tools I use.
> 
> If you think I am wrong, I'll provide all useful informations.
> 
> Thank you for your help and for all the job already made to have this
> iscsi stack working in linux.
> 

'pscsi' is the SCSI pass-through, so it'll be presenting the values from 
the underlying device; I doubt you can change that.

What you could try is to mount the DVD, and export the mountpoint via 
the file backend; that way you should be able to tweak the parameters.

Cheers,

Hannes
