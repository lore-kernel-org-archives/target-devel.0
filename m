From: Martin Svec <martin.svec@zoner.cz>
Date: Thu, 29 Nov 2018 13:40:34 +0000
Subject: Re: SPC-3 persistent reservations race condition
Message-Id: <3268e892-62d2-e93f-bb35-d72d5d8afd6b@zoner.cz>
List-Id: <target-devel.vger.kernel.org>
References: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
In-Reply-To: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Hi David,

Dne 26.11.2018 v 0:10 David Disseldorp napsal(a):
> Hi Martin,
>
> On Thu, 22 Nov 2018 19:47:19 +0100, Martin Svec wrote:
> ...
>> Please download the trace from https://www.maatts.eu/lio-pr.pcap. It's a merge of captures of two
>> target SAN interfaces (10.22.1.208, 10.22.2.208). The deadlock occured in 18:57:17 CET. I guess it
>> was caused by packets 5979 and 5980:
>>
>> 5979    62.915577    10.22.102.66    10.22.1.208    iSCSI    126    SCSI: Persistent Reserve Out
>> LUN: 0x01 SCSI: Data Out LUN: 0x01 (Persistent Reserve Out Request Data)
>> 5980    62.915722    10.22.102.52    10.22.2.208    iSCSI    126    SCSI: Persistent Reserve Out
>> LUN: 0x01 SCSI: Data Out LUN: 0x01 (Persistent Reserve Out Request Data)
> I've attempted to trigger this via a new libiscsi test published at:
> https://github.com/ddiss/libiscsi/
> branch: test_mpio_async_prout_preempt
>
> I haven't had any luck so far against mainline kernel, but am interested
> to hear whether you're able to trigger the deadlock against your target.
> It can be run via:
>
> # make
> ./test-tool/iscsi-test-cu -V --dataloss --test=SCSI.MultipathIO.ProutPreemptAsync \
> 	iscsi://$TARGET_IP/$IQN/$LUN \
> 	iscsi://$TARGET_IP/$IQN/$LUN
>
> You can use different or matching portal IPs for the two iSCSI target
> URIs above.
>
> Cheers, David

Unfortunately I'm not able to reproduce the bug with the libiscsi test too. I tried multiple
concurrent tests ran in an infinite loop with no luck. However, the description of the deadlock
should be clear enaugh to understand the root cause.

Martin
