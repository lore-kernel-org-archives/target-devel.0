From: Mike Christie <mchristi@redhat.com>
Date: Fri, 11 Jan 2019 20:02:00 +0000
Subject: Re: IP whitelisting
Message-Id: <5C38F638.7010807@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <CAC3zG1ngRZb=phgij1T6g1a85_Lnn-08gyr226H_c5ceEDfs4A@mail.gmail.com>
In-Reply-To: <CAC3zG1ngRZb=phgij1T6g1a85_Lnn-08gyr226H_c5ceEDfs4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 01/11/2019 12:47 PM, Florian Florensa wrote:
> Would a patch regarding this feature appreciated? I would like to work
> on that if it is doable
> 

I think it would be ok.

> Le ven. 11 janv. 2019 à 19:16, Mike Christie <mchristi@redhat.com
> <mailto:mchristi@redhat.com>> a écrit :
> 
>     On 01/03/2019 01:58 PM, Florian Florensa wrote:
>     > Hello everyone
>     >
>     > I am starting to get some interest on LIO and its integration with
>     > Ceph RBD, and i was wondering after looking through the api/cli if
>     > there is a way to filter clients by IP ?
>     >
> 
>     The kernel/LIO only supports initiator name based ACLs so upper layer
>     tools like targetcli/gwlci and rtslib only support that.
> 
