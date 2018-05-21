From: Mike Christie <mchristi@redhat.com>
Date: Mon, 21 May 2018 19:45:31 +0000
Subject: Re: tcmu data consistency
Message-Id: <5B0321DB.9090906@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <CAF2hZrm9AQtzAFKRk5Z9cbX0KAy7crJp1+RDXJMPUivV19_58Q@mail.gmail.com>
In-Reply-To: <CAF2hZrm9AQtzAFKRk5Z9cbX0KAy7crJp1+RDXJMPUivV19_58Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 05/20/2018 04:10 AM, 亓武强 wrote:
> hi：
>     i have some questions about the tcmu, consider following scenario：
> 
> 1，Iscsi initiator establishes two session connection with gw1,gw2 at
> the same time. gw1  is the active path.
> 
> 2,  The active path is switched to gw 2 due to the interruption of the
> connection from the initiator to gw1.
> 
> 3, gw2  acquire exclusive lock and write some data to lun0.  then gw1
> update the exclusive lock to UNLOCKED.
> 
> 4, after step 3,   some old  iscsi session  inflight write ios
> arrival gw1 , gw1  acquire the exclusive lock again, the old data will
>   overwrite new data.

With iscsi it should not happen when using explicit failover mode. We
will process all outstanding IO before the STPG, so inflight writes
would be failed then we would grab the lock.

In implicit mode it could happen.



