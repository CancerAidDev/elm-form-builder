module Form.Locale.CountryCode exposing
    ( CountryCode(..), fromString, toString
    , mobileErrMsg
    )

{-| Best effort at supporting [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166).


# CountryCode

@docs CountryCode, fromString, toString

-}


{-| -}
type CountryCode
    = AD
    | AE
    | AF
    | AG
    | AI
    | AL
    | AM
    | AO
    | AQ
    | AR
    | AS
    | AT
    | AU
    | AW
    | AX
    | AZ
    | BA
    | BB
    | BD
    | BE
    | BF
    | BG
    | BH
    | BI
    | BJ
    | BL
    | BM
    | BN
    | BO
    | BQ
    | BR
    | BS
    | BT
    | BW
    | BY
    | BZ
    | CA
    | CC
    | CD
    | CF
    | CG
    | CH
    | CI
    | CK
    | CL
    | CM
    | CN
    | CO
    | CR
    | CU
    | CV
    | CW
    | CX
    | CY
    | CZ
    | DE
    | DJ
    | DK
    | DM
    | DO
    | DZ
    | EC
    | EE
    | EG
    | EH
    | ER
    | ES
    | ET
    | FI
    | FJ
    | FK
    | FM
    | FO
    | FR
    | GA
    | GB
    | GD
    | GE
    | GF
    | GG
    | GH
    | GI
    | GL
    | GM
    | GN
    | GP
    | GQ
    | GR
    | GT
    | GU
    | GW
    | GY
    | HK
    | HM
    | HN
    | HT
    | HU
    | ID
    | IE
    | IL
    | IM
    | IN
    | IO
    | IQ
    | IR
    | IS
    | IT
    | JE
    | JM
    | JO
    | JP
    | KE
    | KG
    | KH
    | KI
    | KM
    | KN
    | KP
    | KR
    | KW
    | KY
    | KZ
    | LA
    | LB
    | LC
    | LI
    | LK
    | LR
    | LS
    | LT
    | LU
    | LV
    | LY
    | MA
    | MC
    | MD
    | ME
    | MF
    | MG
    | MH
    | MK
    | ML
    | MM
    | MN
    | MO
    | MP
    | MQ
    | MR
    | MS
    | MT
    | MU
    | MV
    | MW
    | MX
    | MY
    | MZ
    | NA
    | NC
    | NE
    | NF
    | NG
    | NI
    | NL
    | NO
    | NP
    | NR
    | NU
    | NZ
    | OM
    | PA
    | PE
    | PF
    | PG
    | PH
    | PK
    | PL
    | PM
    | PR
    | PS
    | PT
    | PW
    | PY
    | QA
    | RE
    | RO
    | RS
    | RU
    | RW
    | SA
    | SB
    | SC
    | SD
    | SE
    | SG
    | SH
    | SI
    | SJ
    | SK
    | SL
    | SM
    | SN
    | SO
    | SR
    | SS
    | ST
    | SV
    | SX
    | SY
    | SZ
    | TC
    | TD
    | TG
    | TH
    | TJ
    | TK
    | TL
    | TM
    | TN
    | TO
    | TR
    | TT
    | TV
    | TW
    | TZ
    | UA
    | UG
    | US
    | UY
    | UZ
    | VA
    | VC
    | VE
    | VG
    | VI
    | VN
    | VU
    | WF
    | WS
    | YE
    | YT
    | ZA
    | ZM
    | ZW


{-| -}
fromString : String -> Maybe CountryCode
fromString str =
    case String.toUpper str of
        "AD" ->
            Just AD

        "AE" ->
            Just AE

        "AF" ->
            Just AF

        "AG" ->
            Just AG

        "AI" ->
            Just AI

        "AL" ->
            Just AL

        "AM" ->
            Just AM

        "AO" ->
            Just AO

        "AQ" ->
            Just AQ

        "AR" ->
            Just AR

        "AS" ->
            Just AS

        "AT" ->
            Just AT

        "AU" ->
            Just AU

        "AW" ->
            Just AW

        "AX" ->
            Just AX

        "AZ" ->
            Just AZ

        "BA" ->
            Just BA

        "BB" ->
            Just BB

        "BD" ->
            Just BD

        "BE" ->
            Just BE

        "BF" ->
            Just BF

        "BG" ->
            Just BG

        "BH" ->
            Just BH

        "BI" ->
            Just BI

        "BJ" ->
            Just BJ

        "BL" ->
            Just BL

        "BM" ->
            Just BM

        "BN" ->
            Just BN

        "BO" ->
            Just BO

        "BQ" ->
            Just BQ

        "BR" ->
            Just BR

        "BS" ->
            Just BS

        "BT" ->
            Just BT

        "BW" ->
            Just BW

        "BY" ->
            Just BY

        "BZ" ->
            Just BZ

        "CA" ->
            Just CA

        "CC" ->
            Just CC

        "CD" ->
            Just CD

        "CF" ->
            Just CF

        "CG" ->
            Just CG

        "CH" ->
            Just CH

        "CI" ->
            Just CI

        "CK" ->
            Just CK

        "CL" ->
            Just CL

        "CM" ->
            Just CM

        "CN" ->
            Just CN

        "CO" ->
            Just CO

        "CR" ->
            Just CR

        "CU" ->
            Just CU

        "CV" ->
            Just CV

        "CW" ->
            Just CW

        "CX" ->
            Just CX

        "CY" ->
            Just CY

        "CZ" ->
            Just CZ

        "DE" ->
            Just DE

        "DJ" ->
            Just DJ

        "DK" ->
            Just DK

        "DM" ->
            Just DM

        "DO" ->
            Just DO

        "DZ" ->
            Just DZ

        "EC" ->
            Just EC

        "EE" ->
            Just EE

        "EG" ->
            Just EG

        "EH" ->
            Just EH

        "ER" ->
            Just ER

        "ES" ->
            Just ES

        "ET" ->
            Just ET

        "FI" ->
            Just FI

        "FJ" ->
            Just FJ

        "FK" ->
            Just FK

        "FM" ->
            Just FM

        "FO" ->
            Just FO

        "FR" ->
            Just FR

        "GA" ->
            Just GA

        "GB" ->
            Just GB

        "GD" ->
            Just GD

        "GE" ->
            Just GE

        "GF" ->
            Just GF

        "GG" ->
            Just GG

        "GH" ->
            Just GH

        "GI" ->
            Just GI

        "GL" ->
            Just GL

        "GM" ->
            Just GM

        "GN" ->
            Just GN

        "GP" ->
            Just GP

        "GQ" ->
            Just GQ

        "GR" ->
            Just GR

        "GT" ->
            Just GT

        "GU" ->
            Just GU

        "GW" ->
            Just GW

        "GY" ->
            Just GY

        "HK" ->
            Just HK

        "HM" ->
            Just HM

        "HN" ->
            Just HN

        "HT" ->
            Just HT

        "HU" ->
            Just HU

        "ID" ->
            Just ID

        "IE" ->
            Just IE

        "IL" ->
            Just IL

        "IM" ->
            Just IM

        "IN" ->
            Just IN

        "IO" ->
            Just IO

        "IQ" ->
            Just IQ

        "IR" ->
            Just IR

        "IS" ->
            Just IS

        "IT" ->
            Just IT

        "JE" ->
            Just JE

        "JM" ->
            Just JM

        "JO" ->
            Just JO

        "JP" ->
            Just JP

        "KE" ->
            Just KE

        "KG" ->
            Just KG

        "KH" ->
            Just KH

        "KI" ->
            Just KI

        "KM" ->
            Just KM

        "KN" ->
            Just KN

        "KP" ->
            Just KP

        "KR" ->
            Just KR

        "KW" ->
            Just KW

        "KY" ->
            Just KY

        "KZ" ->
            Just KZ

        "LA" ->
            Just LA

        "LB" ->
            Just LB

        "LC" ->
            Just LC

        "LI" ->
            Just LI

        "LK" ->
            Just LK

        "LR" ->
            Just LR

        "LS" ->
            Just LS

        "LT" ->
            Just LT

        "LU" ->
            Just LU

        "LV" ->
            Just LV

        "LY" ->
            Just LY

        "MA" ->
            Just MA

        "MC" ->
            Just MC

        "MD" ->
            Just MD

        "ME" ->
            Just ME

        "MF" ->
            Just MF

        "MG" ->
            Just MG

        "MH" ->
            Just MH

        "MK" ->
            Just MK

        "ML" ->
            Just ML

        "MM" ->
            Just MM

        "MN" ->
            Just MN

        "MO" ->
            Just MO

        "MP" ->
            Just MP

        "MQ" ->
            Just MQ

        "MR" ->
            Just MR

        "MS" ->
            Just MS

        "MT" ->
            Just MT

        "MU" ->
            Just MU

        "MV" ->
            Just MV

        "MW" ->
            Just MW

        "MX" ->
            Just MX

        "MY" ->
            Just MY

        "MZ" ->
            Just MZ

        "NA" ->
            Just NA

        "NC" ->
            Just NC

        "NE" ->
            Just NE

        "NF" ->
            Just NF

        "NG" ->
            Just NG

        "NI" ->
            Just NI

        "NL" ->
            Just NL

        "NO" ->
            Just NO

        "NP" ->
            Just NP

        "NR" ->
            Just NR

        "NU" ->
            Just NU

        "NZ" ->
            Just NZ

        "OM" ->
            Just OM

        "PA" ->
            Just PA

        "PE" ->
            Just PE

        "PF" ->
            Just PF

        "PG" ->
            Just PG

        "PH" ->
            Just PH

        "PK" ->
            Just PK

        "PL" ->
            Just PL

        "PM" ->
            Just PM

        "PR" ->
            Just PR

        "PS" ->
            Just PS

        "PT" ->
            Just PT

        "PW" ->
            Just PW

        "PY" ->
            Just PY

        "QA" ->
            Just QA

        "RE" ->
            Just RE

        "RO" ->
            Just RO

        "RS" ->
            Just RS

        "RU" ->
            Just RU

        "RW" ->
            Just RW

        "SA" ->
            Just SA

        "SB" ->
            Just SB

        "SC" ->
            Just SC

        "SD" ->
            Just SD

        "SE" ->
            Just SE

        "SG" ->
            Just SG

        "SH" ->
            Just SH

        "SI" ->
            Just SI

        "SJ" ->
            Just SJ

        "SK" ->
            Just SK

        "SL" ->
            Just SL

        "SM" ->
            Just SM

        "SN" ->
            Just SN

        "SO" ->
            Just SO

        "SR" ->
            Just SR

        "SS" ->
            Just SS

        "ST" ->
            Just ST

        "SV" ->
            Just SV

        "SX" ->
            Just SX

        "SY" ->
            Just SY

        "SZ" ->
            Just SZ

        "TC" ->
            Just TC

        "TD" ->
            Just TD

        "TG" ->
            Just TG

        "TH" ->
            Just TH

        "TJ" ->
            Just TJ

        "TK" ->
            Just TK

        "TL" ->
            Just TL

        "TM" ->
            Just TM

        "TN" ->
            Just TN

        "TO" ->
            Just TO

        "TR" ->
            Just TR

        "TT" ->
            Just TT

        "TV" ->
            Just TV

        "TW" ->
            Just TW

        "TZ" ->
            Just TZ

        "UA" ->
            Just UA

        "UG" ->
            Just UG

        "US" ->
            Just US

        "UY" ->
            Just UY

        "UZ" ->
            Just UZ

        "VA" ->
            Just VA

        "VC" ->
            Just VC

        "VE" ->
            Just VE

        "VG" ->
            Just VG

        "VI" ->
            Just VI

        "VN" ->
            Just VN

        "VU" ->
            Just VU

        "WF" ->
            Just WF

        "WS" ->
            Just WS

        "YE" ->
            Just YE

        "YT" ->
            Just YT

        "ZA" ->
            Just ZA

        "ZM" ->
            Just ZM

        "ZW" ->
            Just ZW

        _ ->
            Nothing


{-| -}
toString : CountryCode -> String
toString code =
    case code of
        AD ->
            "AD"

        AE ->
            "AE"

        AF ->
            "AF"

        AG ->
            "AG"

        AI ->
            "AI"

        AL ->
            "AL"

        AM ->
            "AM"

        AO ->
            "AO"

        AQ ->
            "AQ"

        AR ->
            "AR"

        AS ->
            "AS"

        AT ->
            "AT"

        AU ->
            "AU"

        AW ->
            "AW"

        AX ->
            "AX"

        AZ ->
            "AZ"

        BA ->
            "BA"

        BB ->
            "BB"

        BD ->
            "BD"

        BE ->
            "BE"

        BF ->
            "BF"

        BG ->
            "BG"

        BH ->
            "BH"

        BI ->
            "BI"

        BJ ->
            "BJ"

        BL ->
            "BL"

        BM ->
            "BM"

        BN ->
            "BN"

        BO ->
            "BO"

        BQ ->
            "BQ"

        BR ->
            "BR"

        BS ->
            "BS"

        BT ->
            "BT"

        BW ->
            "BW"

        BY ->
            "BY"

        BZ ->
            "BZ"

        CA ->
            "CA"

        CC ->
            "CC"

        CD ->
            "CD"

        CF ->
            "CF"

        CG ->
            "CG"

        CH ->
            "CH"

        CI ->
            "CI"

        CK ->
            "CK"

        CL ->
            "CL"

        CM ->
            "CM"

        CN ->
            "CN"

        CO ->
            "CO"

        CR ->
            "CR"

        CU ->
            "CU"

        CV ->
            "CV"

        CW ->
            "CW"

        CX ->
            "CX"

        CY ->
            "CY"

        CZ ->
            "CZ"

        DE ->
            "DE"

        DJ ->
            "DJ"

        DK ->
            "DK"

        DM ->
            "DM"

        DO ->
            "DO"

        DZ ->
            "DZ"

        EC ->
            "EC"

        EE ->
            "EE"

        EG ->
            "EG"

        EH ->
            "EH"

        ER ->
            "ER"

        ES ->
            "ES"

        ET ->
            "ET"

        FI ->
            "FI"

        FJ ->
            "FJ"

        FK ->
            "FK"

        FM ->
            "FM"

        FO ->
            "FO"

        FR ->
            "FR"

        GA ->
            "GA"

        GB ->
            "GB"

        GD ->
            "GD"

        GE ->
            "GE"

        GF ->
            "GF"

        GG ->
            "GG"

        GH ->
            "GH"

        GI ->
            "GI"

        GL ->
            "GL"

        GM ->
            "GM"

        GN ->
            "GN"

        GP ->
            "GP"

        GQ ->
            "GQ"

        GR ->
            "GR"

        GT ->
            "GT"

        GU ->
            "GU"

        GW ->
            "GW"

        GY ->
            "GY"

        HK ->
            "HK"

        HM ->
            "HM"

        HN ->
            "HN"

        HT ->
            "HT"

        HU ->
            "HU"

        ID ->
            "ID"

        IE ->
            "IE"

        IL ->
            "IL"

        IM ->
            "IM"

        IN ->
            "IN"

        IO ->
            "IO"

        IQ ->
            "IQ"

        IR ->
            "IR"

        IS ->
            "IS"

        IT ->
            "IT"

        JE ->
            "JE"

        JM ->
            "JM"

        JO ->
            "JO"

        JP ->
            "JP"

        KE ->
            "KE"

        KG ->
            "KG"

        KH ->
            "KH"

        KI ->
            "KI"

        KM ->
            "KM"

        KN ->
            "KN"

        KP ->
            "KP"

        KR ->
            "KR"

        KW ->
            "KW"

        KY ->
            "KY"

        KZ ->
            "KZ"

        LA ->
            "LA"

        LB ->
            "LB"

        LC ->
            "LC"

        LI ->
            "LI"

        LK ->
            "LK"

        LR ->
            "LR"

        LS ->
            "LS"

        LT ->
            "LT"

        LU ->
            "LU"

        LV ->
            "LV"

        LY ->
            "LY"

        MA ->
            "MA"

        MC ->
            "MC"

        MD ->
            "MD"

        ME ->
            "ME"

        MF ->
            "MF"

        MG ->
            "MG"

        MH ->
            "MH"

        MK ->
            "MK"

        ML ->
            "ML"

        MM ->
            "MM"

        MN ->
            "MN"

        MO ->
            "MO"

        MP ->
            "MP"

        MQ ->
            "MQ"

        MR ->
            "MR"

        MS ->
            "MS"

        MT ->
            "MT"

        MU ->
            "MU"

        MV ->
            "MV"

        MW ->
            "MW"

        MX ->
            "MX"

        MY ->
            "MY"

        MZ ->
            "MZ"

        NA ->
            "NA"

        NC ->
            "NC"

        NE ->
            "NE"

        NF ->
            "NF"

        NG ->
            "NG"

        NI ->
            "NI"

        NL ->
            "NL"

        NO ->
            "NO"

        NP ->
            "NP"

        NR ->
            "NR"

        NU ->
            "NU"

        NZ ->
            "NZ"

        OM ->
            "OM"

        PA ->
            "PA"

        PE ->
            "PE"

        PF ->
            "PF"

        PG ->
            "PG"

        PH ->
            "PH"

        PK ->
            "PK"

        PL ->
            "PL"

        PM ->
            "PM"

        PR ->
            "PR"

        PS ->
            "PS"

        PT ->
            "PT"

        PW ->
            "PW"

        PY ->
            "PY"

        QA ->
            "QA"

        RE ->
            "RE"

        RO ->
            "RO"

        RS ->
            "RS"

        RU ->
            "RU"

        RW ->
            "RW"

        SA ->
            "SA"

        SB ->
            "SB"

        SC ->
            "SC"

        SD ->
            "SD"

        SE ->
            "SE"

        SG ->
            "SG"

        SH ->
            "SH"

        SI ->
            "SI"

        SJ ->
            "SJ"

        SK ->
            "SK"

        SL ->
            "SL"

        SM ->
            "SM"

        SN ->
            "SN"

        SO ->
            "SO"

        SR ->
            "SR"

        SS ->
            "SS"

        ST ->
            "ST"

        SV ->
            "SV"

        SX ->
            "SX"

        SY ->
            "SY"

        SZ ->
            "SZ"

        TC ->
            "TC"

        TD ->
            "TD"

        TG ->
            "TG"

        TH ->
            "TH"

        TJ ->
            "TJ"

        TK ->
            "TK"

        TL ->
            "TL"

        TM ->
            "TM"

        TN ->
            "TN"

        TO ->
            "TO"

        TR ->
            "TR"

        TT ->
            "TT"

        TV ->
            "TV"

        TW ->
            "TW"

        TZ ->
            "TZ"

        UA ->
            "UA"

        UG ->
            "UG"

        US ->
            "US"

        UY ->
            "UY"

        UZ ->
            "UZ"

        VA ->
            "VA"

        VC ->
            "VC"

        VE ->
            "VE"

        VG ->
            "VG"

        VI ->
            "VI"

        VN ->
            "VN"

        VU ->
            "VU"

        WF ->
            "WF"

        WS ->
            "WS"

        YE ->
            "YE"

        YT ->
            "YT"

        ZA ->
            "ZA"

        ZM ->
            "ZM"

        ZW ->
            "ZW"


mobileErrMsg : Maybe CountryCode -> String
mobileErrMsg maybeCode =
    case maybeCode of
        Just code ->
            case code of
                AU ->
                    "Invalid mobile number (example: 400 000 000)"

                NZ ->
                    "Invalid mobile number (example: 20 000 0000)"

                US ->
                    "Invalid mobile number, (example: 200 200 0000)"

                _ ->
                    "Invalid mobile number"

        Nothing ->
            "Invalid mobile number"
