// Üretilmiş veri: OSRM (router.project-osrm.org, araç profili) ile
// 2026-10-18'de (il temsilcileri) ve 2026-10-21'de (Süleymaniye Külliyesi
// yapıları) bir kez alınmıştır. Aynı külliyenin yapıları arasındaki bacaklar
// yaya profilindendir (routing.openstreetmap.de, `walking: true`): külliye
// içinde yürünür, araç rotası yaya alanının çevresini dolaşırdı. Kaynak veri © OpenStreetMap katkıda
// bulunanlar (ODbL). Elle düzenlenmez; eser koordinatları değişirse yeniden
// üretilir.

import 'package:flutter/foundation.dart';

/// İki eser arasındaki karayolu bacağı (yönsüz).
@immutable
final class MockRouteLeg {
  const MockRouteLeg({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
    this.walking = false,
  });

  final int distanceMeters;
  final int durationSeconds;

  /// Sadeleştirilmiş yol çizgisi, encoded polyline (hassasiyet 5).
  final String geometry;

  /// Yaya bacağı (aynı külliyenin yapıları arasında).
  final bool walking;
}

/// Mock katalogdaki 21 eserin tüm ikili bacakları (210 çift).
///
/// Anahtar `<eser A>|<eser B>` biçimindedir; ters yön için geometri
/// çağıran tarafından ters çevrilir.
abstract final class RouteLegFixtures {
  static const Map<String, MockRouteLeg> legs = {
    'suleymaniye-camii|selimiye-camii': MockRouteLeg(
      distanceMeters: 236825,
      durationSeconds: 8948,
      geometry: r'}djyFmaxoDx^x[e~@vzAbUzj@m}BllCq}CzzNb|@np_@{yF`bGqhAzdHzS|hIdfAnbBzpDb}@lmArsJmzBjeJqjDflEez@ryMc_Bn{EbNhxJgfAhgCwzIxiIywAp_F~Ux_GcsEbm]}bKdnQ}cXnsy@goCpoEyZhbOmyDf~Jk~Cxhb@coCbzG_pDh_DutD~fT}nCxkFihAvrLk}EvfTuZ|uRmnAjmCseBzj@doAziE',
    ),
    'suleymaniye-camii|bursa-ulu-camii': MockRouteLeg(
      distanceMeters: 167246,
      durationSeconds: 6886,
      geometry: r'}djyFmaxoDmoGuv@wc@skFntJgiIwLqlDtqAmuCxc@egMp~B{lNxxFyjNryPayLhhDcbGhjAamH`pC{eAbqFpb@fhFdvCj~Cr{D~cAn~E`rBjdAlu@l|CzrXvlHdeFx{CnpFvlOflAjnN`fOfgEnmCbeJhrB`pCjsDheQb~HgwJ~JatBtkDotF',
    ),
    'suleymaniye-camii|kizlaragasi-hani': MockRouteLeg(
      distanceMeters: 482308,
      durationSeconds: 17038,
      geometry: r'}djyFmaxoDmoGuv@ac@ioFxsJqeI|bF_jf@~tFelNdeQkiMn`HmtQzuN`dB|nMppTjx_@bgMluFfrOxqAlxN`hNrdD|qGx}NvmEpzRc\zrJxlClqSomEpnq@jcPvha@lxw@~ll@ffK~wC~jKrwLdzBrhYxaOhmYvbHllFhoUpoCr}I|zGdsSnl@htNpaHxxFqpBf_F_`M~__@aoNfiOlxEzwLfrJlzb@|yA`zTcjCdiVjnV}uAdrf@jhDb{UdrBx`B|XruM',
    ),
    'suleymaniye-camii|haci-bayram-veli-camii': MockRouteLeg(
      distanceMeters: 449826,
      durationSeconds: 16892,
      geometry: r'}djyFmaxoDmoGuv@mc@kmFnyJavIbfBuhW~dG_hV_kBmaB~uCcrD`fCam[p{DuuLe|@waOz_Iwht@heCyhLbvEwhFfHmlRgbJk|Q~o@ki\|gR}}k@k_BwbYeaOsjg@{k@udKvyDowMvgJodfAbcEvZxa@mrFgyFgcSsyBwsWx`HkbQwdEgzi@~iDib_@hwCidEfwPggBbzIw~LhoK~|CbrMc~Z|pGg_Bbf@__Dj`DaBbsAi{CblGzmCttFsg@dsJmdUz~Q_lClaJ~iCvkDadE}Yyjf@fcF~VxqFq`F',
    ),
    'suleymaniye-camii|sahip-ata-kulliyesi': MockRouteLeg(
      distanceMeters: 704793,
      durationSeconds: 26469,
      geometry: r'}djyFmaxoD{sHaeHnyJavIvzU_laBtbGokdA~|IowSfGciRyaJwzQlRi~SpsSuk|@k|SqveAbeP{auAxoElBo`Jair@x`HkbQwdEulj@p{Gkxc@n{QmbC|_JsaM~kKf~CbrMc~ZpmPs~KxaOfeB~xJkgUt|kA}hIjlBicRbh[{f@z}[wze@~`PqlBdue@mea@~|pAvxh@dl[Fzus@raZbbs@n{Ivim@zom@',
    ),
    'suleymaniye-camii|sultanhani-kervansarayi': MockRouteLeg(
      distanceMeters: 709419,
      durationSeconds: 26669,
      geometry: r'}djyFmaxoD{sHaeHnyJavIvzU_laBtbGokdAl|IqrSfHmlRgbJk|Q~o@ki\|gR}}k@mnSatmAfePaguAxoElBo`Jair@x`HkbQydE_bj@x{Dsd`@x}TobGz{Im_MpmKt}CbrMc~ZpmPs~KxaOfeBruJweUdt[jTbqIslHnnTb~ChxS_eJe\_sMbs[in@jn[ape@~`PqlBv}[ooZ`}X{h}@jxHfeAbda@sa`@fte@coRdv|@qq{@~bHjvIdsPnskA',
    ),
    'suleymaniye-camii|divrigi-ulu-camii-ve-darussifasi': MockRouteLeg(
      distanceMeters: 1099119,
      durationSeconds: 43391,
      geometry: r'}djyFmaxoD{sHaeHnyJavIvzU_laBtbGokdAl|IqrSfHmlRgbJk|Q~o@ki\|gR}}k@mnSatmAnbP_}tAbcEvZxa@mrF{sJ_xk@x`HkbQydE_bj@voD_l_@ziUc{Gz{Im_MpmKt}CbrMc~ZpmPs~KxaOfeBruJweU``lAqjIjlBicRbh[{f@z}[wze@~`PqlBf{QewOhhUez[hn@ekX|sMysWrk@ehf@nm^mrz@cfG{gFyl@g~PodPmjFecD}|Ml}YgdyCb}P}kd@fzR{mMa~Buy_Aib}@ux_BssNnTsgKksLy{]mbcAcu^qfeB`|Ub}@t_TalVrdU{uF|iIycZevMwgf@bxC{xk@cbNgxVn~H{hJil@s~Ga{Rgj\',
    ),
    'suleymaniye-camii|diyarbakir-ulu-camii': MockRouteLeg(
      distanceMeters: 1447909,
      durationSeconds: 52025,
      geometry: r'}djyFmaxoD{sHaeHnyJavIz{h@al{D_hHetbA|gR}}k@mnSatmA`vVscuAo`Jair@pyG{m}Angl@kaPbzz@g~z@j~kAqiI`nBidRbh[{f@b|_Ao`z@hhUez[zoPeixAdw\oby@f|uC_vqCn{b@_iElvz@daWzzk@ipr@nu`@piQzru@gbc@t_DmiqDkvi@{gbBhdFagx@q}VqdvA|bj@kueAtcEipb@wqQszxCqyYo`aAau`Auic@aqx@wwcDy|A_hnA',
    ),
    'suleymaniye-camii|gulbahar-hatun-camii': MockRouteLeg(
      distanceMeters: 1060306,
      durationSeconds: 44056,
      geometry: r'}djyFmaxoD{sHaeHnyJavIvzU_laBtbGokdAv|IeuSnGmkRyaJwzQlRi~SpsSuk|@k|SqveAjbPywtAbcEvZrb@udGqtJcak@t`H_gQ}xBe|\_`Vk{wBjzLucqA_oHooj@|pBugUiwMi|m@j`Ccu\yei@ywcCxlXoqv@dcAk`f@afEmiXnoWgcm@v|@_{h@utCgu\{mRscKe`U_ipAk|DaxE}eM`gDoqQqmRhLodNviFyoCwzB{|IlkHcxMz{A_xjBnnQaeo@baAy_\`oMq`UaLolNdeFalJzqB_tPq}F{|UpzF{iIxgEavhAraFqqN}u@}|`@}mImwSh_CiyM{bP{~f@dGgpYg}FyzSb`DalXswIcsWl~Ti|j@uv@_dM',
    ),
    'selimiye-camii|bursa-ulu-camii': MockRouteLeg(
      distanceMeters: 401164,
      durationSeconds: 14833,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRrfHgza@jfIaw[b~HevLt~C}ib@pyDy~JrZmaOrt\}d`AndKurQp~Dm{e@jgN}rRtyC{|a@taHeuO{dAmjKceE_qAqkAsuDzu@_gNhqGolIum@qo`@aoD_eGk~@yqM~y@qbXdeF{|Db~I_BfeDgg[~tFelNxbQwfMptFsqPngDieAdhMp`EpdKpvRd{_@~jMnpFvlOflAjnN`fOfgEduLn|`@xvNyaV',
    ),
    'selimiye-camii|kizlaragasi-hani': MockRouteLeg(
      distanceMeters: 716226,
      durationSeconds: 24985,
      geometry: r'_ak}F}ibaDliL}uaAneSgni@ztJel~@bzh@sxrAp~Dm{e@jgN}rRtyC{|a@taHeuOqwIasSdhIotXyjFexoAnoQ_wEvxKaqj@~_]s}`@zbNpxDzlK|}Rdk_@|zLdqIxt_@vdOpcE|dMf`b@dnBru_@guEzel@fyDd`RtvKbjTlfoArn}@dzBrhYhhO|sYttmAjb^`yMqqP~__@aoNbb]tkQnux@eo@diVjnV}uAdrf@nuHpsg@',
    ),
    'selimiye-camii|haci-bayram-veli-camii': MockRouteLeg(
      distanceMeters: 690546,
      durationSeconds: 24617,
      geometry: r'_ak}F}ibaDliL}uaAneSgni@ztJel~@bzh@sxrAzrGcil@~pLspN}lIm}eAkdMeeQvlBa~rAvpOsvh@p~Vb{AjzMyxNdqQkkoBt{IcmS~H{qRgbJk|QlRi~SpsSuk|@o|SkqeAnbP_}tAbcEvZxa@mrF{sJ_xk@x`HkbQwdEgzi@~iDib_@poUqlHbzIw~LhoK~|CbrMc~ZpmPs~KxaOfeBdsJmdUha]_AvkDadE}Yyjf@`vMqhE',
    ),
    'selimiye-camii|sahip-ata-kulliyesi': MockRouteLeg(
      distanceMeters: 945513,
      durationSeconds: 34194,
      geometry: r'_ak}F}ibaDliL}uaAneSgni@ztJel~@bzh@sxrAzrGcil@~pLspN}lIm}eAkdMeeQvlBa~rAvpOsvh@p~Vb{AjzMyxNdqQkkoBt{IcmS~H{qRgbJk|QlRi~SpsSuk|@k|SqveAbeP{auAxoElBo`Jair@x`HkbQydE_bj@p}Dog`@`|Ts_Gz{Im_MpmKt}CbrMc~ZpmPs~KxaOfeBruJweU``lAqjIjlBicRbh[{f@z}[wze@~`PqlBdue@mea@~|pAvxh@dl[Fzus@raZbbs@n{Ivim@zom@',
    ),
    'selimiye-camii|sultanhani-kervansarayi': MockRouteLeg(
      distanceMeters: 950139,
      durationSeconds: 34394,
      geometry: r'_ak}F}ibaDliL}uaAneSgni@ztJel~@bzh@sxrAzrGcil@~pLspN}lIm}eAkdMeeQvlBa~rAvpOsvh@p~Vb{AjzMyxNdqQkkoBt{IcmS~H{qRgbJk|QlRi~SpsSuk|@o|SkqeAnbP_}tAbcEvZxa@mrF{sJ_xk@x`HkbQydE_bj@rtDew_@~dU}oGz{Im_MpmKt}CbrMc~ZpmPs~KxaOfeBruJweUdt[jTbqIslHnnTb~ChxS_eJe\_sMbs[in@jn[ape@~`PqlBv}[ooZ`}X{h}@jxHfeAbda@sa`@fte@coRdv|@qq{@~bHjvIdsPnskA',
    ),
    'selimiye-camii|divrigi-ulu-camii-ve-darussifasi': MockRouteLeg(
      distanceMeters: 1339840,
      durationSeconds: 51116,
      geometry: r'_ak}F}ibaDxel@krkD~__AktoC}lIm}eAkdMeeQvlBa~rAvpOsvh@|ye@u|Kzm\oycCydIqnz@psSuk|@o|SkqeAliWut{A{sJ_xk@vkGkr|Ahul@{|Pbzz@g~z@``lAqjIjlBicRbh[{f@b|_Ao`z@hhUez[zoPeixAnm^mrz@s}^opn@l}YgdyCjxd@yzr@a~Buy_Aib}@ux_Bg|Z{}K}q}@_jiD`|Ub}@hej@}b^|iIycZevMwgf@bxC{xk@cbNgxVdqGohSa{Rgj\',
    ),
    'selimiye-camii|diyarbakir-ulu-camii': MockRouteLeg(
      distanceMeters: 1688630,
      durationSeconds: 59750,
      geometry: r'_ak}F}ibaDxel@krkD~__AktoC}lIm}eAkdMeeQvlBa~rAvpOsvh@|ye@u|Kzm\oycCydIqnz@psSuk|@k|SqveAhiWoo{A{sJ_xk@ltGee}Arll@ajPbzz@g~z@j~kAqiI`nBidRbh[{f@b|_Ao`z@hhUez[zoPeixAdw\oby@f|uC_vqCn{b@_iElvz@daWzzk@ipr@nu`@piQzru@gbc@t_DmiqDkvi@{gbBhdFagx@q}VqdvA|bj@kueAtcEipb@wqQszxCqyYo`aAau`Auic@aqx@wwcDy|A_hnA',
    ),
    'selimiye-camii|gulbahar-hatun-camii': MockRouteLeg(
      distanceMeters: 1301027,
      durationSeconds: 51781,
      geometry: r'_ak}F}ibaDxel@krkDl__AsqoCklIe`fAkdMeeQbhBifrAjuOkni@p~Vb{AfeN}sOhd\whcCqhHgobAnvRqks@}|SwafAdjWsk|Aym\ubtEjzLucqAyyDoz_AeyIcplAyei@ywcCxlXoqv@{aCyj_AnoWgcm@h}@_vh@iem@{hzByue@q~SvgLill@z{A_xjBxyh@_b}BujC{qg@~eTosbB_ve@y}mEvfSiay@',
    ),
    'bursa-ulu-camii|kizlaragasi-hani': MockRouteLeg(
      distanceMeters: 346866,
      durationSeconds: 12050,
      geometry: r'ajgtFuckpDy_A{mAi_Cl}LceInlIdrCjoa@{bE|sr@~}Pjsa@dsv@~|j@ffK~wCrqKt_MpsBp`Yl{NnfYbiHfsFhoUpoCr}I|zGdsSnl@htNpaHxxFqpBf_F_`M~__@aoNfiOlxEzwLfrJlzb@|yA`zTcjCdiVjnV}uAdrf@jhDb{UdrBx`B|XruM',
    ),
    'bursa-ulu-camii|haci-bayram-veli-camii': MockRouteLeg(
      distanceMeters: 483154,
      durationSeconds: 18029,
      geometry: r'ajgtFuckpDifJugD}rHpfJy|GufPauNcpDaqAgxNs~Fk{Ocm_@k|LmpNahUusNcfArkD_{Ju{BilG|nCusn@m{BknTllCy`KniEatDvqHche@u`E_bMuhAafx@ugU{u~@mk@eoKhyD_mMvgJodfAbcEvZxa@mrFgyFgcSsyBwsWx`HkbQydE_bj@rtDew_@`qCmiD|rPoeBz{Im_MpmKt}CbrMc~Z|pGg_Bbf@__Dj`DaBbsAi{CblGzmCttFsg@dsJmdUz~Q_lClaJ~iCvkDadE}Yyjf@fcF~VxqFq`F',
    ),
    'bursa-ulu-camii|sahip-ata-kulliyesi': MockRouteLeg(
      distanceMeters: 493406,
      durationSeconds: 22890,
      geometry: r'ajgtFuckpDuaBkuWjnCw`Idn@ecOdlTg~q@pgGo}K`sJqhAl`Kedc@~o@_jPomE{mMvpCcbEztAkxW|fEetJlwLswp@wzAitHlbi@w}hAhte@kdZnaq@u{VrrToD|jGp|KldKpuGpd|@xoE~eG_le@|p^{j]nfNyig@~wEqqx@mmAcuXxbK}xd@dmGmoo@v|GijFhtO{oCbf[oApvGhjC',
    ),
    'bursa-ulu-camii|sultanhani-kervansarayi': MockRouteLeg(
      distanceMeters: 578314,
      durationSeconds: 26251,
      geometry: r'ajgtFuckpDuaBkuWjnCw`Idn@ecOdlTg~q@pgGo}K`sJqhAl`Kedc@~o@_jPomE{mMvpCcbEztAkxW|fEetJlwLswp@wzAitHlbi@w}hAhte@kdZnaq@u{VrrToD|jGp|KldKpuGpd|@xoE~eG_le@tqSeiPrtPslZtrKo}l@nuA}td@omAcrXzeOi~v@ru@mpW|eJq}Kj_MyiBmiEe|LfzAaiP`zGyaIpbKic@{iKgsg@wiB{~V{zMukUakGqwZidKm}VyRqmT',
    ),
    'bursa-ulu-camii|divrigi-ulu-camii-ve-darussifasi': MockRouteLeg(
      distanceMeters: 1020049,
      durationSeconds: 44286,
      geometry: r'ajgtFuckpDuaBkuWb}DocYrlTu_r@pgGo}KhiJcz@~zDgsM|_Gkue@gnE{aN~fZii{As|A{mHr`i@q{hAp`\_qzBmxRiyQu|Fgpg@oJ{ny@oiWoeWy{K_}h@ueQmfZ|yNqdHua@akM~{[ku@ne[_ie@blPouBlyg@mil@hn@ekX|sMysWrk@ehf@zm^kuz@ofG}dFidAcaRohOacE{gDk|MbfXiesCrtR}oj@h|SkrRm`Dcvz@_b}@ww_BssNnTsgKksLuk|@y_~Cqc@amJjzU~`At_TalVzyVkbHttGiwXevMwgf@bxC{xk@cbNgxVn~H{hJil@s~Ga{Rgj\',
    ),
    'bursa-ulu-camii|diyarbakir-ulu-camii': MockRouteLeg(
      distanceMeters: 1368839,
      durationSeconds: 52920,
      geometry: r'ajgtFuckpDuaBkuWb}DocYrlTu_r@pgGo}KhiJcz@~zDgsM|_Gkue@gnE{aN~fZii{As|A{mHr`i@q{hAp`\_qzBmxRiyQu|Fgpg@oJ{ny@oiWoeWy{K_}h@gcQ_mZnwN_~Gef@ygMbh[{f@z}[wze@~`PqlBv}[ooZtb[wbbAnu@iog@dn\wqx@beu@mbw@jwe@efVle^{hm@`zZi}Tnc\ybE`zg@fvS``XnsBbzEuoT`pPwgEveSqtVxaIwRtrVh}QdwMokClvCcxJnjHpxCzbImbSvtNovC_kEmdd@xjJg`lCy{XwelAqyOcaUhdFagx@oaFuaH|jBquL_gSik_Ar`B_iOhag@kku@tcEipb@bZ{tb@}}Mm_v@}mCid~@}fVizd@sqBee[spLoFmyXa~V_wH|rE_qOawQi`Cy{c@}wVqzYunGovm@cgT{gu@y|A_hnA',
    ),
    'bursa-ulu-camii|gulbahar-hatun-camii': MockRouteLeg(
      distanceMeters: 1093635,
      durationSeconds: 45193,
      geometry: r'ajgtFuckpDifJugD}rHpfJy|GufPauNcpDupIst_@cm_@k|LmpNahU_tNqgA|kDqyJehBkplAtiS__w@u`E_bMuhAafx@gtVaqjAdbPoguAbcEvZpb@y}FotJ_hk@t`H_gQ}xBe|\_`Vk{wB~zLcjrAsoHaii@doB{qUquMcrm@ziCem[ioi@w_eCxlXoqv@dcAk`f@afEmiXnoWgcm@h}@_vh@guCgz\{mRscKykPqihAohIuuMwxRtm@m`KgoK{k@ynJbkLogc@z~AwskBnnQaeo@baAy_\`oMq`UaLolNdeFalJzqB_tPq}F{|UpzF{iIxgEavhAraFqqN}u@}|`@}mImwSh_CiyM{bP{~f@dGgpYg}FyzSb`DalXswIcsWl~Ti|j@uv@_dM',
    ),
    'kizlaragasi-hani|haci-bayram-veli-camii': MockRouteLeg(
      distanceMeters: 589709,
      durationSeconds: 26694,
      geometry: r'}boiFkjrdDitHqqg@xnBsyb@yxI{_Oh|Ck`h@amEyfY`wFap\yvPypyAtfDiaOujVehgAefAmgpBoy`@_a_A`kIua\yj@u}y@fdEibg@uq]c`~@ivHiwB{ys@ou{Acfw@qrl@ajGavh@aFcby@}pWuwWyxKqwh@wyYifh@{|Fwx^',
    ),
    'kizlaragasi-hani|sahip-ata-kulliyesi': MockRouteLeg(
      distanceMeters: 557873,
      durationSeconds: 24414,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUxnBsyb@yxI{_OhmBqeH~m@yy^amEyfY`wFap\yvPypyAtfDiaOmwH_q^gnE_}FlG{hMmkFinQmz@qiRhvB_rF}}DquUzz@is~@ghAmjKofNmiYipGccG{vFsaPdkI_m\kV{gfAphDgaPhkGmxGfsHga_@ljLohYjfB}fg@v}Eax[|p^{j]nfNyig@~wEqqx@mmAcuXzeOi~v@f{@y~WnfJcsKlyOirCbf[oApvGhjC',
    ),
    'kizlaragasi-hani|sultanhani-kervansarayi': MockRouteLeg(
      distanceMeters: 642782,
      durationSeconds: 27775,
      geometry: r'}boiFkjrdDitHqqg@xnBsyb@yxI{_Oh|Ck`h@amEyfY`wFap\yvPypyAtfDiaOujVehgAefAmgpBc|`@uicAjnI}~WoTwsfAtrc@qzrA|`ImscAbv^_y]p{O}wm@nsA_xkAn|PwooAhfXkhOmiEe|LfzAaiPp}SwdJqtNot_Aglb@ubiAyRqmT',
    ),
    'kizlaragasi-hani|divrigi-ulu-camii-ve-darussifasi': MockRouteLeg(
      distanceMeters: 1161158,
      durationSeconds: 51661,
      geometry: r'}boiFkjrdDitHqqg@xnBsyb@yxI{_Oh|Ck`h@amEyfY`wFap\yvPypyAtfDiaOujVehgAefAmgpBc|`@uicAjnI}~WoTwsfAtrc@qzrA|`ImscAbv^_y]p{O}wm@nsA_xkAn|PwooAhfXkhOmiEe|LfzAaiPr}ScfJstNcs_Aglb@ubiAyfQqcaB_lKmmN_cTsuv@_eJukbAaiSi|PkqEa`QwkFsv`@jiKmrk@y_RqfZmuBqwi@cb}@ax_BssNnTsgKksLgj|@sy}C_e@gsJjzU~`At_TalVzyVkbHttGiwXevMwgf@bxC{xk@cbNgxVn~H{hJil@s~Ga{Rgj\',
    ),
    'kizlaragasi-hani|diyarbakir-ulu-camii': MockRouteLeg(
      distanceMeters: 1414611,
      durationSeconds: 56987,
      geometry: r'}boiFkjrdDi~Oam{AhfEgy_BcoKcsiBujVehgAefAmgpB}x`@s{~@vtHe}cBrsc@c_sAbeI_`dA|p^{j]nfNyig@piUy_cDr|_AasVljXiy~AjeEeowBdtb@oxgAwvVmi`Auv@ceeA|_h@kj^f|i@tlO~pi@su`@~}Cq_qDkvi@{gbBhdFagx@q}VqdvA|bj@kueAtcEipb@wqQszxCqyYo`aAau`Auic@aqx@wwcDy|A_hnA',
    ),
    'kizlaragasi-hani|gulbahar-hatun-camii': MockRouteLeg(
      distanceMeters: 1414935,
      durationSeconds: 55303,
      geometry: r'}boiFkjrdDs}EugoAmnUobVcaz@x_@ex\ahQ_tm@ba`@e|mAej^o{Rqus@ss{AqdrAe|Awq`BwhMyfb@saOa~Da}Iq_`@eg~@ace@vbA}jxAtiS__w@s__@c{qCziWqj|Awm\qitE~zLcjrAckOg}jCioi@w_eCxlXoqv@{aCyj_AnoWgcm@h}@_vh@guCgz\{mRscKykPqihAqpj@agd@bkLogc@z~AwskBxyh@_b}BujC{qg@~eTosbB_ve@y}mEvfSiay@',
    ),
    'haci-bayram-veli-camii|sahip-ata-kulliyesi': MockRouteLeg(
      distanceMeters: 273517,
      durationSeconds: 11174,
      geometry: r'muxrFcopgE~zB`jGzlU|`BneCriCE`zEdpPbdAxhIw`Bna]mmf@~`PqlB`s^us_@z_AzrA|vGyaCzaX~kPlct@|hWdl[Fzus@raZpcl@|vLp}EmzAjh_@tjd@j`MddH',
    ),
    'haci-bayram-veli-camii|sultanhani-kervansarayi': MockRouteLeg(
      distanceMeters: 278143,
      durationSeconds: 11374,
      geometry: r'muxrFcopgE~zB`jGzlU|`BneCriCE`zEdpPbdA|{Jc~B|lGsjNl`SmdV~`PqlBv}[ooZnkDmeMhyEm{Bhn@ekX|fKyyQjxHfeAddNmmI|~QesUlsKys@x_YizPdv|@qq{@htCjd@tmC~pHdsPnskA',
    ),
    'haci-bayram-veli-camii|divrigi-ulu-camii-ve-darussifasi': MockRouteLeg(
      distanceMeters: 605808,
      durationSeconds: 27496,
      geometry: r'muxrFcopgEsxAoq@zTkmEdlGwqJ_fJat]fl@oxJlsHe}JczEsmKvsCkfJ{eBckIhzIwmCdhCkvGwSii]{tMei_@j^{_WngK_q[x_LuoE~o@qxOlgLymNlxMkkt@siFskKzOkdJelE}~HmcQm~LumGozX~pEirUjwAce^dfS_g[|~D{dUlt@amUw{CqnWn}BsjU|wByyAow@crGexRs{Kk`GstOm}@arOb`CyvPg|M}~oAjhDczPloMm~G~eCqqIvcE_rC}`Bqce@xjQpj@f`HonDpoM~oD`mJar@j}SkiVfdUovFpfEcdE~hC{|TobIedPgtCumT`cCm{NckBscNfaC{mL}jCqlK{fH_p@_o@m}H|cIo{KapEepTw|MafN',
    ),
    'haci-bayram-veli-camii|diyarbakir-ulu-camii': MockRouteLeg(
      distanceMeters: 1016634,
      durationSeconds: 36730,
      geometry: r'muxrFcopgE~zB`jGzlU|`BheCtdJxlZuVtn]krf@~`PqlBn_Rm{O`dU}u[hn@ekX|sMysWrk@ehf@dw\oby@r~t@uxv@jwe@efVlv\m|k@xl[uwUn{b@_iErwa@xgSx}WjxB`cF_rT`pPwgEveSqtVxaIwRtrVh}QdwMokClvCcxJnjHpxCzbImbSzsNwrCcjEehd@xjJg`lCy{XwelAqyOcaUhdFagx@oaFuaH|jBquL_gSik_Ar`B_iOhag@kku@tcEipb@bZ{tb@}}Mm_v@}mCid~@}fVizd@sqBee[spLoFmyXa~V_wH|rE_qOawQi`Cy{c@}wVqzYunGovm@cgT{gu@y|A_hnA',
    ),
    'haci-bayram-veli-camii|gulbahar-hatun-camii': MockRouteLeg(
      distanceMeters: 733959,
      durationSeconds: 31960,
      geometry: r'muxrFcopgEwbA{_GdlGwqJ_fJat]t`JuvVczEsmKzl@orTfcNelKoSgb^{tMei_@rfBuph@ecd@woZ}sQqalAc|Xo|a@isKuMgsKws\upOooI}oJswq@euTmzl@{_XwsE{{C{r^ehRuvJ{eU}upAk|DaxE}eM`gDcqQ{iR|KehNviFyoCwzB{|IlkHcxMz{A_xjBnnQaeo@baAy_\`oMq`UaLolNdeFalJzqB_tPq}F{|UpzF{iIxgEavhAraFqqN}u@}|`@}mImwSh_CiyM{bP{~f@dGgpYg}FyzSb`DalXswIcsWl~Ti|j@uv@_dM',
    ),
    'sahip-ata-kulliyesi|sultanhani-kervansarayi': MockRouteLeg(
      distanceMeters: 106671,
      durationSeconds: 4672,
      geometry: r's_cfFoqieEozAyI{|EuvCmeEcqEafCyeZ{qDkkMscAscK_{EqqSygBsxVgmKapPqnA{`DakGqwZubKwxVmx@}hJ`P_~H|QiI',
    ),
    'sahip-ata-kulliyesi|divrigi-ulu-camii-ve-darussifasi': MockRouteLeg(
      distanceMeters: 625047,
      durationSeconds: 28558,
      geometry: r's_cfFoqieEy~NssJidUgiaBglb@ubiAidQqz`BonKmvN_cTsuv@_eJukbAaiSi|PkqEa`QwkFsv`@jiKmrk@y_RqfZmuBqwi@cb}@ax_BssNnTsgKksLgj|@sy}C_e@gsJjzU~`At_TalVzyVkbHttGiwXevMwgf@bxC{xk@cbNgxVn~H{hJil@s~Ga{Rgj\',
    ),
    'sahip-ata-kulliyesi|diyarbakir-ulu-camii': MockRouteLeg(
      distanceMeters: 862548,
      durationSeconds: 33075,
      geometry: r's_cfFoqieEfkDwav@`xR_er@jeEeowBdtb@oxgAyuVmd`AxsD{_n@woFm_Vt_Q_eFpbVenWdqVbwP`jRmi@`kFcnLlrHnqCl|Hs|RvnNciCofEqpd@xmJsjjCy~Xk{mAqyOcaUhdFagx@oaFuaH|jBquLgfSwy~@z_BqzOhag@kku@tcEipb@bZ{tb@}}Mm_v@eoCkj~@ueVgtd@sqBee[spLoFmyXa~V_wH|rE_qOawQi`Cy{c@}wVqzYunGovm@cgT{gu@y|A_hnA',
    ),
    'sahip-ata-kulliyesi|gulbahar-hatun-camii': MockRouteLeg(
      distanceMeters: 912595,
      durationSeconds: 39417,
      geometry: r's_cfFoqieEgfm@uom@_hs@s}Ikts@u`Zwj[AscmAquh@itKxnB}ba@kyi@kylAwaYmzUyd~@rfBuph@}gd@wwZeoQqykAc|Xo|a@isKuMgsKws\ksOssIgmJosq@euTmzl@{_XwsE{{C{r^ikRg}JwbUkopAk|DaxE}eM`gDilPkiOmX_dQxkFayCu{BsvIzkHyyMz{A_xjBnnQaeo@baAy_\`oMq`UaLolNdeFalJzqB_tPq}F{|UpzF{iIxgEavhAraFqqN}u@}|`@}mImwSh_CiyM{bP{~f@dGgpYg}FyzSb`DalXswIcsWl~Ti|j@uv@_dM',
    ),
    'sultanhani-kervansarayi|divrigi-ulu-camii-ve-darussifasi': MockRouteLeg(
      distanceMeters: 519339,
      durationSeconds: 24003,
      geometry: r'yemhFsbwkEwuP{|kAgiKqeN_cTsuv@_eJukbAqnKevNoyFceAkqEa`Qay@weRuqD{oMnZooGpvF_dJhvB}|WszLenMaYsnGcjCwgCmuBqwi@k{Qe{Vm~Hs~[ayP}bPglNixYssNnTsgKksLygKy`c@_sQs`_@mnFaeVi`Am|Ru|Surn@_e@gsJjzU~`At_TalVzyVkbHzkCotCxgCyaTiaIg_Q{sCogTtbCsaOckBscNp`CsqLgjCyhK{fH_p@_o@m}Hn~H{hJil@s~GshEaiOmqLe`L',
    ),
    'sultanhani-kervansarayi|diyarbakir-ulu-camii': MockRouteLeg(
      distanceMeters: 814415,
      durationSeconds: 31060,
      geometry: r'yemhFsbwkEkfTu|qAlxXctDzkD}cHjr\roAzrmAg_~@t}Ckfo@}mFu}U`~Ps_FzaSarVteIgUtrVh}QdwMokClvCcxJnjHpxCzbImbSpuNs|CykEi~c@xjJg`lCy{XwelAqyOcaUhdFagx@oaFuaH|jBquL_gSik_Ar`B_iOhag@kku@tcEipb@bZ{tb@}}Mm_v@}mCid~@}fVizd@sqBee[spLoFmyXa~V_wH|rE_qOawQi`Cy{c@}wVqzYunGovm@cgT{gu@y|A_hnA',
    ),
    'sultanhani-kervansarayi|gulbahar-hatun-camii': MockRouteLeg(
      distanceMeters: 837198,
      durationSeconds: 36478,
      geometry: r'yemhFsbwkEwuP{|kAgiKqeN_cTsuv@_eJukbAaiSi|PkqEa`QwkFsv`@jiKmrk@y_RqfZmuBqwi@cb}@ax_BssNnTsgKksLy{]mbcAms^wpeBk`]`uAsyQqj[ecIiwhAcTq`d@loEsjVuuGik_@fiJe{p@k~Bid\wdLabM}oFojc@`cJ_wSphDapxAzmPkg]emCaoCctM|_Mg{CoiKo}HceAa|EkbXugXtvUo_QxF{yHciJ_oHv`@wbPegWoa]zr{@grQk`I_rJw__@_u_@_oc@euNgjHq`GdgE',
    ),
    'divrigi-ulu-camii-ve-darussifasi|diyarbakir-ulu-camii': MockRouteLeg(
      distanceMeters: 320966,
      durationSeconds: 15461,
      geometry: r'}vhoFcrtgFt~HnzCfkIo`Cak@}`GbrGu_M~lJvgDgkBwiFvlAmyC|qBx~AxoO_hK~nAifJjvGiwIuaAesHxpQ_vId|LwnO`}FuwTx~LssKbeD}lL`qJcfkArb^p~@xdEseFssIgn]z[_vNvcGifDeD_xFxoCgeGlqMgxKf}Dx|@np@gqHraHbDxzLsaMli_@ems@p~[qe`@',
    ),
    'divrigi-ulu-camii-ve-darussifasi|gulbahar-hatun-camii': MockRouteLeg(
      distanceMeters: 421052,
      durationSeconds: 20159,
      geometry: r'}vhoFcrtgFghH``CmnFkaD}aDj`CwoF{iGbhAomMvsHc_G|gJihSigHunGn_@anUexDu~HkjC|rBc|LaTgdMxjPwvLwnYixKq{Eo`D}yTabC`tAsdOqiE|TejYt{Eo|b@ehB{iThvEemThaKe`OygCyoCmhM`kMglDmuKo}HceAgwAafSudCk{CyfXvvUo_QxF{yHciJ_oHv`@ctEwiNsmIm|GciBzkNgwLjiLk`E|fKfCboH_bFpcIgrQk`I_rJw__@unEcnH_mIotCiwNkjUeuNgjHw_FzBy_@hcE',
    ),
    'diyarbakir-ulu-camii|gulbahar-hatun-camii': MockRouteLeg(
      distanceMeters: 602045,
      durationSeconds: 26415,
      geometry: r'gzkfFcqqtFi`Skaj@ylTphA{nWopO_ri@ssE{nYjzB}xG`fHsyLqvGihb@z}AuiAm}Lkc]crh@mjo@ovn@y_K~zLsdEcrLajKuDyhTnq\inMuhUyiNnjF{~[}ep@obG`hGolKx_j@hfLllv@wxCnpUczNnzEidGhtRo}TvnDohDx|WgcYdaf@}dMdrdBilOb_Ss{Ijp]gaSyyH_rJw__@_u_@_oc@euNgjHq`GdgE',
    ),
    'suleymaniye-camii|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 68,
      durationSeconds: 54,
      geometry: r'c_jyFe~woDEFn@bA^e@',
      walking: true,
    ),
    'suleymaniye-camii|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 161,
      durationSeconds: 129,
      geometry: r'c_jyFe~woDEFn@bAhBaCk@aA',
      walking: true,
    ),
    'suleymaniye-camii|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 167,
      durationSeconds: 133,
      geometry: r'c_jyFe~woDEFo@gA`DaE',
      walking: true,
    ),
    'suleymaniye-camii|suleymaniye-evvel-ve-sani-medreseleri': MockRouteLeg(
      distanceMeters: 150,
      durationSeconds: 120,
      geometry: r'c_jyFe~woDEFn@bAZa@fBjC',
      walking: true,
    ),
    'suleymaniye-camii|suleymaniye-salis-ve-rabi-medreseleri': MockRouteLeg(
      distanceMeters: 238,
      durationSeconds: 191,
      geometry: r'c_jyFe~woDEFo@gARW_AWe@l@EGlCiD',
      walking: true,
    ),
    'suleymaniye-camii|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 238,
      durationSeconds: 193,
      geometry: r'c_jyFe~woDEFn@bAdEuFi@_AKD',
      walking: true,
    ),
    'suleymaniye-camii|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 181,
      durationSeconds: 145,
      geometry: r'c_jyFe~woDEFn@bA?Tk@dCLRQTp@hA',
      walking: true,
    ),
    'suleymaniye-camii|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 132,
      durationSeconds: 105,
      geometry: r'c_jyFe~woDMPGAIH?LmA`Bv@fA',
      walking: true,
    ),
    'suleymaniye-camii|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 210,
      durationSeconds: 168,
      geometry: r'c_jyFe~woDEFn@bAjBeCr@fAHKd@`A',
      walking: true,
    ),
    'suleymaniye-camii|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 234,
      durationSeconds: 187,
      geometry: r'c_jyFe~woDEFo@gAlBaC\{BVY@[i@G',
      walking: true,
    ),
    'suleymaniye-camii|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 158,
      durationSeconds: 127,
      geometry: r'c_jyFe~woDEFo@gARW_AWe@l@EGa@h@',
      walking: true,
    ),
    'selimiye-camii|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 236742,
      durationSeconds: 8920,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugHfyFg~Fkz@yp_@f{Ce{NjpCggDpCsgC',
    ),
    'selimiye-camii|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 236817,
      durationSeconds: 8925,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugHfyFg~Fkz@yp_@f{Ce{NjpCggD~CemC',
    ),
    'selimiye-camii|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 236988,
      durationSeconds: 8964,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugHfyFg~Fkz@yp_@f{Ce{NjpCggDd@qtC',
    ),
    'selimiye-camii|suleymaniye-evvel-ve-sani-medreseleri': MockRouteLeg(
      distanceMeters: 236776,
      durationSeconds: 8950,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugHfyFg~Fkz@yp_@f{Ce{NjpCggDvAkaC',
    ),
    'selimiye-camii|suleymaniye-salis-ve-rabi-medreseleri': MockRouteLeg(
      distanceMeters: 236645,
      durationSeconds: 8969,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugH~yFqaGc{@om_@f{Ce{NjpCggDaEisC',
    ),
    'selimiye-camii|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 236848,
      durationSeconds: 8927,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugHfyFg~Fkz@yp_@f{Ce{NjpCggDdDooC',
    ),
    'selimiye-camii|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 236866,
      durationSeconds: 8982,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugHfyFg~Fkz@yp_@f{Ce{NjpCggD]w|B',
    ),
    'selimiye-camii|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 236423,
      durationSeconds: 8898,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugH~yFqaGc{@om_@f{Ce{NjpCggDkFg_C',
    ),
    'selimiye-camii|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 236731,
      durationSeconds: 8919,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugHfyFg~Fkz@yp_@f{Ce{NjpCggDrC{fC',
    ),
    'selimiye-camii|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 237028,
      durationSeconds: 8979,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugH~yFqaGc{@om_@f{Ce{NjpCggD_@{tC',
    ),
    'selimiye-camii|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 236512,
      durationSeconds: 8921,
      geometry: r'_ak}F}ibaDkbAqcEniD{`EtZgtRb}E{eTnhAksLznCwkFnvDijTlnDc|CtnCayGt~C}ib@pyDy~JrZmaOpmC{kE`fXaxy@ndKurQdqEgh]cVo_GxwAk_FnzIiiIrfA{gCuN}xJ`_Bi{Efz@uyMljD}kEpzB{eJylA_sJopDu}@seAc_ByUeiIvhAugH~yFqaGc{@om_@f{Ce{NjpCggDkHojC',
    ),
    'bursa-ulu-camii|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 155049,
      durationSeconds: 6592,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaM~N~yLcgAs{@',
    ),
    'bursa-ulu-camii|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 155124,
      durationSeconds: 6597,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaM~N~yLufAeaA',
    ),
    'bursa-ulu-camii|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 155296,
      durationSeconds: 6636,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaM~N~yLojAqhA',
    ),
    'bursa-ulu-camii|suleymaniye-evvel-ve-sani-medreseleri': MockRouteLeg(
      distanceMeters: 155083,
      durationSeconds: 6622,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaMdOryLciA_u@',
    ),
    'bursa-ulu-camii|suleymaniye-salis-ve-rabi-medreseleri': MockRouteLeg(
      distanceMeters: 155294,
      durationSeconds: 6652,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaM~N~yLqfAgEeJaaA',
    ),
    'bursa-ulu-camii|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 155155,
      durationSeconds: 6599,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaM~N~yLofAocA',
    ),
    'bursa-ulu-camii|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 155173,
      durationSeconds: 6655,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaMdOryLylAkp@',
    ),
    'bursa-ulu-camii|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 155073,
      durationSeconds: 6580,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaMdOryLgsA{r@',
    ),
    'bursa-ulu-camii|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 155038,
      durationSeconds: 6591,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaM~N~yLagA{z@',
    ),
    'bursa-ulu-camii|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 155336,
      durationSeconds: 6651,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaM~N~yLulA{hA',
    ),
    'bursa-ulu-camii|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 155162,
      durationSeconds: 6604,
      geometry: r'ajgtFuckpDygDadCo}Dsb@}\hkBg{DzkBwxAjmCy|GufPauNcpDaqAgxNs~Fk{OiuEqlCotXimHwu@o|CorBwdAaU}iCckEanGiiFkwCuqFuc@}uCf~@gfAjuHmhDdbGg{Pb{LowFpiN}yCzoSyR~hHl`B`pBmtCxaMdOryLguAc~@',
    ),
    'kizlaragasi-hani|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 476349,
      durationSeconds: 16702,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaM~N~yLcgAs{@',
    ),
    'kizlaragasi-hani|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 476424,
      durationSeconds: 16707,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaM~N~yLufAeaA',
    ),
    'kizlaragasi-hani|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 476596,
      durationSeconds: 16746,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaM~N~yLojAqhA',
    ),
    'kizlaragasi-hani|suleymaniye-evvel-ve-sani-medreseleri': MockRouteLeg(
      distanceMeters: 476383,
      durationSeconds: 16732,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaMdOryLciA_u@',
    ),
    'kizlaragasi-hani|suleymaniye-salis-ve-rabi-medreseleri': MockRouteLeg(
      distanceMeters: 476594,
      durationSeconds: 16762,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaM~N~yLwqAigA',
    ),
    'kizlaragasi-hani|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 476456,
      durationSeconds: 16709,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaM~N~yLofAocA',
    ),
    'kizlaragasi-hani|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 476473,
      durationSeconds: 16765,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaMdOryLylAkp@',
    ),
    'kizlaragasi-hani|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 476373,
      durationSeconds: 16691,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaMdOryLgsA{r@',
    ),
    'kizlaragasi-hani|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 476338,
      durationSeconds: 16702,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaM~N~yLagA{z@',
    ),
    'kizlaragasi-hani|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 476636,
      durationSeconds: 16761,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaM~N~yLulA{hA',
    ),
    'kizlaragasi-hani|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 476462,
      durationSeconds: 16714,
      geometry: r'}boiFkjrdDcX}xMirBe_B{gDmwUtuAcuf@mnUobVeoImc@ohKdbDmgc@}|AchLooJaoOqwEoz^rnNgcFvdMgtFvkBgpNq`HqvSmm@kyIuxGusUsqCidH{mFicOotYewBa`YoeKksL_mKe}Cssw@cfl@mfP{ma@nmEknq@ylCmqSz[wsJqmEezRcrGg~NohNsdDaqAgxN{uFirOyw_@}fMorMasTkaPuiAmsFl|PeeQliMgnJ|e]uo@zpMp`BdqBmtCxaMdOryLguAc~@',
    ),
    'haci-bayram-veli-camii|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 442240,
      durationSeconds: 16753,
      geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaM~N~yLcgAs{@',
    ),
    'haci-bayram-veli-camii|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 442316,
      durationSeconds: 16758,
      geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaM~N~yLufAeaA',
    ),
    'haci-bayram-veli-camii|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 442487,
      durationSeconds: 16798,
      geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaM~N~yLojAqhA',
    ),
    'haci-bayram-veli-camii|suleymaniye-evvel-ve-sani-medreseleri':
        MockRouteLeg(
          distanceMeters: 442274,
          durationSeconds: 16784,
          geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaMdOryLciA_u@',
        ),
    'haci-bayram-veli-camii|suleymaniye-salis-ve-rabi-medreseleri':
        MockRouteLeg(
          distanceMeters: 442486,
          durationSeconds: 16813,
          geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaM~N~yLwqAigA',
        ),
    'haci-bayram-veli-camii|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 442347,
      durationSeconds: 16760,
      geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaM~N~yLofAocA',
    ),
    'haci-bayram-veli-camii|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 442364,
      durationSeconds: 16816,
      geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaMdOryLylAkp@',
    ),
    'haci-bayram-veli-camii|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 442264,
      durationSeconds: 16742,
      geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaMdOryLgsA{r@',
    ),
    'haci-bayram-veli-camii|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 442230,
      durationSeconds: 16753,
      geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaM~N~yLagA{z@',
    ),
    'haci-bayram-veli-camii|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 442527,
      durationSeconds: 16812,
      geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaM~N~yLulA{hA',
    ),
    'haci-bayram-veli-camii|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 442353,
      durationSeconds: 16765,
      geometry: r'muxrFcopgEuwF|aFqxFwf@|{AtsQ{gC|}PezGzaFkqV`hAisJrdUmsFtf@{lG_mCgsAb{Cy`DnBue@p~CiqGp_ByqMz}ZumKu}C_|Ir_MawPbgBaxCdeEejDvz^`eEhbj@_aHrbQryBltWbyFjcS}c@trFa_Eah@uiJnpfAuyDzwM|k@`eKdaOtjg@x_B||XchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@qfAj_Qn`AfqMo~DddMa_ChsZ}_Db`EvkBjiB_dGtrVsn@pkMp`BdqBmtCxaMdOryLguAc~@',
    ),
    'sahip-ata-kulliyesi|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 699302,
      durationSeconds: 26314,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@{rH~|eA',
    ),
    'sahip-ata-kulliyesi|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 699377,
      durationSeconds: 26319,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@mrHlweA',
    ),
    'sahip-ata-kulliyesi|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 699548,
      durationSeconds: 26359,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@gvH`peA',
    ),
    'sahip-ata-kulliyesi|suleymaniye-evvel-ve-sani-medreseleri': MockRouteLeg(
      distanceMeters: 699336,
      durationSeconds: 26345,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@utHfcfA',
    ),
    'sahip-ata-kulliyesi|suleymaniye-salis-ve-rabi-medreseleri': MockRouteLeg(
      distanceMeters: 699547,
      durationSeconds: 26374,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@o}HhqeA',
    ),
    'sahip-ata-kulliyesi|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 699408,
      durationSeconds: 26321,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@grHbueA',
    ),
    'sahip-ata-kulliyesi|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 699426,
      durationSeconds: 26377,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@kxHzgfA',
    ),
    'sahip-ata-kulliyesi|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 699326,
      durationSeconds: 26303,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@y~HjefA',
    ),
    'sahip-ata-kulliyesi|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 699291,
      durationSeconds: 26314,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@yrHv}eA',
    ),
    'sahip-ata-kulliyesi|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 699588,
      durationSeconds: 26373,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaM{{QvbC_|Gbyc@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@mxHvoeA',
    ),
    'sahip-ata-kulliyesi|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 699415,
      durationSeconds: 26326,
      geometry: r's_cfFoqieEykm@mrm@mbs@{zIkts@u`Zwj[As}pAeyh@oue@dea@iaPflB}}[|ze@o~[xN~mAzmLydDjlEm|kA~hIkyJpgUiaOieBanPv~KyqMz}ZykKi~Cg`JxaMsyQd`Cg~Gt{c@jdEzqj@k`HpyPj`Jzlr@spEiDgdPbduAxyStkgAipS~lz@}RjhTbbJd|QcGz`RkyQvmx@aErq_@o_Nryn@y`IbzeA',
    ),
    'sultanhani-kervansarayi|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 705727,
      durationSeconds: 26669,
      geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@{rH~|eA',
    ),
    'sultanhani-kervansarayi|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 705802,
      durationSeconds: 26674,
      geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@mrHlweA',
    ),
    'sultanhani-kervansarayi|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 705974,
      durationSeconds: 26713,
      geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@gvH`peA',
    ),
    'sultanhani-kervansarayi|suleymaniye-evvel-ve-sani-medreseleri':
        MockRouteLeg(
          distanceMeters: 705761,
          durationSeconds: 26699,
          geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@utHfcfA',
        ),
    'sultanhani-kervansarayi|suleymaniye-salis-ve-rabi-medreseleri':
        MockRouteLeg(
          distanceMeters: 705972,
          durationSeconds: 26728,
          geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@o}HhqeA',
        ),
    'sultanhani-kervansarayi|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 705833,
      durationSeconds: 26676,
      geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@grHbueA',
    ),
    'sultanhani-kervansarayi|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 705851,
      durationSeconds: 26731,
      geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@kxHzgfA',
    ),
    'sultanhani-kervansarayi|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 705751,
      durationSeconds: 26657,
      geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@y~HjefA',
    ),
    'sultanhani-kervansarayi|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 705716,
      durationSeconds: 26668,
      geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@yrHv}eA',
    ),
    'sultanhani-kervansarayi|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 706014,
      durationSeconds: 26728,
      geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@mxHvoeA',
    ),
    'sultanhani-kervansarayi|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 705840,
      durationSeconds: 26680,
      geometry: r'yemhFsbwkE_sP_ukA}bHmwIed}@h}{@_je@hfRa~`@~{_@ifIamA}|JvfRen@njXeeKdaQo}[noZiaPflBmn[fpe@_n\nYnx@zeNm{SjgJilTu~CsrI~lH_s[sTwuJzeUiaOieBanPv~KyqMz}ZumKu}Ck~IdaMe|T|aGw{Dpd`@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@y`IbzeA',
    ),
    'divrigi-ulu-camii-ve-darussifasi|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 1094423,
      durationSeconds: 43344,
      geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@{rH~|eA',
    ),
    'divrigi-ulu-camii-ve-darussifasi|kanuni-sultan-suleyman-turbesi':
        MockRouteLeg(
          distanceMeters: 1094499,
          durationSeconds: 43349,
          geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@mrHlweA',
        ),
    'divrigi-ulu-camii-ve-darussifasi|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 1094670,
      durationSeconds: 43388,
      geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@gvH`peA',
    ),
    'divrigi-ulu-camii-ve-darussifasi|suleymaniye-evvel-ve-sani-medreseleri':
        MockRouteLeg(
          distanceMeters: 1094457,
          durationSeconds: 43374,
          geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@utHfcfA',
        ),
    'divrigi-ulu-camii-ve-darussifasi|suleymaniye-salis-ve-rabi-medreseleri':
        MockRouteLeg(
          distanceMeters: 1094669,
          durationSeconds: 43404,
          geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@o}HhqeA',
        ),
    'divrigi-ulu-camii-ve-darussifasi|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 1094530,
      durationSeconds: 43351,
      geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@grHbueA',
    ),
    'divrigi-ulu-camii-ve-darussifasi|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 1094547,
      durationSeconds: 43407,
      geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@kxHzgfA',
    ),
    'divrigi-ulu-camii-ve-darussifasi|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 1094447,
      durationSeconds: 43333,
      geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@y~HjefA',
    ),
    'divrigi-ulu-camii-ve-darussifasi|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 1094412,
      durationSeconds: 43344,
      geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@yrHv}eA',
    ),
    'divrigi-ulu-camii-ve-darussifasi|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 1094710,
      durationSeconds: 43403,
      geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@mxHvoeA',
    ),
    'divrigi-ulu-camii-ve-darussifasi|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 1094536,
      durationSeconds: 43356,
      geometry: r'}vhoFcrtgF`{Rfj\hl@r~Go~HzhJbbNfxVcxCzxk@jvMvbf@uiIhgZqcUpsF{`TtnVgaV_bAny^`meB|v]pybArkK`|LlvNiQzv|@p}_BbgCbr_AmxRpjMu~P`nd@mqQx}_CegHhsXpgE~wM|dOv_E~aAb{Q~iFlrFwo]zlz@{k@jhf@ysMxsWen@njX}cUvu[w~Q|zOiaPflB}}[|ze@o~[xN~mAzmLydDjlEa`lAtjIwuJzeUiaOieBanPv~KyqMz}ZumKu}C_|Ir_MmjU~{G{oD`l_@`eEhbj@_aHrbQvsJxxk@}c@trFa_Eah@kdPjiuA|nStnmAchR~al@cp@bk\bbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@y`IbzeA',
    ),
    'diyarbakir-ulu-camii|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 1445002,
      durationSeconds: 51895,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAwrj@jnoE',
    ),
    'diyarbakir-ulu-camii|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 1445077,
      durationSeconds: 51900,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAirj@xhoE',
    ),
    'diyarbakir-ulu-camii|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 1445249,
      durationSeconds: 51940,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAcvj@laoE',
    ),
    'diyarbakir-ulu-camii|suleymaniye-evvel-ve-sani-medreseleri': MockRouteLeg(
      distanceMeters: 1445036,
      durationSeconds: 51926,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAqtj@rtoE',
    ),
    'diyarbakir-ulu-camii|suleymaniye-salis-ve-rabi-medreseleri': MockRouteLeg(
      distanceMeters: 1445248,
      durationSeconds: 51955,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAk}j@tboE',
    ),
    'diyarbakir-ulu-camii|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 1445108,
      durationSeconds: 51902,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAcrj@nfoE',
    ),
    'diyarbakir-ulu-camii|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 1445126,
      durationSeconds: 51958,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAgxj@fyoE',
    ),
    'diyarbakir-ulu-camii|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 1445026,
      durationSeconds: 51884,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAu~j@vvoE',
    ),
    'diyarbakir-ulu-camii|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 1444991,
      durationSeconds: 51895,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAurj@booE',
    ),
    'diyarbakir-ulu-camii|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 1445288,
      durationSeconds: 51954,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAixj@baoE',
    ),
    'diyarbakir-ulu-camii|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 1445115,
      durationSeconds: 51907,
      geometry: r'gzkfFcqqtFdzAfbnA|rx@`~cDbt`Avec@fzYfdaAtqQ~yxCocEzob@qcj@bveAx|Vd`vAqcF~jx@pvi@thbBefDpkqDeku@x~b@et`@wjQg|k@dqr@cvz@iaW_|b@|hEo~uCbxqCyu\lay@{oPthxA}cUvu[_``Abdz@o~[xNyuAf{Ra`lAtjI}yz@d~z@ehl@`bPwyGzn}AvsJxxk@kiW~s{A|nStnmAchR~al@xgHxtbAu`k@nkoE',
    ),
    'gulbahar-hatun-camii|suleymaniye-kulliyesi': MockRouteLeg(
      distanceMeters: 1053894,
      durationSeconds: 43825,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QyG`hRuxQpfx@aErq_@o_Nryn@{rH~|eA',
    ),
    'gulbahar-hatun-camii|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 1053969,
      durationSeconds: 43830,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QyG`hRuxQpfx@aErq_@o_Nryn@mrHlweA',
    ),
    'gulbahar-hatun-camii|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 1054141,
      durationSeconds: 43869,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QyG`hRuxQpfx@aErq_@o_Nryn@gvH`peA',
    ),
    'gulbahar-hatun-camii|suleymaniye-evvel-ve-sani-medreseleri': MockRouteLeg(
      distanceMeters: 1053928,
      durationSeconds: 43855,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QyG`hRuxQpfx@aErq_@o_Nryn@utHfcfA',
    ),
    'gulbahar-hatun-camii|suleymaniye-salis-ve-rabi-medreseleri': MockRouteLeg(
      distanceMeters: 1054140,
      durationSeconds: 43885,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@o}HhqeA',
    ),
    'gulbahar-hatun-camii|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 1054000,
      durationSeconds: 43832,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QyG`hRuxQpfx@aErq_@o_Nryn@grHbueA',
    ),
    'gulbahar-hatun-camii|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 1054018,
      durationSeconds: 43888,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QyG`hRuxQpfx@aErq_@o_Nryn@kxHzgfA',
    ),
    'gulbahar-hatun-camii|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 1053918,
      durationSeconds: 43814,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QyG`hRuxQpfx@aErq_@o_Nryn@y~HjefA',
    ),
    'gulbahar-hatun-camii|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 1053883,
      durationSeconds: 43824,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QyG`hRuxQpfx@aErq_@o_Nryn@yrHv}eA',
    ),
    'gulbahar-hatun-camii|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 1054180,
      durationSeconds: 43884,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QyG`hRuxQpfx@aErq_@o_Nryn@mxHvoeA',
    ),
    'gulbahar-hatun-camii|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 1054007,
      durationSeconds: 43837,
      geometry: r'ylgyFk_lqFrt@zcM}|Tn|j@hwIjsWcaDhjX`_Gd`TiH~kYlcPv~f@y~BvaNxkI`iSvw@paa@qaFpqNehEdxhAkzFhgIn}Fv_V}rBntP{cFjiJpLbkN_pMldUcaAny[uqQzzo@}xA~gjB{jHjwMhzBf}I_iFlmCgMvdNdrQvpRjfM_gDf|DpyElaUdkpAzkRh_KptCxt\kbAfki@ujWzwl@fgEldXcbApwe@{mXb~v@xei@ftcCq_Clz\nvMzvm@{pBpgUvnHjoj@kzLncqAn_Vn{wBdyB`|\{`HpgQptJ~ak@mb@hbGoaEye@_dPl~tApySjqgAipS~lz@}RjhTbbJd|QeHnkRq~EvwFwxJjjp@aErq_@o_Nryn@y`IbzeA',
    ),
    'suleymaniye-kulliyesi|kanuni-sultan-suleyman-turbesi': MockRouteLeg(
      distanceMeters: 93,
      durationSeconds: 75,
      geometry: r'y|iyF_}woDhA{Ak@aA',
      walking: true,
    ),
    'suleymaniye-kulliyesi|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 174,
      durationSeconds: 140,
      geometry: r'y|iyF_}woDhA{A{AkCr@_A',
      walking: true,
    ),
    'suleymaniye-kulliyesi|suleymaniye-evvel-ve-sani-medreseleri': MockRouteLeg(
      distanceMeters: 88,
      durationSeconds: 70,
      geometry: r'y|iyF_}woDCBp@hABCp@dA',
      walking: true,
    ),
    'suleymaniye-kulliyesi|suleymaniye-salis-ve-rabi-medreseleri': MockRouteLeg(
      distanceMeters: 297,
      durationSeconds: 238,
      geometry: r'y|iyF_}woD_@d@_BkCRW_AWe@l@EGlCiD',
      walking: true,
    ),
    'suleymaniye-kulliyesi|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 170,
      durationSeconds: 138,
      geometry: r'y|iyF_}woDdDoEi@_AKD',
      walking: true,
    ),
    'suleymaniye-kulliyesi|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 162,
      durationSeconds: 129,
      geometry: r'y|iyF_}woD_@d@?Tk@dCLRQTp@hA',
      walking: true,
    ),
    'suleymaniye-kulliyesi|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 158,
      durationSeconds: 126,
      geometry: r'y|iyF_}woD_@d@?Tk@dCLRQTo@_A',
      walking: true,
    ),
    'suleymaniye-kulliyesi|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 143,
      durationSeconds: 114,
      geometry: r'y|iyF_}woDjA_Br@fAHKd@`A',
      walking: true,
    ),
    'suleymaniye-kulliyesi|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 242,
      durationSeconds: 193,
      geometry: r'y|iyF_}woDhA{A{AkC\{BVY@[i@G',
      walking: true,
    ),
    'suleymaniye-kulliyesi|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 217,
      durationSeconds: 173,
      geometry: r'y|iyF_}woD_@d@_BkCRW_AWe@l@EGa@h@',
      walking: true,
    ),
    'kanuni-sultan-suleyman-turbesi|hurrem-sultan-turbesi': MockRouteLeg(
      distanceMeters: 81,
      durationSeconds: 65,
      geometry: r'{{iyF}axoDo@iAr@_A',
      walking: true,
    ),
    'kanuni-sultan-suleyman-turbesi|suleymaniye-evvel-ve-sani-medreseleri':
        MockRouteLeg(
          distanceMeters: 181,
          durationSeconds: 145,
          geometry: r'{{iyF}axoDj@`AmA~AfBjC',
          walking: true,
        ),
    'kanuni-sultan-suleyman-turbesi|suleymaniye-salis-ve-rabi-medreseleri':
        MockRouteLeg(
          distanceMeters: 207,
          durationSeconds: 166,
          geometry: r'{{iyF}axoDo@iA\{BVY@[SJ{ArB',
          walking: true,
        ),
    'kanuni-sultan-suleyman-turbesi|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 150,
      durationSeconds: 122,
      geometry: r'{{iyF}axoDj@`AzAsBi@_AKD',
      walking: true,
    ),
    'kanuni-sultan-suleyman-turbesi|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 255,
      durationSeconds: 204,
      geometry: r'{{iyF}axoDj@`AiB`C?Tk@dCLRQTp@hA',
      walking: true,
    ),
    'kanuni-sultan-suleyman-turbesi|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 251,
      durationSeconds: 200,
      geometry: r'{{iyF}axoDj@`AiB`C?Tk@dCLRQTo@_A',
      walking: true,
    ),
    'kanuni-sultan-suleyman-turbesi|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 123,
      durationSeconds: 98,
      geometry: r'{{iyF}axoD`BdCHKd@`A',
      walking: true,
    ),
    'kanuni-sultan-suleyman-turbesi|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 148,
      durationSeconds: 119,
      geometry: r'{{iyF}axoDo@iA\{BVY@[i@G',
      walking: true,
    ),
    'kanuni-sultan-suleyman-turbesi|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 206,
      durationSeconds: 164,
      geometry: r'{{iyF}axoDo@iAyAhB_AWe@l@EGa@h@',
      walking: true,
    ),
    'hurrem-sultan-turbesi|suleymaniye-evvel-ve-sani-medreseleri': MockRouteLeg(
      distanceMeters: 263,
      durationSeconds: 210,
      geometry: r'w{iyFgfxoDs@~@zAjCmA~AfBjC',
      walking: true,
    ),
    'hurrem-sultan-turbesi|suleymaniye-salis-ve-rabi-medreseleri': MockRouteLeg(
      distanceMeters: 145,
      durationSeconds: 116,
      geometry: r'w{iyFgfxoD`@e@_@o@@[SJ{ArB',
      walking: true,
    ),
    'hurrem-sultan-turbesi|suleymaniye-darulkurrasi': MockRouteLeg(
      distanceMeters: 72,
      durationSeconds: 60,
      geometry: r'w{iyFgfxoDh@o@f@x@CR',
      walking: true,
    ),
    'hurrem-sultan-turbesi|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 336,
      durationSeconds: 269,
      geometry: r'w{iyFgfxoDs@~@zAjCiB`C?Tk@dCLRQTp@hA',
      walking: true,
    ),
    'hurrem-sultan-turbesi|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 286,
      durationSeconds: 229,
      geometry: r'w{iyFgfxoD_FjGp@fAk@v@v@fA',
      walking: true,
    ),
    'hurrem-sultan-turbesi|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 204,
      durationSeconds: 163,
      geometry: r'w{iyFgfxoDs@~@BHlCdEHKd@`A',
      walking: true,
    ),
    'hurrem-sultan-turbesi|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 86,
      durationSeconds: 69,
      geometry: r'w{iyFgfxoD`@e@_@o@@[i@G',
      walking: true,
    ),
    'hurrem-sultan-turbesi|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 204,
      durationSeconds: 163,
      geometry: r'w{iyFgfxoDmChD_AWe@l@EGa@h@',
      walking: true,
    ),
    'suleymaniye-evvel-ve-sani-medreseleri|suleymaniye-salis-ve-rabi-medreseleri':
        MockRouteLeg(
          distanceMeters: 379,
          durationSeconds: 303,
          geometry: r'uyiyFoxwoDgBkC[`@_BkCRW_AWe@l@EGlCiD',
          walking: true,
        ),
    'suleymaniye-evvel-ve-sani-medreseleri|suleymaniye-darulkurrasi':
        MockRouteLeg(
          distanceMeters: 255,
          durationSeconds: 206,
          geometry: r'uyiyFoxwoDq@eAlAaBs@gAxAoBi@_AKD',
          walking: true,
        ),
    'suleymaniye-evvel-ve-sani-medreseleri|suleymaniye-darussifasi':
        MockRouteLeg(
          distanceMeters: 150,
          durationSeconds: 121,
          geometry: r'uyiyFoxwoD^h@eCfD[k@',
          walking: true,
        ),
    'suleymaniye-evvel-ve-sani-medreseleri|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 178,
      durationSeconds: 142,
      geometry: r'uyiyFoxwoDq@eAaC`Do@_A',
      walking: true,
    ),
    'suleymaniye-evvel-ve-sani-medreseleri|suleymaniye-sibyan-mektebi':
        MockRouteLeg(
          distanceMeters: 119,
          durationSeconds: 96,
          geometry: r'uyiyFoxwoD^h@pAgBe@s@',
          walking: true,
        ),
    'suleymaniye-evvel-ve-sani-medreseleri|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 330,
      durationSeconds: 264,
      geometry: r'uyiyFoxwoDgBkClA_B{AkC\{BVY@[i@G',
      walking: true,
    ),
    'suleymaniye-evvel-ve-sani-medreseleri|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 299,
      durationSeconds: 239,
      geometry: r'uyiyFoxwoDgBkC[`@_BkCRW_AWe@l@EGa@h@',
      walking: true,
    ),
    'suleymaniye-salis-ve-rabi-medreseleri|suleymaniye-darulkurrasi':
        MockRouteLeg(
          distanceMeters: 169,
          durationSeconds: 137,
          geometry: r'c_jyFyexoDzAsBRKAZ^n@FIf@x@CR',
          walking: true,
        ),
    'suleymaniye-salis-ve-rabi-medreseleri|suleymaniye-darussifasi':
        MockRouteLeg(
          distanceMeters: 365,
          durationSeconds: 292,
          geometry: r'c_jyFyexoDoEvFCZVFXXlExG',
          walking: true,
        ),
    'suleymaniye-salis-ve-rabi-medreseleri|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 285,
      durationSeconds: 228,
      geometry: r'c_jyFyexoDoEvFCZVFXXjBnC',
      walking: true,
    ),
    'suleymaniye-salis-ve-rabi-medreseleri|suleymaniye-sibyan-mektebi':
        MockRouteLeg(
          distanceMeters: 330,
          durationSeconds: 264,
          geometry: r'c_jyFyexoDzAsBRKAZWX]zBzAjCt@bAHKd@`A',
          walking: true,
        ),
    'suleymaniye-salis-ve-rabi-medreseleri|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 106,
      durationSeconds: 85,
      geometry: r'c_jyFyexoDzAsBRKi@G',
      walking: true,
    ),
    'suleymaniye-salis-ve-rabi-medreseleri|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 132,
      durationSeconds: 106,
      geometry: r'c_jyFyexoDoDrE',
      walking: true,
    ),
    'suleymaniye-darulkurrasi|suleymaniye-darussifasi': MockRouteLeg(
      distanceMeters: 332,
      durationSeconds: 266,
      geometry: r'iyiyFiexoDJEh@~@eEtF?Tk@dCLRQTp@hA',
      walking: true,
    ),
    'suleymaniye-darulkurrasi|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 328,
      durationSeconds: 262,
      geometry: r'iyiyFiexoDJEh@~@eEtF?Tk@dCLRQTo@_A',
      walking: true,
    ),
    'suleymaniye-darulkurrasi|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 196,
      durationSeconds: 157,
      geometry: r'iyiyFiexoDJEh@~@yAnBr@fAHKd@`A',
      walking: true,
    ),
    'suleymaniye-darulkurrasi|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 110,
      durationSeconds: 88,
      geometry: r'iyiyFiexoDBSg@y@GH_@o@@[i@G',
      walking: true,
    ),
    'suleymaniye-darulkurrasi|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 276,
      durationSeconds: 221,
      geometry: r'iyiyFiexoDBSg@y@wDxE_AWe@l@EGa@h@',
      walking: true,
    ),
    'suleymaniye-darussifasi|suleymaniye-imareti': MockRouteLeg(
      distanceMeters: 80,
      durationSeconds: 64,
      geometry: r'w}iyFiswoDaBiC',
      walking: true,
    ),
    'suleymaniye-darussifasi|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 244,
      durationSeconds: 195,
      geometry: r'w}iyFiswoDq@iAxEoGd@`A',
      walking: true,
    ),
    'suleymaniye-darussifasi|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 403,
      durationSeconds: 323,
      geometry: r'w}iyFiswoDq@iAPUMSj@eC?UhBaC{AkC\{BVY@[i@G',
      walking: true,
    ),
    'suleymaniye-darussifasi|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 232,
      durationSeconds: 186,
      geometry: r'w}iyFiswoDmEyGYYWGB[^c@',
      walking: true,
    ),
    'suleymaniye-imareti|suleymaniye-sibyan-mektebi': MockRouteLeg(
      distanceMeters: 240,
      durationSeconds: 192,
      geometry: r'y`jyFswwoDn@~@xEoGd@`A',
      walking: true,
    ),
    'suleymaniye-imareti|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 354,
      durationSeconds: 283,
      geometry: r'y`jyFswwoDw@gAj@w@q@gAjDkE\{BVY@[i@G',
      walking: true,
    ),
    'suleymaniye-imareti|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 153,
      durationSeconds: 122,
      geometry: r'y`jyFswwoDkBoCYYWGB[^c@',
      walking: true,
    ),
    'suleymaniye-sibyan-mektebi|suleymaniye-hamami': MockRouteLeg(
      distanceMeters: 271,
      durationSeconds: 217,
      geometry: r'iwiyFa|woDe@aAIJmCeECI\{BVY@[i@G',
      walking: true,
    ),
    'suleymaniye-sibyan-mektebi|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 328,
      durationSeconds: 263,
      geometry: r'iwiyFa|woDe@aAIJu@cA{AkCyAhB_AWe@l@EGa@h@',
      walking: true,
    ),
    'suleymaniye-hamami|mimar-sinan-turbesi': MockRouteLeg(
      distanceMeters: 252,
      durationSeconds: 201,
      geometry: r'}|iyFajxoDh@FAZSVEI{EfGEGa@h@',
      walking: true,
    ),
  };
}
