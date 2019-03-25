From: Gionatan Danti <g.danti@assyoma.it>
Date: Mon, 25 Mar 2019 18:33:38 +0000
Subject: Re: Limit logins or connections to the same target LUN
Message-Id: <b83a29800bb1c3fd2969f173e9dc70ff@assyoma.it>
List-Id: <target-devel.vger.kernel.org>
References: <17b94268-631e-515b-ccb3-f1b6ffcdd797@assyoma.it>
In-Reply-To: <17b94268-631e-515b-ccb3-f1b6ffcdd797@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Il 04-03-2019 18:25 Gionatan Danti ha scritto:
> Il 28-02-2019 16:19 Gionatan Danti ha scritto:
>> Hi all,
>> I would like to understand if, and how to, limit the maximum number of
>> simultaneous connections (or logins) to a specific LUN (similar in how
>> the "MaxSession" option worked in the old ietd).
>> 
>> I am exporting a LUN with a general purpose filesystem (non cluster
>> aware) and I would be 100% sure that only a single machine at a time
>> can mount it.
>> 
>> At the moment, I protected the iSCSI LUN with both an IP-based access
>> list and a username/password combo, but hard limiting the maximum
>> number of connections opened against it to 1 (one) would be a nice
>> thing...
>> 
>> Also, I am aware of SCSI persistent reservations (sg_persist) but,
>> while working well, they are somewhat harder to setup.
>> 
>> Thank you,
>> regards.
> 
> Hi all,
> any suggestions?
> 
> Thanks.

Sorry to ask again... does someone know the answer to my question? Am I 
posting on the wrong list?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
