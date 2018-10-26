From: zhengliang <zhengliang6@huawei.com>
Date: Fri, 26 Oct 2018 01:25:53 +0000
Subject: Re: BUG in use-after-free iSCSI dataout timeout
Message-Id: <8d9a82d3-68a6-6242-7708-8d66cd3519ce@huawei.com>
List-Id: <target-devel.vger.kernel.org>
References: <13ab4e80-8435-ca17-5a1c-b06ef2c8fd25@huawei.com>
In-Reply-To: <13ab4e80-8435-ca17-5a1c-b06ef2c8fd25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

kernel version: 4.14.10

=D4=DA 2018/10/26 6:04, David Disseldorp =D0=B4=B5=C0:
> Hi,
>=20
> On Thu, 25 Oct 2018 10:03:00 +0800, zhengliang wrote:
>=20
>> Thank you very much for your help.
>> I need a few days to test this patch.
>> I will feedback the test results to you later.
>=20
> With which kernel version are you able to trigger the use-after-free?
> I've been trying to reproduce it from a hack r2t-dropping-initiator[1]
> which drops the connection at around the same time as the dataout timeout
> but am yet to hit this with mainline.
>=20
> Cheers, David
>=20
> 1. https://github.com/ddiss/libiscsi/tree/hack-lio-trigger-dataout-timeou=
t-v2
>=20
> .
>=20
