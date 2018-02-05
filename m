From: Mike Christie <mchristi@redhat.com>
Date: Mon, 05 Feb 2018 17:17:41 +0000
Subject: Re: new kernel connection timeouts
Message-Id: <5A7891B5.4070108@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <CABOsP2Nx+==bXwZVbkd5qHo5AhF1C-z2ObmNoxMugFeXabvX0w@mail.gmail.com>
In-Reply-To: <CABOsP2Nx+==bXwZVbkd5qHo5AhF1C-z2ObmNoxMugFeXabvX0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 02/02/2018 01:52 PM, Michael Di Domenico wrote:
> I recently updated my iscsi target box from redhat kernel
> 3.10.0-693.11.1.el7 to 3.10.0.693.17.1.el7.  now when i try to bring

Did you update to this kernel on both the target side and initiator side?

> up a few dozen iscsi clients at a time several will timeout.  i can't
> say where in the iscsi connection it's failing, but if i'm on the
> console of the iscsi client, i can rerun the connection script and the
> disks will appear.
> 
> it almost seems like the connections are queued up on the target and
> some don't get one because the queue is full.

Do you have the kernel logs from the target side or initiator side? Or,
can you take a wireshark trace during this time?

> 
> i know this isn't a fantastic bug report, but i haven't changed
> anything process wise in my environment i was able to boot 30-40
> machines at a time.  if i do that now, half or so will fail to see
> their disks and i have to reboot them a second time.  at which point
> they usually succeed.  either because others have finished or just
> luck that they were in the queue at the right time, i'm not sure.
> 
> the targetcli version is 2.1.fb46-1.el7
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

