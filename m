Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795872587;
	b=N/szpSisg3eUT/iwtA5vODQa6Llzn2kmMtLY1zM/ZNMLddX+ShkkVXtRIh0CQT//SFYc
	 vWjrGXgU4WUNPvdLlUbKFFQTSdXMQM8FeDGcSN8huYUH0NSRbq1PXkcB4RXOmAbIpy/YC
	 ZEdvoOYZ11VlPkJ+NigZaXEHd1SD5rUJy0WpIDEyE7Ns3vKuS/bBh6OSJjSCXoByJM+yL
	 37LjbdjXRoaeGfcY+CiNYKIUxBVXar7fH39n0z9E92lOjL4dY53DqCSZmr6roPeTiOgVS
	 o75HjA/Cy0vtDs13s9Tha/sRbYMmxNY2+kZtTwRn9Oi0B1EmjIOtycOabuX7UxDdzRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795872587;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bFpU4YVxZ/RwUXRsUgYhSip0F+zp9RPRNLHNtdsH2vs=;
	b=3Sfa00gteausNmHPTqLeT445vMWfK0cwP95hFe5rycmS2V3G/6wLTM8SnwKt3fVxJ9Qt
	 HWNrBPc7CJznxM+NObmxajQOI3stC9VobA4CrtWbX2nAM15qOBqicpm2Ai0p/mWeKcrP7
	 drY1jXiaJEWkip5eOArWwB7LbyZXHXSz6DTD1a+oVfoscCxM+Hlh74q4LGdvKbI3JTi6j
	 TELCJjmWZdmuKJfKn3QSTLzL5yQtbasZPZZz2qV9BnRII7YkzsswrmXAgVnaAvzWBQZFm
	 5oJEFT2rvm2CST+/yWXp4O14Q/cqsc8+xWfyBZxGX1QlulMHyTRhcYOASmDbF1/sigA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vDsG5Z42;
	arc=none smtp.remote-ip=115.124.30.97
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7A9606A31C;
	Sat, 28 Nov 2026 13:29:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F7A9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vDsG5Z42
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795872576; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=bFpU4YVxZ/RwUXRsUgYhSip0F+zp9RPRNLHNtdsH2vs=;
	b=vDsG5Z42/2kpU9y+anhVHOUbpc1hjnvqyF9n/GXvK6albZMK7V/hE9ex4toG9L1aN8MRPrqmC/di4AL8jQi+GofBS0J919Pa0qZsuKAMog0GVpa5OU5/65EERR2KX+YqiyupT8fPOs8dRQwh+aWjOBIKPamiGx8IzrpVWnFEt2Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=zoutao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0XFaU5ZY_1795872575;
Received: from localhost(mailfrom:zoutao@linux.alibaba.com fp:SMTPD_---0XFaU5ZY_1795872575 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 28 Nov 2026 21:29:35 +0800
From: Tao Zou <zoutao@linux.alibaba.com>
To: Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Tao Zou <zoutao@linux.alibaba.com>
Subject: [PATCH v2 0/1] tcmu: Fix inode use-after-free in global data block pool
Date: Sat, 28 Nov 2026 21:29:33 +0800
Message-Id: <20261128132934.11219-1-zoutao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261127023346.37933-1-zoutao@linux.alibaba.com>
References: <20261127023346.37933-1-zoutao@linux.alibaba.com>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

TCMU's global data block pool can dereference udev->inode after the VFS has
reclaimed the inode. tcmu_open() stores the pointer without taking a
reference, while delayed unmap work can still reach the configured device
through root_udev after the last UIO close.

I reproduced this on mainline using only user-space configuration and I/O.
On the unfixed 40212b29a6f718d4e7fb3275cede181cb8e137cf baseline, the
reproducer panics in down_read() through unmap_mapping_pages() and
find_free_blocks(). An earlier mainline build at
4dce97c6c265544342e716e62fd24bbb232590c5 produced the same target panic in
10/10 independent cold-boot runs.

Changes in v2:
- Drop the extra inode reference used by v1. It did not pin the mount or
  sb->s_active and could leave a busy inode during filesystem unmount.
- Protect udev->inode with cmdr_lock, clear it in tcmu_release(), and skip
  only mapping invalidation after the final close. Block reclamation still
  runs.

The open file and its VMAs already keep the inode alive while mappings
exist. By the time the final fput calls tcmu_release(), all VMAs mapping the
file have been closed, so no additional inode reference is needed.

With v2 applied on the 40212b29a6f718d4e7fb3275cede181cb8e137cf baseline,
the unchanged reproducer survived its full trigger sequence. The script's
exit code 42 is its explicit survival marker. Additional regression testing
completed 20 tcmu-runner restarts and 80 direct fio runs across four
devices, followed by successful destruction of all four devices.

I also tested the v1 unmount scenario with v2: after priming a real TCMU
device with fio, I opened and closed a character node on a separate tmpfs,
unmounted that tmpfs, reopened and closed the original UIO node, triggered
delayed global-block reclaim, and destroyed the device. All steps completed
without a busy-inode warning, BUG, Oops, WARNING, general protection fault,
or KASAN report.

Using tcmu-runner 1.6.2 built from commit
1bdb239fa183c84d2ace6b52aa33476968a0cef7, the portable reproducer also
triggered the target panic once each on Debian 13 (6.12.118+deb13-amd64),
Ubuntu 26.04.1 (7.0.0-44-generic), and CentOS Stream 10
(6.12.0-284.el10.x86_64). Ubuntu was tested again after moving from 2 vCPU
and 4 GiB to 4 vCPU and 8 GiB, without changing the reproducer. These are
single-run portability checks of the unfixed kernels, separate from the
mainline v2 tests.

The reproducer deliberately grooms shmem_inode_cache slab placement to make
the lifetime bug deterministic in the documented test environment; it is
not intended to estimate trigger probability under normal production loads.

WARNING: The reproducer is expected to panic a vulnerable kernel and must
only be run as root on a dedicated, disposable test VM with no data or other
workloads. Enable kdump before running if crash evidence is required.

The complete reproducer is included below as plain text. It requires
targetcli, tcmu-runner with its file handler, tcm_loop, fio, python3 and
udev. Test with init_on_free=1 panic_on_oops=1 on the kernel command line.

Thanks,
Tao Zou

----- BEGIN TCMU REPRODUCER: tcmu-inode-lifetime-reproducer.sh -----
#!/bin/bash
# WARNING: This script intentionally panics vulnerable kernels. Run it only
# as root on a dedicated, disposable VM with no data or other workloads.
# It requires targetcli, tcmu-runner with its file handler, tcm_loop, fio,
# python3 and udev. Test with init_on_free=1 panic_on_oops=1 on the kernel
# command line. Enable kdump before running if crash evidence is required.
set -euxo pipefail

DEVICE_COUNT=4
WWN=naa.5001405a11b22c40
IMAGE_PREFIX=/root/tcmu-userspace-page-zero
PARAM=/sys/module/target_core_user/parameters/global_max_data_area_mb
GUARD_DIR=/mnt/tcmu-page-zero-guards
MAX_GUARDS=4096
RUN_ID="$(date +%s%N)-$$"
RUN_DIR="/root/tcmu-userspace-runs/$RUN_ID"
mkdir -p "$RUN_DIR"
exec > >(tee "$RUN_DIR/reproduce.log") 2>&1

cat /etc/os-release
uname -a
[[ " $(cat /proc/cmdline) " == *" init_on_free=1 "* ]]
dmesg > "$RUN_DIR/dmesg-boot.txt"
grep -q 'heap free:on' "$RUN_DIR/dmesg-boot.txt"
[[ "$(cat /sys/kernel/slab/shmem_inode_cache/poison)" == 0 ]]
[[ "$(cat /proc/sys/kernel/panic_on_oops)" == 1 ]]
! grep -q '^spray ' /proc/modules
printf 'RUN_ID=%s\n' "$RUN_ID" | tee /root/tcmu-userspace-current-run
cat /proc/cmdline
cat /proc/sys/kernel/tainted
date -Ins
date +%s > "$RUN_DIR/start.epoch"
if command -v kdumpctl >/dev/null 2>&1; then
	kdumpctl status || true
fi
taskset -pc 0 $$

targetcli /loopback delete "$WWN" 2>/dev/null || true
for ((i = 0; i < DEVICE_COUNT; i++)); do
	targetcli /backstores/user:file delete "tcmu_page_zero_repro_${i}" 2>/dev/null || true
	rm -f "${IMAGE_PREFIX}-${i}.img"
done
udevadm settle

python3 - "$RUN_DIR/dev-paths-before.json" <<'PY'
import json
import os
import sys

paths = []
for root in ('/dev', '/run/udev'):
    for dirpath, dirnames, filenames in os.walk(root):
        paths.extend(os.path.join(dirpath, name) for name in dirnames + filenames)
with open(sys.argv[1], 'w') as output:
    json.dump(sorted(paths), output)
PY

mkdir -p "$GUARD_DIR"
if mountpoint -q "$GUARD_DIR"; then
    umount "$GUARD_DIR"
fi
mount -t tmpfs -o size=32M tmpfs "$GUARD_DIR"
mkdir "$GUARD_DIR/pre" "$GUARD_DIR/post"
printf '512\n' > "$PARAM"
systemctl start tcmu-runner
systemctl is-active tcmu-runner
taskset -apc 0 "$(systemctl show -p MainPID --value tcmu-runner)"
taskset -apc 0 "$(systemctl show -p MainPID --value systemd-udevd)"
if pgrep -x kdevtmpfs >/dev/null; then
    taskset -pc 0 "$(pgrep -x kdevtmpfs)"
fi

slab_count() {
    set -- $(grep '^shmem_inode_cache ' /proc/slabinfo)
    printf '%s\n' "${15}"
}

PRE_GUARD_COUNT=0
FRESH_SLABS=''

shopt -s nullglob
before_sd_paths=(/sys/class/block/sd*)
declare -A before_sd=()
for path in "${before_sd_paths[@]}"; do
    before_sd["${path##*/}"]=1
done

for ((i = 0; i < DEVICE_COUNT; i++)); do
    fresh=''
    for ((guard = 0; guard < MAX_GUARDS; guard++)); do
        old_count="$(slab_count)"
        : > "$GUARD_DIR/pre/g$PRE_GUARD_COUNT"
        PRE_GUARD_COUNT=$((PRE_GUARD_COUNT + 1))
        new_count="$(slab_count)"
        if ((new_count > old_count)); then
            fresh="$new_count"
            break
        fi
    done
    [[ -n "$fresh" ]]
    FRESH_SLABS="${FRESH_SLABS:+$FRESH_SLABS,}$fresh"
    image="${IMAGE_PREFIX}-${i}.img"
    name="tcmu_page_zero_repro_${i}"
    truncate -s 64M "$image"
    targetcli /backstores/user:file create name="$name" cfgstring="$image" size=64M
    udevadm settle
done
udevadm settle
uio_paths=(/dev/uio[0-9]*)
(( ${#uio_paths[@]} == DEVICE_COUNT ))
: > "$RUN_DIR/uio-stat.txt"
for UIO in "${uio_paths[@]}"; do
    [[ -c "$UIO" ]]
    stat --printf='path=%n dev=%d ino=%i mode=%f rdev=%r\n' "$UIO" | tee -a "$RUN_DIR/uio-stat.txt"
done
targetcli ls > "$RUN_DIR/targetcli-before-io.txt"

targetcli /loopback create "$WWN"
for ((i = 0; i < DEVICE_COUNT; i++)); do
    targetcli "/loopback/$WWN/luns" create "/backstores/user:file/tcmu_page_zero_repro_${i}"
done
for scan in /sys/class/scsi_host/host*/scan; do
    printf -- '- - -\n' > "$scan"
done
udevadm settle
new_sd_paths=()
for path in /sys/class/block/sd*; do
    if [[ -z "${before_sd[${path##*/}]+present}" ]]; then
        new_sd_paths+=("$path")
    fi
done
(( ${#new_sd_paths[@]} == DEVICE_COUNT ))
printf 'DEVICE_COUNT=%s\n' "$DEVICE_COUNT" > "$RUN_DIR/devices.env"
printf 'UIO_PATHS=%s\n' "${uio_paths[*]}" >> "$RUN_DIR/devices.env"
for ((i = 0; i < DEVICE_COUNT; i++)); do
    SD_DEVICE="/dev/${new_sd_paths[$i]##*/}"
    [[ -b "$SD_DEVICE" ]]
    printf 'SD_DEVICE_%s=%s\n' "$i" "$SD_DEVICE" | tee -a "$RUN_DIR/devices.env"
    properties="$RUN_DIR/scsi-device-${i}.properties"
    udevadm info --query=property --name="$SD_DEVICE" | tee "$properties"
    grep -q '^ID_VENDOR=LIO-ORG$' "$properties"
    grep -q '^DEVPATH=/devices/tcm_loop_' "$properties"
    printf 'running\n' > "/sys/block/${SD_DEVICE##*/}/device/state"
    timeout 45s fio --name="tcmu-userspace-page-zero-${i}" --filename="$SD_DEVICE" --direct=1 --ioengine=libaio --rw=write --bs=1M --size=64M --iodepth=32 --group_reporting > "$RUN_DIR/fio-${i}.log" 2>&1
    cat "$RUN_DIR/fio-${i}.log"
done
POST_GUARD_COUNT=0
SEALED_SLABS=''
for ((i = 0; i < MAX_GUARDS; i++)); do
    old_count="$(slab_count)"
    : > "$GUARD_DIR/post/g$i"
    POST_GUARD_COUNT=$((POST_GUARD_COUNT + 1))
    new_count="$(slab_count)"
    if ((new_count > old_count)); then
        SEALED_SLABS="$new_count"
        break
    fi
done
[[ -n "$SEALED_SLABS" ]]
printf 'PRE_GUARD_COUNT=%s\nPOST_GUARD_COUNT=%s\nFRESH_SLABS=%s\nSEALED_SLABS=%s\n' \
    "$PRE_GUARD_COUNT" "$POST_GUARD_COUNT" "$FRESH_SLABS" "$SEALED_SLABS" | tee "$RUN_DIR/guards.env"

systemctl stop tcmu-runner
systemctl is-active tcmu-runner || true
: > "$RUN_DIR/uio-holders.txt"
for UIO in "${uio_paths[@]}"; do
    if fuser "$UIO" >> "$RUN_DIR/uio-holders.txt" 2>&1; then
        cat "$RUN_DIR/uio-holders.txt"
        exit 1
    fi
done
systemctl stop systemd-udevd-kernel.socket systemd-udevd-control.socket systemd-udevd
systemctl is-active systemd-udevd || true
dmesg > "$RUN_DIR/dmesg-before-trigger.txt"
printf 'armed_epoch=%s\n' "$(date +%s)" | tee "$RUN_DIR/armed.env"

python3 - "$RUN_DIR/dev-paths-before.json" "$RUN_DIR/created-paths-removed.txt" <<'PY'
import json
import os
import stat
import sys

with open(sys.argv[1]) as source:
    before = set(json.load(source))
paths = []
for root in ('/dev', '/run/udev'):
    for dirpath, dirnames, filenames in os.walk(root):
        paths.extend(os.path.join(dirpath, name) for name in dirnames + filenames)
created = sorted(set(paths) - before)
with open(sys.argv[2], 'w') as output:
    for path in created:
        output.write(path + '\n')
for path in created:
    try:
        if not stat.S_ISDIR(os.lstat(path).st_mode):
            os.unlink(path)
    except FileNotFoundError:
        pass
for path in sorted(created, key=len, reverse=True):
    try:
        if stat.S_ISDIR(os.lstat(path).st_mode):
            os.rmdir(path)
    except FileNotFoundError:
        pass
PY
rm -f /run/rtslib_backstore.lock
python3 - "$GUARD_DIR" <<'PY'
import os
import sys

for group in ('pre', 'post'):
    root = os.path.join(sys.argv[1], group)
    for name in os.listdir(root):
        os.unlink(os.path.join(root, name))
    os.rmdir(root)
PY
umount "$GUARD_DIR"
printf '2\n' > /proc/sys/vm/drop_caches
grep '^shmem_inode_cache ' /proc/slabinfo > "$RUN_DIR/slabinfo-before-shrink.txt"
printf '1\n' > /sys/kernel/slab/shmem_inode_cache/shrink
printf '1\n' > "$PARAM"
grep '^shmem_inode_cache ' /proc/slabinfo > "$RUN_DIR/slabinfo-after-shrink.txt"
cat "$RUN_DIR/slabinfo-before-shrink.txt" "$RUN_DIR/slabinfo-after-shrink.txt"

sleep 15
cat "$PARAM"
dmesg > "$RUN_DIR/dmesg-after-trigger.txt"
printf 'survived=1\n' | tee "$RUN_DIR/survived.env"
exit 42
----- END TCMU REPRODUCER -----
