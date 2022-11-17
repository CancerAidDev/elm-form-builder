module Form.Msg exposing (Msg(..))

{-| Form.Msg


# Msg

@docs Msg

-}

import Form.Field.Option as Option
import Form.Field.RadioEnum as RadioEnum


{-| -}
type Msg
    = UpdateStringField String String
    | UpdateMultiStringField String Option.Option Bool
    | UpdateRadioStringField String Option.Option
    | UpdateBoolField String Bool
    | UpdateRadioBoolField String Bool
    | UpdateRadioEnumField String RadioEnum.Value
    | UpdateNumericField String String
    | ResetField String
    | UpdateShowDropdown String Bool
    | UpdateSearchbar String String
    | UpdateTags String String (List String) Bool
    | UpdateTagInput String String
