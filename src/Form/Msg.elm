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
    | UpdateRadioStringField String Option.Option
    | UpdateBoolField String Bool
    | UpdateRadioBoolField String Bool
    | UpdateRadioEnumField String RadioEnum.Value
    | UpdateNumericField String String
