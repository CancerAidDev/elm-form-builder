module Form.Locale.LanguageCodeSpec exposing (suite)

import Expect
import Form.Locale.LanguageCode as LanguageCode
import Test


suite : Test.Test
suite =
    Test.describe "Forms.Locale.LanguageCode round trip"
        ([ LanguageCode.AA, LanguageCode.AB, LanguageCode.AF, LanguageCode.AK, LanguageCode.AM, LanguageCode.AN, LanguageCode.AR, LanguageCode.BA, LanguageCode.BE, LanguageCode.BG, LanguageCode.BN, LanguageCode.CA, LanguageCode.CS, LanguageCode.DE, LanguageCode.EL, LanguageCode.EN, LanguageCode.ES, LanguageCode.FR, LanguageCode.GD, LanguageCode.GL, LanguageCode.HI, LanguageCode.HY, LanguageCode.JV, LanguageCode.KO, LanguageCode.MR, LanguageCode.MS, LanguageCode.NO, LanguageCode.PA, LanguageCode.PL, LanguageCode.PS, LanguageCode.PT, LanguageCode.QU, LanguageCode.RM, LanguageCode.RN, LanguageCode.RO, LanguageCode.RU, LanguageCode.SQ, LanguageCode.SR, LanguageCode.SV, LanguageCode.TA, LanguageCode.TH, LanguageCode.TR, LanguageCode.UG, LanguageCode.UK, LanguageCode.UR, LanguageCode.UZ, LanguageCode.VE, LanguageCode.VI, LanguageCode.VO, LanguageCode.WA, LanguageCode.WO, LanguageCode.XH, LanguageCode.YI, LanguageCode.YO, LanguageCode.ZA, LanguageCode.ZH, LanguageCode.ZU ]
            |> List.map
                (\languageCode ->
                    Test.test (LanguageCode.toString languageCode) <|
                        \_ ->
                            LanguageCode.toString languageCode
                                |> LanguageCode.fromString
                                |> Expect.equal (Just languageCode)
                )
        )
