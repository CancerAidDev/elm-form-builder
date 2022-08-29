module Form.Locale.Phone exposing (regex, mobileRegex, phonePrefix, formatForSubmission, formatForDisplay, toPlaceholder, mobileErrMsg)

{-| Phone number helpers


# Phone

@docs regex, mobileRegex, phonePrefix, formatForSubmission, formatForDisplay, toPlaceholder, mobileErrMsg

-}

import Form.Locale.CountryCode as CountryCode
import List.Extra as ListExtra
import Regex
import String.Extra as StringExtra


{-| -}
phonePrefix : CountryCode.CountryCode -> String
phonePrefix code =
    case code of
        CountryCode.AD ->
            "+376"

        CountryCode.AE ->
            "+971"

        CountryCode.AF ->
            "+93"

        CountryCode.AG ->
            "+1"

        CountryCode.AI ->
            "+1"

        CountryCode.AL ->
            "+355"

        CountryCode.AM ->
            "+374"

        CountryCode.AO ->
            "+244"

        CountryCode.AQ ->
            "+672"

        CountryCode.AR ->
            "+54"

        CountryCode.AS ->
            "+1"

        CountryCode.AT ->
            "+43"

        CountryCode.AU ->
            "+61"

        CountryCode.AW ->
            "+297"

        CountryCode.AX ->
            "+358"

        CountryCode.AZ ->
            "+994"

        CountryCode.BA ->
            "+387"

        CountryCode.BB ->
            "+1"

        CountryCode.BD ->
            "+880"

        CountryCode.BE ->
            "+32"

        CountryCode.BF ->
            "+226"

        CountryCode.BG ->
            "+359"

        CountryCode.BH ->
            "+973"

        CountryCode.BI ->
            "+257"

        CountryCode.BJ ->
            "+229"

        CountryCode.BL ->
            "+590"

        CountryCode.BM ->
            "+1"

        CountryCode.BN ->
            "+673"

        CountryCode.BO ->
            "+591"

        CountryCode.BQ ->
            "+599"

        CountryCode.BR ->
            "+55"

        CountryCode.BS ->
            "+1"

        CountryCode.BT ->
            "+975"

        CountryCode.BW ->
            "+267"

        CountryCode.BY ->
            "+375"

        CountryCode.BZ ->
            "+501"

        CountryCode.CA ->
            "+1"

        CountryCode.CC ->
            "+61"

        CountryCode.CD ->
            "+243"

        CountryCode.CF ->
            "+236"

        CountryCode.CG ->
            "+242"

        CountryCode.CH ->
            "+41"

        CountryCode.CI ->
            "+225"

        CountryCode.CK ->
            "+682"

        CountryCode.CL ->
            "+56"

        CountryCode.CM ->
            "+237"

        CountryCode.CN ->
            "+86"

        CountryCode.CO ->
            "+57"

        CountryCode.CR ->
            "+506"

        CountryCode.CU ->
            "+53"

        CountryCode.CV ->
            "+238"

        CountryCode.CW ->
            "+599"

        CountryCode.CX ->
            "+61"

        CountryCode.CY ->
            "+357"

        CountryCode.CZ ->
            "+420"

        CountryCode.DE ->
            "+49"

        CountryCode.DJ ->
            "+253"

        CountryCode.DK ->
            "+45"

        CountryCode.DM ->
            "+1"

        CountryCode.DO ->
            "+1"

        CountryCode.DZ ->
            "+213"

        CountryCode.EC ->
            "+593"

        CountryCode.EE ->
            "+372"

        CountryCode.EG ->
            "+20"

        CountryCode.EH ->
            "+212"

        CountryCode.ER ->
            "+291"

        CountryCode.ES ->
            "+34"

        CountryCode.ET ->
            "+251"

        CountryCode.FI ->
            "+358"

        CountryCode.FJ ->
            "+679"

        CountryCode.FK ->
            "+500"

        CountryCode.FM ->
            "+691"

        CountryCode.FO ->
            "+298"

        CountryCode.FR ->
            "+33"

        CountryCode.GA ->
            "+241"

        CountryCode.GB ->
            "+44"

        CountryCode.GD ->
            "+1"

        CountryCode.GE ->
            "+995"

        CountryCode.GF ->
            "+594"

        CountryCode.GG ->
            "+44"

        CountryCode.GH ->
            "+233"

        CountryCode.GI ->
            "+350"

        CountryCode.GL ->
            "+299"

        CountryCode.GM ->
            "+220"

        CountryCode.GN ->
            "+224"

        CountryCode.GP ->
            "+590"

        CountryCode.GQ ->
            "+240"

        CountryCode.GR ->
            "+30"

        CountryCode.GT ->
            "+502"

        CountryCode.GU ->
            "+1"

        CountryCode.GW ->
            "+245"

        CountryCode.GY ->
            "+592"

        CountryCode.HK ->
            "+852"

        CountryCode.HM ->
            "+504"

        CountryCode.HN ->
            "+385"

        CountryCode.HT ->
            "+509"

        CountryCode.HU ->
            "+36"

        CountryCode.ID ->
            "+62"

        CountryCode.IE ->
            "+353"

        CountryCode.IL ->
            "+972"

        CountryCode.IM ->
            "+44"

        CountryCode.IN ->
            "+91"

        CountryCode.IO ->
            "+246"

        CountryCode.IQ ->
            "+964"

        CountryCode.IR ->
            "+98"

        CountryCode.IS ->
            "+354"

        CountryCode.IT ->
            "+39"

        CountryCode.JE ->
            "+44"

        CountryCode.JM ->
            "+1"

        CountryCode.JO ->
            "+962"

        CountryCode.JP ->
            "+81"

        CountryCode.KE ->
            "+254"

        CountryCode.KG ->
            "+996"

        CountryCode.KH ->
            "+855"

        CountryCode.KI ->
            "+686"

        CountryCode.KM ->
            "+269"

        CountryCode.KN ->
            "+1"

        CountryCode.KP ->
            "+850"

        CountryCode.KR ->
            "+82"

        CountryCode.KW ->
            "+965"

        CountryCode.KY ->
            "+1"

        CountryCode.KZ ->
            "+7"

        CountryCode.LA ->
            "+856"

        CountryCode.LB ->
            "+961"

        CountryCode.LC ->
            "+1"

        CountryCode.LI ->
            "+423"

        CountryCode.LK ->
            "+94"

        CountryCode.LR ->
            "+231"

        CountryCode.LS ->
            "+266"

        CountryCode.LT ->
            "+370"

        CountryCode.LU ->
            "+352"

        CountryCode.LV ->
            "+351"

        CountryCode.LY ->
            "+218"

        CountryCode.MA ->
            "+212"

        CountryCode.MC ->
            "+377"

        CountryCode.MD ->
            "+373"

        CountryCode.ME ->
            "+382"

        CountryCode.MF ->
            "+590"

        CountryCode.MG ->
            "+261"

        CountryCode.MH ->
            "+691"

        CountryCode.MK ->
            "+389"

        CountryCode.ML ->
            "+223"

        CountryCode.MM ->
            "+95"

        CountryCode.MN ->
            "+976"

        CountryCode.MO ->
            "+853"

        CountryCode.MP ->
            "+1"

        CountryCode.MQ ->
            "+596"

        CountryCode.MR ->
            "+222"

        CountryCode.MS ->
            "+1"

        CountryCode.MT ->
            "+356"

        CountryCode.MU ->
            "+230"

        CountryCode.MV ->
            "+960"

        CountryCode.MW ->
            "+265"

        CountryCode.MX ->
            "+52"

        CountryCode.MY ->
            "+60"

        CountryCode.MZ ->
            "+258"

        CountryCode.NA ->
            "+264"

        CountryCode.NC ->
            "+687"

        CountryCode.NE ->
            "+227"

        CountryCode.NF ->
            "+672"

        CountryCode.NG ->
            "+234"

        CountryCode.NI ->
            "+505"

        CountryCode.NL ->
            "+31"

        CountryCode.NO ->
            "+47"

        CountryCode.NP ->
            "+977"

        CountryCode.NR ->
            "+674"

        CountryCode.NU ->
            "+683"

        CountryCode.NZ ->
            "+64"

        CountryCode.OM ->
            "+968"

        CountryCode.PA ->
            "+507"

        CountryCode.PE ->
            "+51"

        CountryCode.PF ->
            "+689"

        CountryCode.PG ->
            "+675"

        CountryCode.PH ->
            "+63"

        CountryCode.PK ->
            "+93"

        CountryCode.PL ->
            "+48"

        CountryCode.PM ->
            "+508"

        CountryCode.PR ->
            "+1"

        CountryCode.PS ->
            "+970"

        CountryCode.PT ->
            "+351"

        CountryCode.PW ->
            "+680"

        CountryCode.PY ->
            "+595"

        CountryCode.QA ->
            "+974"

        CountryCode.RE ->
            "+262"

        CountryCode.RO ->
            "+40"

        CountryCode.RS ->
            "+381"

        CountryCode.RU ->
            "+7"

        CountryCode.RW ->
            "+250"

        CountryCode.SA ->
            "+966"

        CountryCode.SB ->
            "+677"

        CountryCode.SC ->
            "+248"

        CountryCode.SD ->
            "+249"

        CountryCode.SE ->
            "+46"

        CountryCode.SG ->
            "+65"

        CountryCode.SH ->
            "+290"

        CountryCode.SI ->
            "+386"

        CountryCode.SJ ->
            "+47"

        CountryCode.SK ->
            "+421"

        CountryCode.SL ->
            "+232"

        CountryCode.SM ->
            "+378"

        CountryCode.SN ->
            "+221"

        CountryCode.SO ->
            "+252"

        CountryCode.SR ->
            "+597"

        CountryCode.SS ->
            "+211"

        CountryCode.ST ->
            "+239"

        CountryCode.SV ->
            "+503"

        CountryCode.SX ->
            "+1"

        CountryCode.SY ->
            "+963"

        CountryCode.SZ ->
            "+268"

        CountryCode.TC ->
            "+1"

        CountryCode.TD ->
            "+235"

        CountryCode.TG ->
            "+228"

        CountryCode.TH ->
            "+66"

        CountryCode.TJ ->
            "+992"

        CountryCode.TK ->
            "+690"

        CountryCode.TL ->
            "+670"

        CountryCode.TM ->
            "+993"

        CountryCode.TN ->
            "+216"

        CountryCode.TO ->
            "+676"

        CountryCode.TR ->
            "+90"

        CountryCode.TT ->
            "+1"

        CountryCode.TV ->
            "+688"

        CountryCode.TW ->
            "+886"

        CountryCode.TZ ->
            "+255"

        CountryCode.UA ->
            "+380"

        CountryCode.UG ->
            "+256"

        CountryCode.US ->
            "+1"

        CountryCode.UY ->
            "+598"

        CountryCode.UZ ->
            "+998"

        CountryCode.VA ->
            "+39"

        CountryCode.VC ->
            "+1"

        CountryCode.VE ->
            "+58"

        CountryCode.VG ->
            "+1"

        CountryCode.VI ->
            "+1"

        CountryCode.VN ->
            "+84"

        CountryCode.VU ->
            "+678"

        CountryCode.WF ->
            "+681"

        CountryCode.WS ->
            "+685"

        CountryCode.YE ->
            "+967"

        CountryCode.YT ->
            "+262"

        CountryCode.ZA ->
            "+27"

        CountryCode.ZM ->
            "+260"

        CountryCode.ZW ->
            "+263"


{-| -}
regex : CountryCode.CountryCode -> Regex.Regex
regex code =
    case code of
        CountryCode.AU ->
            "^\\d{9}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        _ ->
            "^\\d.*$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never


{-| -}
mobileRegex : CountryCode.CountryCode -> Regex.Regex
mobileRegex code =
    case code of
        CountryCode.AU ->
            "^4\\d{8}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        CountryCode.NZ ->
            "^2\\d{7,9}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        CountryCode.US ->
            "^5(?:05(?:[2-57-9]\\d\\d|6(?:[0-35-9]\\d|44))|82(?:2(?:0[0-3]|[268]2)|3(?:0[02]|22|33)|4(?:00|4[24]|65|82)|5(?:00|29|58|83)|6(?:00|66|82)|7(?:58|77)|8(?:00|42|5[25]|88)|9(?:00|9[89])))\\d{4}|(?:2(?:0[1-35-9]|1[02-9]|2[03-589]|3[149]|4[08]|5[1-46]|6[0279]|7[0269]|8[13])|3(?:0[1-57-9]|1[02-9]|2[01356]|3[0-24679]|4[167]|5[12]|6[014]|8[056])|4(?:0[124-9]|1[02-579]|2[3-5]|3[0245]|4[023578]|58|6[349]|7[0589]|8[04])|5(?:0[1-47-9]|1[0235-8]|20|3[0149]|4[01]|5[19]|6[1-47]|7[0-5]|8[056])|6(?:0[1-35-9]|1[024-9]|2[03689]|[34][016]|5[01679]|6[0-279]|78|8[0-29])|7(?:0[1-46-8]|1[2-9]|2[04-7]|3[1247]|4[037]|5[47]|6[02359]|7[0-59]|8[156])|8(?:0[1-68]|1[02-8]|2[068]|3[0-289]|4[03578]|5[046-9]|6[02-5]|7[028])|9(?:0[1346-9]|1[02-9]|2[0589]|3[0146-8]|4[01357-9]|5[12469]|7[0-389]|8[04-69]))[2-9]\\d{6}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        _ ->
            "^\\d.*$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never


{-| -}
formatForSubmission : CountryCode.CountryCode -> String -> String
formatForSubmission code =
    String.words
        >> String.concat
        >> (\phone -> phonePrefix code ++ phone)


formatGroups : CountryCode.CountryCode -> List Int
formatGroups code =
    case code of
        CountryCode.NZ ->
            [ 2, 3, 5 ]

        CountryCode.US ->
            [ 3, 3, 4 ]

        _ ->
            [ 3, 3, 3 ]


{-| -}
formatForDisplay : CountryCode.CountryCode -> String -> String
formatForDisplay code =
    StringExtra.rightOf (phonePrefix code)
        >> String.toList
        >> ListExtra.groupsOfVarying (formatGroups code)
        >> List.map String.fromList
        >> String.join " "


{-| -}
toPlaceholder : Maybe CountryCode.CountryCode -> String
toPlaceholder code =
    case code of
        Just CountryCode.US ->
            "212 200 0000"

        Just CountryCode.NZ ->
            "20 000 0000"

        Just _ ->
            "400 000 000"

        Nothing ->
            ""


{-| -}
mobileErrMsg : CountryCode.CountryCode -> String
mobileErrMsg code =
    case code of
        CountryCode.AU ->
            "Invalid mobile number (example: 400 000 000)"

        CountryCode.NZ ->
            "Invalid mobile number (example: 20 000 0000)"

        CountryCode.US ->
            "Invalid mobile number (example: 212 200 0000)"

        _ ->
            "Invalid mobile number"
