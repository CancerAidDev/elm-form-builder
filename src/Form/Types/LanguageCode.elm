module Form.Types.LanguageCode exposing (LanguageCode(..), fromString, toString)

{-| Limited [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) support.


# LanguageCode

@docs LanguageCode, fromString, toString

-}


{-| -}
type LanguageCode
    = AA
    | AB
    | AF
    | AK
    | AM
    | AN
    | AR
    | BA
    | BE
    | BG
    | BN
    | CA
    | CS
    | DE
    | EL
    | EN
    | ES
    | FR
    | GD
    | GL
    | HI
    | HY
    | JV
    | KO
    | MR
    | MS
    | NO
    | PA
    | PL
    | PS
    | PT
    | QU
    | RM
    | RN
    | RO
    | RU
    | SQ
    | SR
    | SV
    | TA
    | TH
    | TR
    | VI
    | ZA
    | ZH


{-| -}
fromString : String -> Maybe LanguageCode
fromString str =
    case String.toLower str of
        "aa" ->
            Just AA

        "ab" ->
            Just AB

        "af" ->
            Just AF

        "ak" ->
            Just AK

        "am" ->
            Just AM

        "an" ->
            Just AN

        "ar" ->
            Just AR

        "ba" ->
            Just BA

        "be" ->
            Just BE

        "bg" ->
            Just BG

        "bn" ->
            Just BN

        "ca" ->
            Just CA

        "cs" ->
            Just CS

        "de" ->
            Just DE

        "el" ->
            Just EL

        "en" ->
            Just EN

        "fr" ->
            Just FR

        "es" ->
            Just ES

        "gd" ->
            Just GD

        "gl" ->
            Just GL

        "hi" ->
            Just HI

        "hy" ->
            Just HY

        "jv" ->
            Just JV

        "ko" ->
            Just KO

        "mr" ->
            Just MR

        "ms" ->
            Just MS

        "no" ->
            Just NO

        "pa" ->
            Just PA

        "pl" ->
            Just PL

        "ps" ->
            Just PS

        "pt" ->
            Just PT

        "qu" ->
            Just QU

        "rm" ->
            Just RM

        "rn" ->
            Just RN

        "ro" ->
            Just RO

        "ru" ->
            Just RU

        "sq" ->
            Just SQ

        "sr" ->
            Just SR

        "sv" ->
            Just SV

        "ta" ->
            Just TA

        "th" ->
            Just TH

        "tr" ->
            Just TR

        "vi" ->
            Just VI

        "za" ->
            Just ZA

        "zh" ->
            Just ZH

        _ ->
            Nothing


{-| -}
toString : LanguageCode -> String
toString code =
    case code of
        AA ->
            "aa"

        AB ->
            "ab"

        AF ->
            "af"

        AK ->
            "ak"

        AM ->
            "am"

        AN ->
            "an"

        AR ->
            "ar"

        BA ->
            "ba"

        BE ->
            "be"

        BG ->
            "bg"

        BN ->
            "bn"

        CA ->
            "ca"

        CS ->
            "cs"

        DE ->
            "de"

        EL ->
            "el"

        EN ->
            "en"

        ES ->
            "es"

        FR ->
            "fr"

        GD ->
            "gd"

        GL ->
            "gl"

        HI ->
            "hi"

        HY ->
            "hy"

        JV ->
            "jv"

        KO ->
            "ko"

        MR ->
            "mr"

        MS ->
            "ms"

        NO ->
            "no"

        SV ->
            "sv"

        TA ->
            "ta"

        TH ->
            "th"

        TR ->
            "tr"

        PA ->
            "pa"

        PL ->
            "pl"

        PS ->
            "ps"

        PT ->
            "pt"

        QU ->
            "qu"

        RM ->
            "rm"

        RN ->
            "rn"

        RO ->
            "ro"

        RU ->
            "ru"

        SQ ->
            "sq"

        SR ->
            "sr"

        VI ->
            "vi"

        ZA ->
            "za"

        ZH ->
            "zh"
