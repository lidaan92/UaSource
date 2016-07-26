%TESTMM compare mread and mmread for entire Matrix Market collection
% Example:
%   testmm
% See also mread.
% Requires the mmread MATLAB m-file from http://www.nist.gov

% Copyright 2007, Timothy A. Davis, http://www.suitesparse.com

matrices = {
    'M/Harwell-Boeing/acoust/young1c.mtx', ...
    'M/Harwell-Boeing/acoust/young2c.mtx', ...
    'M/Harwell-Boeing/acoust/young3c.mtx', ...
    'M/Harwell-Boeing/acoust/young4c.mtx', ...
    'M/Harwell-Boeing/airtfc/zenios.mtx', ...
    'M/Harwell-Boeing/astroph/mcca.mtx', ...
    'M/Harwell-Boeing/astroph/mcfe.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr01.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr02.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr03.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr04.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr05.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr06.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr07.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr08.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr09.mtx', ...
    'M/Harwell-Boeing/bcspwr/bcspwr10.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk01.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk02.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk03.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk04.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk05.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk06.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk07.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk08.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk09.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk10.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk11.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk12.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstk13.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm01.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm02.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm03.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm04.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm05.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm06.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm07.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm08.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm09.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm10.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm11.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm12.mtx', ...
    'M/Harwell-Boeing/bcsstruc1/bcsstm13.mtx', ...
    'M/Harwell-Boeing/bcsstruc2/bcsstk14.mtx', ...
    'M/Harwell-Boeing/bcsstruc2/bcsstk15.mtx', ...
    'M/Harwell-Boeing/bcsstruc2/bcsstk16.mtx', ...
    'M/Harwell-Boeing/bcsstruc2/bcsstk17.mtx', ...
    'M/Harwell-Boeing/bcsstruc2/bcsstk18.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstk19.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstk20.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstk21.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstk22.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstk23.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstk24.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstk25.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstm19.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstm20.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstm21.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstm22.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstm23.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstm24.mtx', ...
    'M/Harwell-Boeing/bcsstruc3/bcsstm25.mtx', ...
    'M/Harwell-Boeing/bcsstruc4/bcsstk26.mtx', ...
    'M/Harwell-Boeing/bcsstruc4/bcsstk27.mtx', ...
    'M/Harwell-Boeing/bcsstruc4/bcsstk28.mtx', ...
    'M/Harwell-Boeing/bcsstruc4/bcsstm26.mtx', ...
    'M/Harwell-Boeing/bcsstruc4/bcsstm27.mtx', ...
    'M/Harwell-Boeing/bcsstruc5/bcsstk29.mtx', ...
    'M/Harwell-Boeing/bcsstruc5/bcsstk30.mtx', ...
    'M/Harwell-Boeing/bcsstruc5/bcsstk31.mtx', ...
    'M/Harwell-Boeing/bcsstruc5/bcsstk32.mtx', ...
    'M/Harwell-Boeing/bcsstruc5/bcsstk33.mtx', ...
    'M/Harwell-Boeing/bcsstruc6/blckhole.mtx', ...
    'M/Harwell-Boeing/bcsstruc6/sstmodel.mtx', ...
    'M/Harwell-Boeing/cannes/can_1054.mtx', ...
    'M/Harwell-Boeing/cannes/can_1072.mtx', ...
    'M/Harwell-Boeing/cannes/can__144.mtx', ...
    'M/Harwell-Boeing/cannes/can__161.mtx', ...
    'M/Harwell-Boeing/cannes/can__187.mtx', ...
    'M/Harwell-Boeing/cannes/can__229.mtx', ...
    'M/Harwell-Boeing/cannes/can___24.mtx', ...
    'M/Harwell-Boeing/cannes/can__256.mtx', ...
    'M/Harwell-Boeing/cannes/can__268.mtx', ...
    'M/Harwell-Boeing/cannes/can__292.mtx', ...
    'M/Harwell-Boeing/cannes/can__445.mtx', ...
    'M/Harwell-Boeing/cannes/can___61.mtx', ...
    'M/Harwell-Boeing/cannes/can___62.mtx', ...
    'M/Harwell-Boeing/cannes/can__634.mtx', ...
    'M/Harwell-Boeing/cannes/can__715.mtx', ...
    'M/Harwell-Boeing/cannes/can___73.mtx', ...
    'M/Harwell-Boeing/cannes/can__838.mtx', ...
    'M/Harwell-Boeing/cannes/can___96.mtx', ...
    'M/Harwell-Boeing/chemimp/impcol_a.mtx', ...
    'M/Harwell-Boeing/chemimp/impcol_b.mtx', ...
    'M/Harwell-Boeing/chemimp/impcol_c.mtx', ...
    'M/Harwell-Boeing/chemimp/impcol_d.mtx', ...
    'M/Harwell-Boeing/chemimp/impcol_e.mtx', ...
    'M/Harwell-Boeing/chemwest/west0067.mtx', ...
    'M/Harwell-Boeing/chemwest/west0132.mtx', ...
    'M/Harwell-Boeing/chemwest/west0156.mtx', ...
    'M/Harwell-Boeing/chemwest/west0167.mtx', ...
    'M/Harwell-Boeing/chemwest/west0381.mtx', ...
    'M/Harwell-Boeing/chemwest/west0479.mtx', ...
    'M/Harwell-Boeing/chemwest/west0497.mtx', ...
    'M/Harwell-Boeing/chemwest/west0655.mtx', ...
    'M/Harwell-Boeing/chemwest/west0989.mtx', ...
    'M/Harwell-Boeing/chemwest/west1505.mtx', ...
    'M/Harwell-Boeing/chemwest/west2021.mtx', ...
    'M/Harwell-Boeing/cirphys/jpwh_991.mtx', ...
    'M/Harwell-Boeing/counterx/jgl009.mtx', ...
    'M/Harwell-Boeing/counterx/jgl011.mtx', ...
    'M/Harwell-Boeing/counterx/rgg010.mtx', ...
    'M/Harwell-Boeing/dwt/dwt_1005.mtx', ...
    'M/Harwell-Boeing/dwt/dwt_1007.mtx', ...
    'M/Harwell-Boeing/dwt/dwt_1242.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__162.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__193.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__198.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__209.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__221.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__234.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__245.mtx', ...
    'M/Harwell-Boeing/dwt/dwt_2680.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__307.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__310.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__346.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__361.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__419.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__492.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__503.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__512.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__592.mtx', ...
    'M/Harwell-Boeing/dwt/dwt___59.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__607.mtx', ...
    'M/Harwell-Boeing/dwt/dwt___66.mtx', ...
    'M/Harwell-Boeing/dwt/dwt___72.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__758.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__869.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__878.mtx', ...
    'M/Harwell-Boeing/dwt/dwt___87.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__918.mtx', ...
    'M/Harwell-Boeing/dwt/dwt__992.mtx', ...
    'M/Harwell-Boeing/econaus/mahindas.mtx', ...
    'M/Harwell-Boeing/econaus/orani678.mtx', ...
    'M/Harwell-Boeing/econiea/beacxc.mtx', ...
    'M/Harwell-Boeing/econiea/beaflw.mtx', ...
    'M/Harwell-Boeing/econiea/beause.mtx', ...
    'M/Harwell-Boeing/econiea/mbeacxc.mtx', ...
    'M/Harwell-Boeing/econiea/mbeaflw.mtx', ...
    'M/Harwell-Boeing/econiea/mbeause.mtx', ...
    'M/Harwell-Boeing/econiea/wm1.mtx', ...
    'M/Harwell-Boeing/econiea/wm2.mtx', ...
    'M/Harwell-Boeing/econiea/wm3.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_183_1.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_183_3.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_183_4.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_183_6.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_680_1.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_680_2.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_680_3.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_760_1.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_760_2.mtx', ...
    'M/Harwell-Boeing/facsimile/fs_760_3.mtx', ...
    'M/Harwell-Boeing/gemat/gemat11.mtx', ...
    'M/Harwell-Boeing/gemat/gemat12.mtx', ...
    'M/Harwell-Boeing/gemat/gemat1.mtx', ...
    'M/Harwell-Boeing/grenoble/gre_1107.mtx', ...
    'M/Harwell-Boeing/grenoble/gre__115.mtx', ...
    'M/Harwell-Boeing/grenoble/gre__185.mtx', ...
    'M/Harwell-Boeing/grenoble/gre_216a.mtx', ...
    'M/Harwell-Boeing/grenoble/gre_216b.mtx', ...
    'M/Harwell-Boeing/grenoble/gre__343.mtx', ...
    'M/Harwell-Boeing/grenoble/gre__512.mtx', ...
    'M/Harwell-Boeing/jagmsh/jagmsh1.mtx', ...
    'M/Harwell-Boeing/jagmsh/jagmsh2.mtx', ...
    'M/Harwell-Boeing/jagmsh/jagmsh3.mtx', ...
    'M/Harwell-Boeing/jagmsh/jagmsh4.mtx', ...
    'M/Harwell-Boeing/jagmsh/jagmsh5.mtx', ...
    'M/Harwell-Boeing/jagmsh/jagmsh6.mtx', ...
    'M/Harwell-Boeing/jagmsh/jagmsh7.mtx', ...
    'M/Harwell-Boeing/jagmsh/jagmsh8.mtx', ...
    'M/Harwell-Boeing/jagmsh/jagmsh9.mtx', ...
    'M/Harwell-Boeing/lanpro/nos1.mtx', ...
    'M/Harwell-Boeing/lanpro/nos2.mtx', ...
    'M/Harwell-Boeing/lanpro/nos3.mtx', ...
    'M/Harwell-Boeing/lanpro/nos4.mtx', ...
    'M/Harwell-Boeing/lanpro/nos5.mtx', ...
    'M/Harwell-Boeing/lanpro/nos6.mtx', ...
    'M/Harwell-Boeing/lanpro/nos7.mtx', ...
    'M/Harwell-Boeing/laplace/gr_30_30.mtx', ...
    'M/Harwell-Boeing/lns/lns__131.mtx', ...
    'M/Harwell-Boeing/lns/lns_3937.mtx', ...
    'M/Harwell-Boeing/lns/lns__511.mtx', ...
    'M/Harwell-Boeing/lns/lnsp_131.mtx', ...
    'M/Harwell-Boeing/lns/lnsp3937.mtx', ...
    'M/Harwell-Boeing/lns/lnsp_511.mtx', ...
    'M/Harwell-Boeing/lshape/lshp1009.mtx', ...
    'M/Harwell-Boeing/lshape/lshp1270.mtx', ...
    'M/Harwell-Boeing/lshape/lshp1561.mtx', ...
    'M/Harwell-Boeing/lshape/lshp1882.mtx', ...
    'M/Harwell-Boeing/lshape/lshp2233.mtx', ...
    'M/Harwell-Boeing/lshape/lshp2614.mtx', ...
    'M/Harwell-Boeing/lshape/lshp_265.mtx', ...
    'M/Harwell-Boeing/lshape/lshp3025.mtx', ...
    'M/Harwell-Boeing/lshape/lshp3466.mtx', ...
    'M/Harwell-Boeing/lshape/lshp_406.mtx', ...
    'M/Harwell-Boeing/lshape/lshp_577.mtx', ...
    'M/Harwell-Boeing/lshape/lshp_778.mtx', ...
    'M/Harwell-Boeing/lsq/illc1033.mtx', ...
    'M/Harwell-Boeing/lsq/illc1850.mtx', ...
    'M/Harwell-Boeing/lsq/well1033.mtx', ...
    'M/Harwell-Boeing/lsq/well1850.mtx', ...
    'M/Harwell-Boeing/nnceng/hor__131.mtx', ...
    'M/Harwell-Boeing/nucl/nnc1374.mtx', ...
    'M/Harwell-Boeing/nucl/nnc261.mtx', ...
    'M/Harwell-Boeing/nucl/nnc666.mtx', ...
    'M/Harwell-Boeing/oilgen/orsirr_1.mtx', ...
    'M/Harwell-Boeing/oilgen/orsirr_2.mtx', ...
    'M/Harwell-Boeing/oilgen/orsreg_1.mtx', ...
    'M/Harwell-Boeing/platz/plat1919.mtx', ...
    'M/Harwell-Boeing/platz/plat362.mtx', ...
    'M/Harwell-Boeing/platz/plsk1919.mtx', ...
    'M/Harwell-Boeing/platz/plskz362.mtx', ...
    'M/Harwell-Boeing/pores/pores_1.mtx', ...
    'M/Harwell-Boeing/pores/pores_2.mtx', ...
    'M/Harwell-Boeing/pores/pores_3.mtx', ...
    'M/Harwell-Boeing/psadmit/1138_bus.mtx', ...
    'M/Harwell-Boeing/psadmit/494_bus.mtx', ...
    'M/Harwell-Boeing/psadmit/662_bus.mtx', ...
    'M/Harwell-Boeing/psadmit/685_bus.mtx', ...
    'M/Harwell-Boeing/psmigr/psmigr_1.mtx', ...
    'M/Harwell-Boeing/psmigr/psmigr_2.mtx', ...
    'M/Harwell-Boeing/psmigr/psmigr_3.mtx', ...
    'M/Harwell-Boeing/saylor/saylr1.mtx', ...
    'M/Harwell-Boeing/saylor/saylr3.mtx', ...
    'M/Harwell-Boeing/saylor/saylr4.mtx', ...
    'M/Harwell-Boeing/sherman/sherman1.mtx', ...
    'M/Harwell-Boeing/sherman/sherman2.mtx', ...
    'M/Harwell-Boeing/sherman/sherman3.mtx', ...
    'M/Harwell-Boeing/sherman/sherman4.mtx', ...
    'M/Harwell-Boeing/sherman/sherman5.mtx', ...
    'M/Harwell-Boeing/smtape/abb313.mtx', ...
    'M/Harwell-Boeing/smtape/arc130.mtx', ...
    'M/Harwell-Boeing/smtape/ash219.mtx', ...
    'M/Harwell-Boeing/smtape/ash292.mtx', ...
    'M/Harwell-Boeing/smtape/ash331.mtx', ...
    'M/Harwell-Boeing/smtape/ash608.mtx', ...
    'M/Harwell-Boeing/smtape/ash85.mtx', ...
    'M/Harwell-Boeing/smtape/bp_____0.mtx', ...
    'M/Harwell-Boeing/smtape/bp__1000.mtx', ...
    'M/Harwell-Boeing/smtape/bp__1200.mtx', ...
    'M/Harwell-Boeing/smtape/bp__1400.mtx', ...
    'M/Harwell-Boeing/smtape/bp__1600.mtx', ...
    'M/Harwell-Boeing/smtape/bp___200.mtx', ...
    'M/Harwell-Boeing/smtape/bp___400.mtx', ...
    'M/Harwell-Boeing/smtape/bp___600.mtx', ...
    'M/Harwell-Boeing/smtape/bp___800.mtx', ...
    'M/Harwell-Boeing/smtape/curtis54.mtx', ...
    'M/Harwell-Boeing/smtape/eris1176.mtx', ...
    'M/Harwell-Boeing/smtape/fs_541_1.mtx', ...
    'M/Harwell-Boeing/smtape/fs_541_2.mtx', ...
    'M/Harwell-Boeing/smtape/fs_541_3.mtx', ...
    'M/Harwell-Boeing/smtape/fs_541_4.mtx', ...
    'M/Harwell-Boeing/smtape/gent113.mtx', ...
    'M/Harwell-Boeing/smtape/ibm32.mtx', ...
    'M/Harwell-Boeing/smtape/lund_a.mtx', ...
    'M/Harwell-Boeing/smtape/lund_b.mtx', ...
    'M/Harwell-Boeing/smtape/shl____0.mtx', ...
    'M/Harwell-Boeing/smtape/shl__200.mtx', ...
    'M/Harwell-Boeing/smtape/shl__400.mtx', ...
    'M/Harwell-Boeing/smtape/str____0.mtx', ...
    'M/Harwell-Boeing/smtape/str__200.mtx', ...
    'M/Harwell-Boeing/smtape/str__400.mtx', ...
    'M/Harwell-Boeing/smtape/str__600.mtx', ...
    'M/Harwell-Boeing/smtape/will199.mtx', ...
    'M/Harwell-Boeing/smtape/will57.mtx', ...
    'M/Harwell-Boeing/steam/steam1.mtx', ...
    'M/Harwell-Boeing/steam/steam2.mtx', ...
    'M/Harwell-Boeing/steam/steam3.mtx', ...
    'M/Harwell-Boeing/watt/watt__1.mtx', ...
    'M/Harwell-Boeing/watt/watt__2.mtx', ...
    'M/misc/cylshell/s1rmq4m1.mtx', ...
    'M/misc/cylshell/s1rmt3m1.mtx', ...
    'M/misc/cylshell/s2rmq4m1.mtx', ...
    'M/misc/cylshell/s3dkq4m2.mtx', ...
    'M/misc/cylshell/s3dkt3m2.mtx', ...
    'M/misc/cylshell/s3rmq4m1.mtx', ...
    'M/misc/cylshell/s3rmt3m1.mtx', ...
    'M/misc/cylshell/s3rmt3m3.mtx', ...
    'M/misc/hamm/add20.mtx', ...
    'M/misc/hamm/add32.mtx', ...
    'M/misc/hamm/memplus.mtx', ...
    'M/misc/pts5ldd0/pts5ldd03.mtx', ...
    'M/misc/pts5ldd0/pts5ldd04.mtx', ...
    'M/misc/pts5ldd0/pts5ldd05.mtx', ...
    'M/misc/pts5ldd0/pts5ldd06.mtx', ...
    'M/misc/pts5ldd0/pts5ldd07.mtx', ...
    'M/misc/pts5ldd1/pts5ldd13.mtx', ...
    'M/misc/pts5ldd1/pts5ldd14.mtx', ...
    'M/misc/pts5ldd1/pts5ldd15.mtx', ...
    'M/misc/pts5ldd1/pts5ldd16.mtx', ...
    'M/misc/pts5ldd1/pts5ldd17.mtx', ...
    'M/misc/pts5ldd2/pts5ldd23.mtx', ...
    'M/misc/pts5ldd2/pts5ldd24.mtx', ...
    'M/misc/pts5ldd2/pts5ldd25.mtx', ...
    'M/misc/pts5ldd2/pts5ldd26.mtx', ...
    'M/misc/pts5ldd2/pts5ldd27.mtx', ...
    'M/misc/qcd/conf5.0-00l4x4-1000.mtx', ...
    'M/misc/qcd/conf5.0-00l4x4-1400.mtx', ...
    'M/misc/qcd/conf5.0-00l4x4-1800.mtx', ...
    'M/misc/qcd/conf5.0-00l4x4-2200.mtx', ...
    'M/misc/qcd/conf5.0-00l4x4-2600.mtx', ...
    'M/misc/qcd/conf5.4-00l8x8-0500.mtx', ...
    'M/misc/qcd/conf5.4-00l8x8-1000.mtx', ...
    'M/misc/qcd/conf5.4-00l8x8-1500.mtx', ...
    'M/misc/qcd/conf5.4-00l8x8-2000.mtx', ...
    'M/misc/qcd/conf6.0-00l4x4-2000.mtx', ...
    'M/misc/qcd/conf6.0-00l4x4-3000.mtx', ...
    'M/misc/qcd/conf6.0-00l8x8-2000.mtx', ...
    'M/misc/qcd/conf6.0-00l8x8-3000.mtx', ...
    'M/misc/qcd/conf6.0-00l8x8-8000.mtx', ...
    'M/NEP/airfoil/af23560.mtx', ...
    'M/NEP/bfwave/bfw398a.mtx', ...
    'M/NEP/bfwave/bfw398b.mtx', ...
    'M/NEP/bfwave/bfw62a.mtx', ...
    'M/NEP/bfwave/bfw62b.mtx', ...
    'M/NEP/bfwave/bfw782a.mtx', ...
    'M/NEP/bfwave/bfw782b.mtx', ...
    'M/NEP/brussel/rdb1250l.mtx', ...
    'M/NEP/brussel/rdb1250.mtx', ...
    'M/NEP/brussel/rdb200l.mtx', ...
    'M/NEP/brussel/rdb200.mtx', ...
    'M/NEP/brussel/rdb2048l.mtx', ...
    'M/NEP/brussel/rdb2048.mtx', ...
    'M/NEP/brussel/rdb3200l.mtx', ...
    'M/NEP/brussel/rdb450l.mtx', ...
    'M/NEP/brussel/rdb450.mtx', ...
    'M/NEP/brussel/rdb800l.mtx', ...
    'M/NEP/brussel/rdb968.mtx', ...
    'M/NEP/chuck/ck104.mtx', ...
    'M/NEP/chuck/ck400.mtx', ...
    'M/NEP/chuck/ck656.mtx', ...
    'M/NEP/crystal/cry10000.mtx', ...
    'M/NEP/crystal/cry2500.mtx', ...
    'M/NEP/dwave/dw2048.mtx', ...
    'M/NEP/dwave/dw8192.mtx', ...
    'M/NEP/dwave/dwa512.mtx', ...
    'M/NEP/dwave/dwb512.mtx', ...
    'M/NEP/gedney/dwg961a.mtx', ...
    'M/NEP/gedney/dwg961b.mtx', ...
    'M/NEP/h2plus/qc2534.mtx', ...
    'M/NEP/h2plus/qc324.mtx', ...
    'M/NEP/matpde/pde225.mtx', ...
    'M/NEP/matpde/pde2961.mtx', ...
    'M/NEP/matpde/pde900.mtx', ...
    'M/NEP/mhd/mhd1280a.mtx', ...
    'M/NEP/mhd/mhd1280b.mtx', ...
    'M/NEP/mhd/mhd3200a.mtx', ...
    'M/NEP/mhd/mhd3200b.mtx', ...
    'M/NEP/mhd/mhd416a.mtx', ...
    'M/NEP/mhd/mhd416b.mtx', ...
    'M/NEP/mhd/mhd4800a.mtx', ...
    'M/NEP/mhd/mhd4800b.mtx', ...
    'M/NEP/mvmbwm/bwm2000.mtx', ...
    'M/NEP/mvmbwm/bwm200.mtx', ...
    'M/NEP/mvmmcd/cdde1.mtx', ...
    'M/NEP/mvmmcd/cdde2.mtx', ...
    'M/NEP/mvmmcd/cdde3.mtx', ...
    'M/NEP/mvmmcd/cdde4.mtx', ...
    'M/NEP/mvmmcd/cdde5.mtx', ...
    'M/NEP/mvmmcd/cdde6.mtx', ...
    'M/NEP/mvmode/odep400a.mtx', ...
    'M/NEP/mvmode/odep400b.mtx', ...
    'M/NEP/mvmrwk/rw136.mtx', ...
    'M/NEP/mvmrwk/rw496.mtx', ...
    'M/NEP/mvmrwk/rw5151.mtx', ...
    'M/NEP/mvmtls/tols1090.mtx', ...
    'M/NEP/mvmtls/tols2000.mtx', ...
    'M/NEP/mvmtls/tols340.mtx', ...
    'M/NEP/mvmtls/tols4000.mtx', ...
    'M/NEP/mvmtls/tols90.mtx', ...
    'M/NEP/olmstead/olm1000.mtx', ...
    'M/NEP/olmstead/olm100.mtx', ...
    'M/NEP/olmstead/olm2000.mtx', ...
    'M/NEP/olmstead/olm5000.mtx', ...
    'M/NEP/olmstead/olm500.mtx', ...
    'M/NEP/quebec/qh1484.mtx', ...
    'M/NEP/quebec/qh768.mtx', ...
    'M/NEP/quebec/qh882.mtx', ...
    'M/NEP/robotics/rbs480a.mtx', ...
    'M/NEP/robotics/rbs480b.mtx', ...
    'M/NEP/stoch/lop163.mtx', ...
    'M/NEP/tubular/tub1000.mtx', ...
    'M/NEP/tubular/tub100.mtx', ...
    'M/SPARSKIT/drivcav/e05r0000.mtx', ...
    'M/SPARSKIT/drivcav/e05r0100.mtx', ...
    'M/SPARSKIT/drivcav/e05r0200.mtx', ...
    'M/SPARSKIT/drivcav/e05r0300.mtx', ...
    'M/SPARSKIT/drivcav/e05r0400.mtx', ...
    'M/SPARSKIT/drivcav/e05r0500.mtx', ...
    'M/SPARSKIT/drivcav/e20r0000.mtx', ...
    'M/SPARSKIT/drivcav/e20r0100.mtx', ...
    'M/SPARSKIT/drivcav/e20r0500.mtx', ...
    'M/SPARSKIT/drivcav/e20r1000.mtx', ...
    'M/SPARSKIT/drivcav/e20r2000.mtx', ...
    'M/SPARSKIT/drivcav/e20r3000.mtx', ...
    'M/SPARSKIT/drivcav/e20r4000.mtx', ...
    'M/SPARSKIT/drivcav/e20r5000.mtx', ...
    'M/SPARSKIT/drivcav/e30r0000.mtx', ...
    'M/SPARSKIT/drivcav/e30r0100.mtx', ...
    'M/SPARSKIT/drivcav/e30r0500.mtx', ...
    'M/SPARSKIT/drivcav/e30r1000.mtx', ...
    'M/SPARSKIT/drivcav/e30r2000.mtx', ...
    'M/SPARSKIT/drivcav/e30r3000.mtx', ...
    'M/SPARSKIT/drivcav/e30r4000.mtx', ...
    'M/SPARSKIT/drivcav/e30r5000.mtx', ...
    'M/SPARSKIT/drivcav/e40r0000.mtx', ...
    'M/SPARSKIT/drivcav/e40r0100.mtx', ...
    'M/SPARSKIT/drivcav/e40r0500.mtx', ...
    'M/SPARSKIT/drivcav/e40r1000.mtx', ...
    'M/SPARSKIT/drivcav/e40r2000.mtx', ...
    'M/SPARSKIT/drivcav/e40r3000.mtx', ...
    'M/SPARSKIT/drivcav/e40r4000.mtx', ...
    'M/SPARSKIT/drivcav/e40r5000.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity01.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity02.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity03.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity04.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity05.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity06.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity07.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity08.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity09.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity10.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity11.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity12.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity13.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity14.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity15.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity16.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity17.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity18.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity19.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity20.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity21.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity22.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity23.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity24.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity25.mtx', ...
    'M/SPARSKIT/drivcav_old/cavity26.mtx', ...
    'M/SPARSKIT/fidap/fidap001.mtx', ...
    'M/SPARSKIT/fidap/fidap002.mtx', ...
    'M/SPARSKIT/fidap/fidap003.mtx', ...
    'M/SPARSKIT/fidap/fidap004.mtx', ...
    'M/SPARSKIT/fidap/fidap005.mtx', ...
    'M/SPARSKIT/fidap/fidap006.mtx', ...
    'M/SPARSKIT/fidap/fidap007.mtx', ...
    'M/SPARSKIT/fidap/fidap008.mtx', ...
    'M/SPARSKIT/fidap/fidap009.mtx', ...
    'M/SPARSKIT/fidap/fidap010.mtx', ...
    'M/SPARSKIT/fidap/fidap011.mtx', ...
    'M/SPARSKIT/fidap/fidap012.mtx', ...
    'M/SPARSKIT/fidap/fidap013.mtx', ...
    'M/SPARSKIT/fidap/fidap014.mtx', ...
    'M/SPARSKIT/fidap/fidap015.mtx', ...
    'M/SPARSKIT/fidap/fidap018.mtx', ...
    'M/SPARSKIT/fidap/fidap019.mtx', ...
    'M/SPARSKIT/fidap/fidap020.mtx', ...
    'M/SPARSKIT/fidap/fidap021.mtx', ...
    'M/SPARSKIT/fidap/fidap022.mtx', ...
    'M/SPARSKIT/fidap/fidap023.mtx', ...
    'M/SPARSKIT/fidap/fidap024.mtx', ...
    'M/SPARSKIT/fidap/fidap025.mtx', ...
    'M/SPARSKIT/fidap/fidap026.mtx', ...
    'M/SPARSKIT/fidap/fidap027.mtx', ...
    'M/SPARSKIT/fidap/fidap028.mtx', ...
    'M/SPARSKIT/fidap/fidap029.mtx', ...
    'M/SPARSKIT/fidap/fidap031.mtx', ...
    'M/SPARSKIT/fidap/fidap032.mtx', ...
    'M/SPARSKIT/fidap/fidap033.mtx', ...
    'M/SPARSKIT/fidap/fidap035.mtx', ...
    'M/SPARSKIT/fidap/fidap036.mtx', ...
    'M/SPARSKIT/fidap/fidap037.mtx', ...
    'M/SPARSKIT/fidap/fidapm02.mtx', ...
    'M/SPARSKIT/fidap/fidapm03.mtx', ...
    'M/SPARSKIT/fidap/fidapm05.mtx', ...
    'M/SPARSKIT/fidap/fidapm07.mtx', ...
    'M/SPARSKIT/fidap/fidapm08.mtx', ...
    'M/SPARSKIT/fidap/fidapm09.mtx', ...
    'M/SPARSKIT/fidap/fidapm10.mtx', ...
    'M/SPARSKIT/fidap/fidapm11.mtx', ...
    'M/SPARSKIT/fidap/fidapm13.mtx', ...
    'M/SPARSKIT/fidap/fidapm15.mtx', ...
    'M/SPARSKIT/fidap/fidapm29.mtx', ...
    'M/SPARSKIT/fidap/fidapm33.mtx', ...
    'M/SPARSKIT/fidap/fidapm37.mtx', ...
    'M/SPARSKIT/tokamak/utm1700a.mtx', ...
    'M/SPARSKIT/tokamak/utm1700b.mtx', ...
    'M/SPARSKIT/tokamak/utm300.mtx', ...
    'M/SPARSKIT/tokamak/utm3060.mtx', ...
    'M/SPARSKIT/tokamak/utm5940.mtx', ...
} ;


for i = 1:length(matrices)

    filename = matrices {i} ;
    fprintf ('\nfile: %s\n', filename) ;
    tic
    [A,rows,cols,entries,rep,field,symm] = mmread(filename) ;
    t1 = toc ;
    fprintf ('    %d by %d, nz %d %s %s %s\n', ...
	rows, cols, entries, rep, field, symm) ;
%    try
     tic
	B = mread (filename) ;
     t2 = toc ;
%    catch
%	B = [ ] ;
%    end

    fprintf ('speedup %6.2f  nnz %d\n', t1/t2, nnz(A)) ;

    % mread add values to a pattern-only matrix.  Remove them
    if (strcmp (field, 'pattern'))
	B = spones (B) ;
    end

    if (isempty (B))
	fprintf ('============================ could not read with CHOLMOD\n') ;
	error ('!') ;
    else
	err = norm (A-B,1) ;
	if (err ~= 0)
	    fprintf ('=================================== %8.1e\n', err) ;
	    error ('!') ;
	end
    end
end

