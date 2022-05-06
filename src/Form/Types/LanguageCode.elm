module Form.Types.LanguageCode exposing (LanguageCode(..), fromString, toString)

{-| Limited [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) support. Currently limited to "en".


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
    | GD
    | GL
    | HI
    | HY
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

        GD ->
            "gd"

        GL ->
            "gl"

        HI ->
            "hi"

        HY ->
            "hy"

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

        ZH ->
            "zh"
