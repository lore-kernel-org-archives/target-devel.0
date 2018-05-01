From: Raghuram Devarakonda <draghuram@gmail.com>
Date: Tue, 01 May 2018 17:58:21 +0000
Subject: Re: tcmu-runner rpm
Message-Id: <CALtL6Be8=HdW4G+4hcJ1OcJqHeKg051UrvZ1T1t+mRrf8NGJNQ@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <CALtL6Bd12N8BOU2+DZh-b8g0GF=hVoMANyVpvMTk-uE+ZGDpMQ@mail.gmail.com>
In-Reply-To: <CALtL6Bd12N8BOU2+DZh-b8g0GF=hVoMANyVpvMTk-uE+ZGDpMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Ok, thanks.

On Tue, May 1, 2018 at 11:53 AM, Bryant G. Ly <bryantly@linux.ibm.com> wrote:
> On 5/1/18 10:48 AM, Raghuram Devarakonda wrote:
>
>> Hi,
>>
>> I am looking for tcmu-runner rpm to install on CentOS 7.4 but am not
>> able to find one. Here is some info about my repos:
>>
>> $ yum repo list
>> !base/7/x86_64                                  CentOS-7 - Base
>>                                                                9,591
>> !elrepo                                         ELRepo.org Community
>> Enterprise Linux Repository - el7                                  219
>> !epel/x86_64                                    Extra Packages for
>> Enterprise Linux 7 - x86_64
>> 12,507
>> !extras/7/x86_64                                CentOS-7 - Extras
>>                                                                  448
>> !ius/x86_64                                     IUS Community Packages
>> for Enterprise Linux 7 - x86_64                                  469
>> !updates/7/x86_64                               CentOS-7 - Updates
>>                                                                2,416
>> !zfs/x86_64                                     ZFS on Linux for EL7 -
>> dkms                                                             118
>>
>> $ yum search all tcmu
>> Loaded plugins: fastestmirror
>> Loading mirror speeds from cached hostfile
>>  * base: mirrors.advancedhosters.com
>>  * elrepo: iad.mirror.rackspace.com
>>  * epel: ewr.edge.kernel.org
>>  * extras: mirror.cogentco.com
>>  * ius: iad.mirror.rackspace.com
>>  * updates: mirrors.lga7.us.voxel.net
>> Warning: No matches found for: tcmu
>>
>> Do I need to add any other repo to get tcmu-runner?
>
> You need to build it yourself.
>
> Follow: https://github.com/open-iscsi/tcmu-runner
>
> -Bryant
>
