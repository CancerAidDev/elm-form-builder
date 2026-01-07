module Form.Msg exposing (Msg(..))

{-| Form.Msg


# Msg

@docs Msg

-}

import Form.Field.Option as Option
import Form.Field.RadioEnum as RadioEnum


{-| -}
type Msg
    = NoOp
    | UpdateStringField String String
    | UpdateSearchableSelectField String String
    | UpdateMultiStringField String Option.Option Bool
    | UpdateRadioStringField String Option.Option
    | UpdateBoolField String Bool
    | UpdateRadioBoolField String Bool
    | UpdateRadioEnumField String RadioEnum.Value
    | UpdateIntegerField String String
    | ResetField String
    | UpdateShowDropdown String Bool
    | UpdateSearchbar String String
    | UpdateTags String String Bool
    | UpdateTagInput String String
