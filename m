From: Alex Vladulescu <avladulescu@bfproject.ro>
Date: Tue, 16 Jul 2019 15:15:22 +0000
Subject: Re: LIO fails to run on nvme drives - fixed
Message-Id: <ced779d6-8445-1eed-5354-e7437cb35dae@bfproject.ro>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org


Hello everyone,

I manage to fix (or get a workaround) about the issues I emailed you before.

After doing deeper into the python libraries and running with verbose 
mode the load config command from the init daemon function I found that 
the saveconfig command inside the targetcli running on iblock nvme 
devices save inside the config the following value:

 > //        unmap_zeroes_data 4294967295//

According to the comment found here on 
https://github.com/open-iscsi/targetcli-fb/blob/master/targetcli/ui_backstore.py

I could understand that this value should be a only a (0|1) value.
Although I don't fully understand the scope of it's implication the 
4294967295 value I get saved on the config might be comping from the py 
save config function call that doesn't address well the 32bit value, 
thus giving it a value out of scope for list(config.apply()) to apply.

I ended up including this dirty fix in /etc/init.d/target script to the 
below function:


load_config()
{
if [ $(cat /etc/target/scsi_target.lio 2>/dev/null | tr -d " \n\t" | wc 
-c) = 0 ]; then
     log_warning "Startup config ${STARTUP_CONFIG} is empty, skipping"
elif [ -e "${STARTUP_CONFIG}" ]; then

#
# fix for nvme base storage unmap_zeroes_data value to 0 due to 32bit 
wrong config parsing
#
unmap_zeroes_data_value=$(grep -w "unmap_zeroes_data" ${STARTUP_CONFIG} 
| awk '{print $2}')
if [ $unmap_zeroes_data_value -gt 0 ]; then
         sed -i "s:$unmap_zeroes_data_value:0:g" ${STARTUP_CONFIG}
fi

export __STARTUP_CONFIG="${STARTUP_CONFIG}"
python 2> /dev/null << EOF
import os, rtslib
config = rtslib.Config()
config.load(os.environ['__STARTUP_CONFIG'], allow_new_attrs=True)
list(config.apply())
EOF


since I can't control from the init script the save config changes, I 
should always make sure the value is set to 0 whenever loading the saved 
configuration and force it to 0.

Thought this might help somebody one day until a proper library update 
is made.

Regards,
Alex Vladulescu

On 16.07.2019 4:39, Alex Vladulescu wrote:
> 
> Hi,
> 
> 
> Hopefully I am writing this email and sending it to the write people.
> 
> I believe I am facing a strange behavior of LIO 
> (1:3.0~pre4.1~ga55d018-2) on xenial while trying to use a nvme drive to 
> export it to a virtualization server over a 10Gbe Intel NIC, so no RDMA 
> in place.
> 
> If the configuration is clean in /etc/target/scsi_target.lio the 
> targetcli daemon starts without any issues with <systemctl start target> 
> else, if I configure targetcli to use the nvme drive everything fails 
> just after a target daemon restart or a server reboot.
> 
> 
> Mind that the configuration and target export works, everything is 
> running fine just until I perform the reboot or restart of the service, 
> which after it fails with the following error:
> /-- Unit target.service has begun starting up./
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Cleared configuration/
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Unloaded tcm_qla2xxx fabric 
> module/
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Unloaded tcm_usb_gadget 
> fabric module/
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Unloaded tcm_fc fabric module/
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Unloaded ib_srpt fabric 
> module/
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Unloaded tcm_loop fabric 
> module/
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Unloaded iscsi_target_mod 
> fabric module/
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Unloaded vhost_scsi fabric 
> module/
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Unloaded target_core_file 
> target core module/
> ///Jul 16 03:07:34 iscsi01 target[12486]:  * Unloaded target_core_iblock 
> target core module/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Unloaded target_core_pscsi 
> target core module/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Unloaded target_core_user 
> target core module/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Unloaded usb_f_tcm target 
> core module/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Unloaded target_core_mod 
> target core module/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Stopped The Linux SCSI Target/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * The Linux SCSI Target looks 
> properly installed/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * The configfs filesystem is 
> already mounted/
> ///Jul 16 03:07:35 iscsi01 kernel: Rounding down aligned max_sectors 
> from 4294967295 to 4294967288/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded core module 
> target_core_mod/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded core module usb_f_tcm/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded core module 
> target_core_user/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded core module 
> target_core_pscsi/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded core module 
> target_core_iblock/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded core module 
> target_core_file/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded fabric module 
> tcm_qla2xxx/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded fabric module 
> tcm_usb_gadget/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded fabric module tcm_fc/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded fabric module ib_srpt/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded fabric module tcm_loop/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded fabric module 
> iscsi_target_mod/
> ///Jul 16 03:07:35 iscsi01 target[12486]:  * Loaded fabric module 
> vhost_scsi/
> ///Jul 16 03:07:36 iscsi01 kernel: ignoring deprecated emulate_dpo 
> attribute/
> ///Jul 16 03:07:36 iscsi01 kernel: ignoring deprecated emulate_fua_read 
> attribute/
> //*/Jul 16 03:07:36 iscsi01 target[12486]:  * Failed to load 
> /etc/target/scsi_target.lio/*
> ///Jul 16 03:07:36 iscsi01 target[12486]:  * Could not start The Linux 
> SCSI Target/
> ///Jul 16 03:07:36 iscsi01 systemd[1]: target.service: Control process 
> exited, code=exited status=1/
> ///Jul 16 03:07:36 iscsi01 systemd[1]: Failed to start LSB: The Linux 
> SCSI Target service./
> ///-- Subject: Unit target.service has failed/
> ///-- Defined-By: systemd/
> ///-- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel/
> ///--/
> ///-- Unit target.service has failed./
> ///--/
> ///-- The result is failed./
> ///Jul 16 03:07:36 iscsi01 systemd[1]: target.service: Unit entered 
> failed state./
> ///Jul 16 03:07:36 iscsi01 systemd[1]: target.service: Failed with 
> result 'exit-cod/e'.
> 
> Looking at the /etc/init.d/target init script I could see that 
> everything fails once it tries to load the configuration into the kernel 
> space, since every time it exist with RC=1 (function load_config)
> 
> 
> So, if I try to remove the null redirection and manually run the import 
> command it provides the following output:
> 
> /[Storage:root:iscsi01]:~:# python << EOF
>   > import os, rtslib
>   > config = rtslib.Config()
>   > config.load(os.environ['__STARTUP_CONFIG'], allow_new_attrs=True)
>   > list(config.apply())
>   > EOF
> No handlers could be found for logger "Config"
> Traceback (most recent call last):
>     File "<stdin>", line 4, in <module>
>     File "/usr/lib/python2.7/dist-packages/rtslib/config.py", line 717, 
> in apply
>       apply_create_obj(obj)
>     File "/usr/lib/python2.7/dist-packages/rtslib/config_live.py", line 
> 517, in apply_create_obj
>       apply_group_attrs(obj, lio_so)
>     File "/usr/lib/python2.7/dist-packages/rtslib/config_live.py", line 
> 326, in apply_group_attrs
>       lio_obj.set_attribute(name, value)
>     File "/usr/lib/python2.7/dist-packages/rtslib/node.py", line 192, in 
> set_attribute
>       % (str(attribute), str(value), str(msg)))
> rtslib.utils.RTSLibError: Cannot set attribute unmap_zeroes_data to 
> '4294967295': Invalid argument/
> 
> 
> 
> 
> If I am to login into targetcli I can spot the that disk is not in use 
> and everything else appears as unconfigured:
> 
> 
> //> ls
> o- / 
> ......................................................................................................................... 
> [...]
>     o- backstores 
> .............................................................................................................. 
> [...]
>     | o- fileio 
> ................................................................................................... 
> [0 Storage Object]
>     | o- iblock 
> ................................................................................................... 
> [1 Storage Object]
>     | | o- nvme0 
> .......................................................................................... 
> [/dev/nvme0n1, not in use]
>     | o- pscsi 
> .................................................................................................... 
> [0 Storage Object]
>     | o- rd_mcp 
> ................................................................................................... 
> [0 Storage Object]
>     o- ib_srpt 
> ........................................................................................................... 
> [0 Targets]
>     o- iscsi 
> ............................................................................................................. 
> [0 Targets]
>     o- loopback 
> .......................................................................................................... 
> [0 Targets]
>     o- qla2xxx 
> ........................................................................................................... 
> [0 Targets]
>     o- tcm_fc 
> ............................................................................................................ 
> [0 Targets]
>     o- usb_gadget 
> ........................................................................................................ 
> [0 Targets]
>     o- vhost 
> ............................................................................................................. 
> [0 Targets]
> />/
> 
> 
> My configuration looks like below:
> 
> /[Storage:root:iscsi01]:~:# nvme list//
> //Node             SN Model                                    Namespace 
> Usage                      Format           FW Rev//
> //---------------- -------------------- 
> ---------------------------------------- --------- 
> -------------------------- ---------------- --------//
> ///dev/nvme0n1     CVMD727200NG2P0TGN 
> LT2000KEXVC                              1           2.00  TB /   2.00 
> TB    512   B +  0 B   4IFDHPK3//
> ///dev/nvme1n1     CVMD727200C72P0TGN 
> LT2000KEXVC                              1           2.00  TB /   2.00 
> TB    512   B +  0 B   4IFDHPK3//
> //[Storage:root:iscsi01]:~:# lsblk//
> //NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT//
> //nvme0n1 259:1    0  1.8T  0 disk//
> //sdb       8:16   1 14.3G  0 disk//
> //├─sdb2    8:18   1   14G  0 part ///
> //├─sdb3    8:19   1  263M  0 part [SWAP]//
> //└─sdb1    8:17   1   94M  0 part//
> //nvme1n1 259:0    0  1.8T  0 disk//
> //sda       8:0    0  2.7T  0 disk//
> //└─sda1    8:1    0  2.7T  0 part /mnt/sata//
> //[Storage:root:iscsi01]:~:# cat /etc/target/scsi_target.lio-working//
> //storage iblock disk nvme0 {//
> //    path /dev/nvme0n1//
> //    wwn b07ee6d5-7159-49e6-91da-bcf8e549f3f2//
> //    attribute {//
> //        block_size 512//
> //        emulate_3pc yes//
> //        emulate_caw yes//
> //        emulate_dpo yes//
> //        emulate_fua_read yes//
> //        emulate_fua_write yes//
> //        emulate_model_alias no//
> //        emulate_rest_reord no//
> //        emulate_tas yes//
> //        emulate_tpu no//
> //        emulate_tpws no//
> //        emulate_ua_intlck_ctrl no//
> //        emulate_write_cache no//
> //        enforce_pr_isids yes//
> //        fabric_max_sectors 8192//
> //        force_pr_aptpl 0//
> //        is_nonrot yes//
> //        max_unmap_block_desc_count 1//
> //        max_unmap_lba_count 4294967295//
> //        max_write_same_len 4294967295//
> //        optimal_sectors 256//
> //        pi_prot_format 0//
> //        pi_prot_type 0//
> //        pi_prot_verify 0//
> //        queue_depth 1023//
> //        unmap_granularity 1//
> //        unmap_granularity_alignment 0//
> //        unmap_zeroes_data 4294967295//
> //    }//
> //}//
> //fabric iscsi {//
> //    discovery_auth {//
> //        enable no//
> //        mutual_password ""//
> //        mutual_userid ""//
> //        password ""//
> //        userid ""//
> //    }//
> //    target iqn.2019-07.iscsi01.int.domain.ro:01 tpgt 1 {//
> //        enable yes//
> //        attribute {//
> //            authentication no//
> //            cache_dynamic_acls yes//
> //            default_cmdsn_depth 64//
> //            default_erl 0//
> //            demo_mode_discovery no//
> //            demo_mode_write_protect no//
> //            fabric_prot_type 0//
> //            generate_node_acls yes//
> //            login_keys_workaround 1//
> //            login_timeout 15//
> //            netif_timeout 2//
> //            prod_mode_write_protect no//
> //            t10_pi 0//
> //            tpg_enabled_sendtargets 1//
> //        }//
> //        auth {//
> //            password ""//
> //            password_mutual ""//
> //            userid ""//
> //            userid_mutual ""//
> //        }//
> //        parameter {//
> //            AuthMethod "CHAP,None"//
> //            DataDigest "CRC32C,None"//
> //            DataPDUInOrder yes//
> //            DataSequenceInOrder yes//
> //            DefaultTime2Retain 20//
> //            DefaultTime2Wait 2//
> //            ErrorRecoveryLevel no//
> //            FirstBurstLength 65536//
> //            HeaderDigest "CRC32C,None"//
> //            IFMarkInt Reject//
> //            IFMarker no//
> //            ImmediateData yes//
> //            InitialR2T yes//
> //            MaxBurstLength 262144//
> //            MaxConnections 1//
> //            MaxOutstandingR2T 1//
> //            MaxRecvDataSegmentLength 8192//
> //            MaxXmitDataSegmentLength 262144//
> //            OFMarkInt Reject//
> //            OFMarker no//
> //            TargetAlias "LIO Target"//
> //        }//
> //        lun 0 backend iblock:nvme0//
> //        portal 172.21.11.33:3260//
> //    }//
> //}//
> //[Storage:root:iscsi01]:~:#/
> 
> 
> Another aspect in the /etc/init.d/target script is the fact that I 
> changed the below variable modules arguments to include usb_f_tcm.
> 
> #CORE_MODS="target_core_mod target_core_pscsi target_core_iblock 
> target_core_file"
> CORE_MODS="target_core_mod usb_f_tcm target_core_user target_core_pscsi 
> target_core_iblock target_core_file"
> 
> 
> as I have another system which is similar to this one, but the block 
> device is based on a RAID50 SCSI raid array which works without any 
> issues. Without the usb_f_tcm inclusion it would not unlink completely 
> the module target_core_mod since dependency prevent it from uploading.
> 
> After, everything is restarted and works just fine, even persistent 
> after a server reboot (on the other RAID50 server).
> 
> I have included this configuration here also, since that was the first 
> thought that something might be wrong while restart, but it turned 
> another issue which I can solve solely.
> 
> Hope this might also help:
> 
> /[Storage:root:iscsi01]:~:# /etc/init.d/target restart//
> //[....] Restarting target (via systemctl): target.serviceJob for 
> target.service failed because the control process exited with error 
> code. See "systemctl status target.service" and "journalctl -xe" for 
> details.//
> // failed!//
> //[Storage:root:iscsi01]:~:# lsmod | grep tcm//
> //tcm_loop               24576  1//
> //tcm_fc                 28672  1//
> //tcm_usb_gadget         16384  0//
> //tcm_qla2xxx            36864  1//
> //usb_f_tcm              28672  2//
> //target_core_mod       360448  21 
> tcm_loop,target_core_file,tcm_fc,target_core_iblock,iscsi_target_mod,ib_srpt,vhost_scsi,tcm_qla2xxx,target_core_pscsi,usb_f_tcm,target_core_user// 
> 
> //libfc                 126976  1 tcm_fc//
> //qla2xxx               724992  1 tcm_qla2xxx//
> //scsi_transport_fc      57344  3 qla2xxx,tcm_qla2xxx,libfc//
> //libcomposite           61440  2 tcm_usb_gadget,usb_f_tcm//
> //udc_core               49152  2 libcomposite,usb_f_tcm//
> //[Storage:root:iscsi01]:~:#//
> /
> 
> 
> I have google it and couldn't fine any reference on anybody having 
> trouble use nvme drives in LIO for iscsi export, thus everything I could 
> find is related to NVME over RDMA, but this is not the current case.
> Am i performing something wrong or this is a bug with the NVME cards ? 
> Mind that on sata array run just fine.
> The kernel I am using on all storage servers is : Linux iscsi01 
> 4.15.0-54-generic #58~16.04.1-Ubuntu SMP Mon Jun 24 13:21:41 UTC 2019 
> x86_64 x86_64 x86_64 GNU/Linux
> 
> Looking forward for your reply and any feedback will be much appreciated.
> 
> 
> Kind regards,
> Alex Vladulescu
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
