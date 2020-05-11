From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:21:20 +0000
Subject: Re: [PATCH 11/15] target: add sysfs support
Message-Id: <ba76d44a-9d04-e5e4-39ef-3b3a820c4452@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-12-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-12-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On 5/10/20 11:57 PM, Mike Christie wrote:
> These next two patches add a sysfs interface that reports the target
> layer's I_T nexuses/sessions. For the non-SCSI people cc'd, this just means
> we are reporting a server's connections to remote clients.
> 
> This patch adds the upper level dirs which shows/organizes our local port
> (tpgts below) and the connection (session below). The next patch will then
> add the dirs/files for each connection/session which exports info like
> ACL/permissions and SCSI port values.
> 
> Here is the general layout:
> 
> [sys]# tree scsi_target/
> scsi_target/
> |-- fabric/target module
> |   `-- target name
> |       `-- tpgt_$target_port_group_number
> |           `-- sessions
> |               `-- initiator name - session ID number
> |                   |-- acl
> |                   `-- transport_id
> |                       |-- name
> |                       |-- proto
> |                       `-- session_id
> 
> Here is an example with the scsi target layer's iSCSI driver:
> 
> scsi_target/
> |-- iscsi
> |   `-- iqn.1999-09.com.tcmu:minna
> |       `-- tpgt_1
> |           `-- sessions
> |               `-- iqn.2005-03.com.ceph:ini1-1
> |                   |-- acl
> |                   `-- transport_id
> |                       |-- name
> |                       |-- proto
> |                       `-- session_id
> |-- fc
> |-- loopback
> |-- qla2xxx_tcm
> 
> 
I'm not sure if we want to include the actual name for the target name 
or initiatorname; that we we'll get an instant denial of service if we 
fail to cleanup this directory and want to recreate a new one.
Normally we have been using logical names for sysfs directories (ie 
targertport0 or session0) and include the actual names in a sysfs 
attribute. That way the structure can stay around for slightly longer 
(ie for cleanup operations) _and_ we can create a new one to allow new 
connections with the same credentials.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
