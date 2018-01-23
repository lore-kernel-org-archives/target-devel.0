From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 23 Jan 2018 14:05:50 +0000
Subject: [bug report] cxgbit: add files for cxgbit.ko
Message-Id: <20180123140550.GA31371@mwanda>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Varun Prakash,

The patch 9730ffcb8957: "cxgbit: add files for cxgbit.ko" from Apr
20, 2016, leads to the following static checker warning:

	drivers/target/iscsi/cxgbit/cxgbit_target.c:1443 cxgbit_lro_skb_merge()
	error: buffer overflow 'ssi->frags' 17 <= 255

drivers/target/iscsi/cxgbit/cxgbit_target.c
  1425  static void
  1426  cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
  1427  {
  1428          struct sk_buff *hskb = csk->lro_hskb;
  1429          struct cxgbit_lro_pdu_cb *hpdu_cb = cxgbit_skb_lro_pdu_cb(hskb, 0);
  1430          struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb, pdu_idx);
                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Smatch marks pdu_cb as tainted because it comes from skb->data

  1431          struct skb_shared_info *hssi = skb_shinfo(hskb);
  1432          struct skb_shared_info *ssi = skb_shinfo(skb);
  1433          unsigned int len = 0;
  1434  
  1435          if (pdu_cb->flags & PDUCBF_RX_HDR) {
  1436                  u8 hfrag_idx = hssi->nr_frags;
  1437  
  1438                  hpdu_cb->flags |= pdu_cb->flags;
  1439                  hpdu_cb->seq = pdu_cb->seq;
  1440                  hpdu_cb->hdr = pdu_cb->hdr;
  1441                  hpdu_cb->hlen = pdu_cb->hlen;
  1442  
  1443                  memcpy(&hssi->frags[hfrag_idx], &ssi->frags[pdu_cb->hfrag_idx],
                                                                    ^^^^^^^^^^^^^^^^^
how do we know this is within bounds?

  1444                         sizeof(skb_frag_t));
  1445  
  1446                  get_page(skb_frag_page(&hssi->frags[hfrag_idx]));
  1447                  hssi->nr_frags++;
  1448                  hpdu_cb->frags++;
  1449                  hpdu_cb->hfrag_idx = hfrag_idx;
  1450  
  1451                  len = hssi->frags[hfrag_idx].size;
  1452                  hskb->len += len;
  1453                  hskb->data_len += len;
  1454                  hskb->truesize += len;
  1455          }

regards,
dan carpenter
