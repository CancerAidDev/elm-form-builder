module Form.Msg exposing (Msg(..))

{-| Form.Msg


# Msg

@docs Msg

-}

import Form.Field.FieldType as FieldType
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
    | UpdateShowDropdown FieldType.FieldType String Bool
    | UpdateSelectedDropdownValue FieldType.FieldType String String
    | UpdateSearchbar FieldType.FieldType String String
    | UpdateTags String String Bool
    | UpdateTagInput String String
