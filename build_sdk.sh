#!/bin/bash
# /mnt/c/intelFPGA_lite/20.1/quartus/bin64/quartus_sh.exe --flow compile Cy10LP_Eval
# wslpath -w $PWD
# quartus_cpf -c -n p -q 2MHz -g 3.3 $(DESIGN_NAME ).sof $(DESIGN_NAME).svf
export PATH=$PATH:/opt/riscv/bin
C_PATH=/opt/riscv/bin
QUARTUS_ROOTDIR=/mnt/c/intelFPGA_lite/20.1/quartus/bin64
SOPC_ROOTDIR=/mnt/c/intelFPGA_lite/20.1/quartus/sopc_builder/bin
DESIGN_TOP_NAME=kyogenrv_fpga_top
DESIGN_NAME=kyogenrv_fpga


RISCV_PROJ_DIR=/mnt/c/RISCV/kyogenrv
RISCV_WINDIR=`wslpath -w ${RISCV_PROJ_DIR}`

SVFDIR=${RISCV_PROJ_DIR}/fpga
SVFDIRW=`wslpath -w ${SVFDIR}`
QSYSDIR=${RISCV_PROJ_DIR}/fpga
QSYSDIRW=`wslpath -w ${QSYSDIR}`
SWDIR=${RISCV_PROJ_DIR}/src/sw
SWDIRW=`wslpath -w ${SWDIR}`
cd ${RISCV_PROJ_DIR}
make clean
make sdk

cd ${RISCV_PROJ_DIR}/fpga
#	${QUARTUS_ROOTDIR}/quartus_sh.exe --flow clean kyogenrv_fpga_top
${QUARTUS_ROOTDIR}/quartus_sh.exe --flow compile kyogenrv_fpga_top
cd ${SVFDIR}
${QUARTUS_ROOTDIR}/quartus_cpf.exe -c -n p -q 2MHz -g 3.3 ${SVFDIRW}/${DESIGN_TOP_NAME}.sof ${SVFDIRW}/${DESIGN_TOP_NAME}.svf
cd ${QSYSDIR}

${SOPC_ROOTDIR}/sopcinfo2swinfo.exe --input=${QSYSDIRW}/${DESIGN_NAME}.sopcinfo
${SOPC_ROOTDIR}/swinfo2header.exe --swinfo ${QSYSDIRW}/${DESIGN_NAME}.swinfo --module KyogenRV_0 --master avalon_data_master --single ${SWDIRW}/qsys_mem_map.h

#scp -r ${SVFDIR}/${DESIGN_TOP_NAME}.svf pi@raspberrypi.local:/home/pi
