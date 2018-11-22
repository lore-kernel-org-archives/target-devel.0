From: Martin Svec <martin.svec@zoner.cz>
Date: Thu, 22 Nov 2018 18:47:19 +0000
Subject: Re: SPC-3 persistent reservations race condition
Message-Id: <8f9aaf31-aaef-d8a7-411a-05dd044c6b0f@zoner.cz>
List-Id: <target-devel.vger.kernel.org>
References: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
In-Reply-To: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

Hi David,

Dne 20.11.2018 v 19:31 David Disseldorp napsal(a):
> Hi Martin,
>
> On Tue, 13 Nov 2018 16:17:36 +0100, Martin Svec wrote:
>
>> Hello,
>>
>> during Hyper-V Cluster Validation tests, we hit a bug in SPC-3 persisten=
t reservations
>> implementation where LIO iSCSI target started to loop indefinitely while=
 freeing
>> a PR registration.
> Any chance you could capture and share a network trace for the specific
> test that triggers the deadlock. Having something to turn into a
> libiscsi regression test would be helpful here.

Please download the trace from https://www.maatts.eu/lio-pr.pcap. It's a me=
rge of captures of two
target SAN interfaces (10.22.1.208, 10.22.2.208). The deadlock occured in 1=
8:57:17 CET. I guess it
was caused by packets 5979 and 5980:

5979=A0=A0=A0 62.915577=A0=A0=A0 10.22.102.66=A0=A0=A0 10.22.1.208=A0=A0=A0=
 iSCSI=A0=A0=A0 126=A0=A0=A0 SCSI: Persistent Reserve Out
LUN: 0x01 SCSI: Data Out LUN: 0x01 (Persistent Reserve Out Request Data)
5980=A0=A0=A0 62.915722=A0=A0=A0 10.22.102.52=A0=A0=A0 10.22.2.208=A0=A0=A0=
 iSCSI=A0=A0=A0 126=A0=A0=A0 SCSI: Persistent Reserve Out
LUN: 0x01 SCSI: Data Out LUN: 0x01 (Persistent Reserve Out Request Data)

Martin
