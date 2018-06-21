From: Mike Christie <mchristi@redhat.com>
Date: Thu, 21 Jun 2018 20:38:18 +0000
Subject: Re: [PATCH 14/14] target: Fix handling of removed LUNs
Message-Id: <5B2C0CBA.1000004@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-15-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-15-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/21/2018 03:25 PM, Bart Van Assche wrote:
>>>  		 * clearing it.
>>> > >  		 */
>>> > >  		if (dev->dev_attrib.emulate_ua_intlck_ctrl != 0) {
>>> > > +			*key = UNIT_ATTENTION;
>> > 
>> > 
>> > Is the key already set to UNIT_ATTENTION here?
> Good catch - that assignment is superfluous. But I would like to keep it
> because I think it makes the core_scsi3_ua_for_check_condition() easy to
> read. However, that assignment makes the following entry in sense_info_table[]
> superfluous:

If you keep it above then I think it would be good to add it below in
the emulate_ua_intlck_ctrl=0 case:

                if (head) {
                        *asc = ua->ua_asc;
                        *ascq = ua->ua_ascq;
                        head = 0;
                }

so it is consistent.
