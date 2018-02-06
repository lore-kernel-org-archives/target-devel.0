From: Michael Christie <mchristi@redhat.com>
Date: Tue, 06 Feb 2018 18:49:26 +0000
Subject: Re: new kernel connection timeouts
Message-Id: <f4761642-bc79-cc47-6fde-449f2bceb541@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <CABOsP2Nx+==bXwZVbkd5qHo5AhF1C-z2ObmNoxMugFeXabvX0w@mail.gmail.com>
In-Reply-To: <CABOsP2Nx+==bXwZVbkd5qHo5AhF1C-z2ObmNoxMugFeXabvX0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 02/06/2018 07:25 AM, Michael Di Domenico wrote:
> On Mon, Feb 5, 2018 at 12:17 PM, Mike Christie <mchristi@redhat.com> wrote:
>> On 02/02/2018 01:52 PM, Michael Di Domenico wrote:
>>> I recently updated my iscsi target box from redhat kernel
>>> 3.10.0-693.11.1.el7 to 3.10.0.693.17.1.el7.  now when i try to bring
>>
>> Did you update to this kernel on both the target side and initiator side?
> 
> yes, both the client and server were updated to the same version
> 
> 
>>> up a few dozen iscsi clients at a time several will timeout.  i can't
>>> say where in the iscsi connection it's failing, but if i'm on the
>>> console of the iscsi client, i can rerun the connection script and the
>>> disks will appear.
>>>
>>> it almost seems like the connections are queued up on the target and
>>> some don't get one because the queue is full.
>>
>> Do you have the kernel logs from the target side or initiator side? Or,
>> can you take a wireshark trace during this time?
> 
> i *might* be able to take a trace using tcpdump, but i will not be
> able to send you binary version of the output (protected network).  is
> there something specific i can look for in the trace?  or can you
> narrow a wireshark/tcpdump filter that would allow me to produce a
> short ascii file with the data you need?

Could you just get me the target side kernel logs for when you run the
login test?

On the initiator side what command are you running? Is it just iscsiadm
.... --login? Could you give me the error output?

