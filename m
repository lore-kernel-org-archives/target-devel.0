From: Alex Bobro <oleksandrb@mellanox.com>
Date: Thu, 29 Nov 2018 15:00:05 +0000
Subject: ISCSI Target crash during ISERT logout
Message-Id: <AM6PR05MB6085DA0179A35E80F367A216A0D20@AM6PR05MB6085.eurprd05.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi, 

During ISERT module testing we've faced weird behavior in ISCSI Target driver code. We are not sure if that is wrong logout implementation in ISERT or race condition in ISCSI Target between iscsit_logout_post_handler() and iscsit_tpg_del_portal_group() functions.

Assume situation when there is one Session between Target and Initiator. Initiator sends Logout request to Target and at same time Target deletes portal group (for example targetcli clearconfig confirm=True executed).
Logout session request came first (cmd->iscsi_opcode == ISCSI_OP_LOGOUT, cmd->logout_reason == ISCSI_LOGOUT_REASON_CLOSE_SESSION)
Target invokes iscsit_logout_closesession() (that updates session->session_logout flag to 1) and executes logout response command (cmd->i_state = ISTATE_SEND_LOGOUTRSP).
After logout request received Target invokes iscsit_tpg_del_portal_group(). That functions invokes iscsit_release_sessions_for_tpg() which iterate through all active sessions and frees them. 
In our case session is during logout process so it will be ignored. iscsit_release_sessions_for_tpg() does nothing and just returns 0. 
iscsit_tpg_del_portal_group() invocation will continue and free target portal group by calling kfree(tpg).
During iscsit_tpg_del_portal_group() call logout response command has been successfully delivered and Target invokes iscsit_logout_post_handler(). That function invocation leads to transport_free_session() call which tries to dereference pointer to struct se_portal_group that was previously freed by iscsit_tpg_del_portal_group(). 

Described situation lead to crash: 

Oops: 0000 [#1] SMP PTI                                                                  
Workqueue: isert_comp_wq isert_do_control_comp [ib_isert]                                                                                                                                                                     
task: ffff93a04ac89740 task.stack: ffff9f3907044000                                                                                                                                                                           
RIP: 0010:transport_free_session+0x2a/0x140 [target_core_mod]                                                                                                                                                                 
RSP: 0018:ffff9f3907047da8 EFLAGS: 00010286                                                                                                                                                                                   
RAX: 0000000000000282 RBX: ffff93a1f0ae6400 RCX: dead000000000200                                                                                                                                                             
RDX: ffff93a22b8f10a0 RSI: 0000000000000282 RDI: ffff93a1f0ae6400                                                                                                                                                             
RBP: ffff9f3907047dd0 R08: 0000000000000000 R09: 0000000000000000                                                                                                                                                             
R10: ffff9f3907047d98 R11: 0000000000000058 R12: ffff93a22f3a0000                                                                                                                                                             
R13: 0000000000000000 R14: 0000000000000008 R15: ffff93a22f6f3980                                                                                                                                                             
FS:  0000000000000000(0000) GS:ffff93a233a00000(0000) knlGS:0000000000000000                                                                                                                                                  
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                                                                                                                             
CR2: 0000000000000090 CR3: 000000020800a004 CR4: 00000000000606f0                                                                                                                                                             
Call Trace:                                                                                                                                                                                                                   
transport_deregister_session+0x7e/0xc0 [target_core_mod]                                                                                                                                                                     
iscsit_close_session+0x92/0x200 [iscsi_target_mod]                                                                                                                                                                           
iscsit_logout_post_handler+0x180/0x220 [iscsi_target_mod]                                                                                                                                                                    
isert_do_control_comp+0x88/0xd0 [ib_isert]                                                                                                                                                                                   
process_one_work+0x1ec/0x410                                                                                                                                                                                                 
? __wake_up+0x44/0x50                                                                                                                                                                                                        
worker_thread+0x32/0x410                                                                                                                                                                                                     
kthread+0x128/0x140                                                                                                                                                                                                          
? process_one_work+0x410/0x410                                                                                                                                                                                               
? kthread_create_on_node+0x70/0x70                                                                                                                                                                                           
ret_from_fork+0x35/0x40                                                                                                                                                                                                      
Code: 00 66 66 66 66 90 55 48 89 e5 41 57 41 56 41 55 41 54 53 4c 8b 67 18 48 89 fb 4d 85 e4 74 59 4d 8b ac 24 48 01 00 00 4d 8d 75 08 <4d> 8b bd 90 00 00 00 48 c7 47 18 00 00 00 00 4c 89 f7 e8 7f c9                       
RIP: transport_free_session+0x2a/0x140 [target_core_mod] RSP: ffff9f3907047da8                                                                                                                                                
CR2: 0000000000000090                                                                                                                                                                                                         
---[ end trace a136fc59c1406d59 ]---                                                                                                                                                                                          
BUG: unable to handle kernel NULL pointer dereference at 0000000000000090                                                                                                                                                     
IP: transport_free_session+0x2a/0x140 [target_core_mod]   

Can you help us with that case? We want to know if we understand that behavior correctly and not missing something important.

Regards,
Oleksandr Bobro
