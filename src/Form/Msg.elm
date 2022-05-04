module Form.Msg exposing (Msg(..))

import Form.Types.Option as Option
import Form.Types.RadioEnum as RadioEnum


type Msg
    = UpdateStringField String String
    | UpdateRadioStringField String Option.Option
    | UpdateBoolField String Bool
    | UpdateRadioBoolField String Bool
    | UpdateRadioEnumField String RadioEnum.Value
    | UpdateNumericField String String
