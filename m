From: James Smart <james.smart@broadcom.com>
Date: Tue, 18 Dec 2018 18:05:21 +0000
Subject: [ANNOUNCE v2]: Broadcom (Emulex) FC Target driver - efct
Message-Id: <9b8c7647-f9ab-9147-1378-b047929d5e11@broadcom.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

I'd like to announce the availability of the Broadcom (Emulex) FC target 
driver - efct.

This is the 2nd round of announcement.   In the first round, after 
discussion with community members, it was decided that the driver would 
consist of the following:
   - A SLI4-library that can be used by both an initiator driver and a 
target driver
   - A FC Discovery library that could be used by both an initiator 
driver and a target driver.
   - A SLI3-library that would be used by an initiator driver only
   - Delivery of a target driver that would support SCSI and NVME
   - Delivery of an initiator driver that would support SCSI and NVME  
(NVME on SLI-4 only).

As of this announcement the repository on gitlab 
(git@gitlab.com:jsmart/efct-Emulex_FC_Target.git)
contains:
  - the SLI-4 library
  - the FC Discovery library
  - the efct target driver that supports SCSI (lio)

Effort is underway on adding nvme target support to the efct driver, and 
after that, the initiator driver will be refactored.  The intent will be 
to move all elements into the upstream tree although it is expected the 
libraries and target components will be merged in a stage separate from 
the initiator components.

While those efforts are underway, we would like receive review comments 
on the code that is present. Comments can be sent to: 
ecd-efct.pdl@broadcom.com or myself

-- james



On 2/27/2017 3:28 PM, James Smart wrote:
> I'd like to announce the availability of the Broadcom (Emulex) FC 
> Target driver - efct.
> This driver has been part of the Emulex OneCore Storage SDK tool kit 
> for Emulex
> SLI-4 adapters. The SLI-4 adapters support 16Gb/s and higher adapters. 
> Although this
> kit has supported FCoE in the past, it is currently limited to FC 
> support.
>
> This driver provides the following:
> - Target mode operation:
>   - Functional with LIO-based interfaces
>   - Extensive use of hw offloads such as auto-xfer_rdy, auto-rsp, cmd 
> cpu spreading
>   - High login mode - thousands of logins
>   - T-10 DIF/PI support  (inline and separate)
>   - NPIV support
> - Concurrent Initiator support if needed
> - Discovery engine has F_Port and fabric services emulation.
> - Extended mgmt interfaces:
>   - firmware dump api, including dump to host memory for faster dumps
>   - Healthcheck operations and watchdogs
> - Extended driver behaviors such as:
>   - polled mode operation
>   - multi-queue: cpu, roundrobin, or priority  (but not tied  to scsi-mq)
>   - long chained sgl's
>   - extensive internal logging and statistics
>   - Tuning parameters on modes and resource allocation to different 
> features
>
> Broadcom is looking to upstream this driver and would like review and 
> feedback.
> The driver may be found at the following git repository:
> git@gitlab.com:jsmart/efct-Emulex_FC_Target.git
>
>
> Some of the key questions we have are with lpfc :
> 1) Coexistence vs integration
> Currently, the efct driver maps to a different set of PCI ids than lpfc.
> It's very clear there's an overlap with lpfc, both on SLI-4 hw as well 
> as initiator support.
> Although target mode support can be simplistically added to lpfc, what 
> we've found is
> that doing so means a lot of tradeoffs. Some of the target mode 
> features, when enabled,
> impact the initiator support and how it would operate.
>
> 2) SLI-3 support
> lpfc provides SLI-3 support so that all FC adapters are supported, 
> including the older ones.
> The form of the driver, based on its history, is SLI-3 with SLI-3 
> adapted to SLI-4 at the point
> it hits the hardware. efct does not support SLI-3.
>
> 3) complexity of configuration knobs caused by the kitchen-sink of 
> features in lpfc ?
> we are pushing the limit on needing per-instance attributes rather 
> than global module
> parameters.
>
> -- james
>
>


On 6/12/2017 4:08 PM, James Smart wrote:
> On 5/16/2017 12:59 PM, Roland Dreier wrote:
>> On Sun, Mar 5, 2017 at 8:35 AM, Sebastian Herbszt <herbszt@gmx.de> 
>> wrote:
>>> Just like Hannes I do favour integration. I guess it could be
>>> comparable to qla2xxx + tcm_qla2xxx, lpfc + lpfc_scst and
>>> lpfc + tcm_lpfc. That approach might even help Bart with his
>>> target driver unification if he didn't give up on that topic.
>> Resurrecting this old topic - sorry for not seeing this go by initially.
>>
>> For context, I have a lot of experience debugging the qla2xxx target
>> code - we did a lot of work to get error/exception paths correct.
>> Basic FC target support is pretty straightforward but handling SAN log
>> in / log out events and other strange things that initiators do took a
>> lot of effort.
>>
>> Anyway, my feeling is that the integration of tcm_qla2xxx and qla2xxx
>> was overall a net negative.  Having the target driver grafted onto the
>> side of an already-complex driver that has a bunch of code not
>> relevant to the target (SCSI error handling, logging into and timing
>> out remote target ports, etc) made the code harder to debug and harder
>> to get right.
>>
>> Of course I'm in favor of making common code really common.  So
>> certainly we should have a common library of SLI-4 code that both the
>> initiator and target driver share.  And if there is more commonality,
>> that's great.  But any code similar to "if (initiator) ... else ..."
>> is really suspect to me - grepping for "qla_ini_mode_enabled" shows
>> great examples like
>>
>> ...
>>
>> Handling "dual mode" (both initiator and target on the same port at
>> the same time) is a design challenge, but I don't think the current
>> qla2xxx driver is an example of a maintainable way to do that.
>>
>> (I'm agnostic about what to do about SLI-3 - perhaps the cleanest
>> thing to do is split the driver between SLI-4 and SLI-3, and handle
>> the initiator and target drivers for those two cases as appropriate)
>>
>> I'd love to discuss this further and come up with a design that meets
>> the concerns about integration but also learns the lessons from
>> tcm_qla2xxx.
>>
>>   - R.
>
>
> Thanks for the feedback.  I believe you echo many of our concerns as 
> we look at "merging them into one".  I agree with your statements on 
> the number of if-else roles and know that we made this even more 
> complicated by the driver doing fc-nvme initiator and fc-nvme target 
> as well.  Your small list of "mode_enabled" hits pales in comparison 
> to a hit list in the current driver if looking for SCSI initiator 
> support (LPFC_ENABLE_FCP), NVME initiator support (LPFC_ENABLE_NVME), 
> or NVME target support (phba->nvmet_support). And that's before adding 
> SCSI target support.   We're also concerned about the discovery 
> engines as not only are there lots of different paths for the 
> different roles as well as support for fcoe, but there are a lot of 
> carefully managed accommodations for various oem and switch 
> environments. It's very difficult to replicate and retest all these 
> different configurations and scenarios.
>
> Here's what I'd like to propose for a direction:
> 1) Create an initiator driver and a target driver.  For now, initiator 
> would support both SCSI and NVME initiator. Target would support SCSI 
> and NVME target.
> 2) SLI3 support would be contained only within the initiator driver 
> and limited to SCSI (as it is today in lpfc).
> 3) SLI4 support would be library-ized,so that the code can be shared 
> between the two drivers.  Library-izing SLI-4 means SLI-3 will also be 
> library-ized.
> 4) Discovery support would be librarized so it can be shared. As part 
> of this effort we will minimally move generic functions from the 
> library to drivers/scsi/libfc (example: setting RPA payloads, etc).  
> At this time, the drivers will not attempt to use libfc for discovery. 
> There is too much sensitive code tied to interlocks with adapter api 
> design that are visible in the discovery state machine. Use of libfc 
> can be a future, but for the short term, the goal is a single library 
> for the broadcom initiator/target drivers.
> 5) lpfc will be refactored, addressing concerns that have been desired 
> for a while.
>
>
> To start this effort, I'd like a bcmlpfc directory to be made within 
> the drivers staging tree. The directory would be populated with the 
> efct driver and a copy of the existing lpfc driver. Work can then 
> commence on refactoring lpfc and creating the libraries and 
> integrating the libraries into both drivers.  As lpfc is updated in 
> the main tree, patches would be posted to the staging version of lpfc 
> to keep them on par.
>
>
> Questions:
> a) How best to deal with overlapping pci id's ?  E.g. if we do (1) and 
> we have an initiator and target driver, there is a lot of adapters 
> that are fully functional for target operation, but were sold as 
> primarily an initiator adapter. How could we manage target mode 
> enablement without code mod or hard pci id partitioning ?   I know 
> individual pci unbind/bind could work, but its been frowned upon as a 
> long term option. Same thing goes for module parameters to select 
> which ports do what role.
>
> b) Assuming we have the lpfc copy in the bcmlpfc directory in the 
> staging tree: are there any issues with having a version of lpfc in 
> the main tree and another in the staging tree ?     For many reasons, 
> I'd like to keep the name lpfc on the initiator driver in the staging 
> tree. But is that possible ? I assume we would need to develop in the 
> staging tree as a new name and pci id space separate from the base 
> driver, and we can rename the staging driver to the lpfc name when it 
> merges into the main kernel and replaces the existing driver.
>
> Thoughts ? Nic ?   James ?  Martin ?
>
> -- james
