module Form.FieldSpec exposing (suite)

import Expect
import Form.Field as Field
import Form.Field.Direction as Direction
import Form.Field.Width as Width
import Fuzz
import Test


suite : Test.Test
suite =
    Test.describe "Form.updateStringValue"
        [ Test.fuzz2 Fuzz.string Fuzz.string "Update StringField " <|
            \initialString updateString ->
                let
                    fieldValues =
                        { required = False, label = "", width = Width.HalfSize, enabledBy = Nothing, order = 0, value = initialString, disabled = False }

                    field =
                        Field.text fieldValues
                in
                Field.updateStringValue updateString field
                    |> Expect.equal
                        (Field.text { fieldValues | value = updateString })
        , Test.fuzz2 Fuzz.string Fuzz.string "Update Radio " <|
            \option1 option2 ->
                let
                    radioFieldValues =
                        { required = False, label = "", width = Width.HalfSize, enabledBy = Nothing, order = 0, value = option1, default = Nothing, direction = Direction.Row, options = [ { label = Nothing, value = option1 }, { label = Nothing, value = option2 } ], disabled = False }

                    field =
                        Field.radio radioFieldValues
                in
                Field.updateStringValue option2 field
                    |> Expect.equal
                        (Field.radio { radioFieldValues | value = option2 })
        , Test.fuzz2 Fuzz.string Fuzz.string "Maybe Update Radio " <|
            \option1 option2 ->
                let
                    radioFieldValues =
                        { required = False, label = "", width = Width.HalfSize, enabledBy = Nothing, order = 0, value = option1, default = Nothing, direction = Direction.Row, options = [ { label = Nothing, value = option1 }, { label = Nothing, value = option2 } ], disabled = False }

                    field =
                        Field.radio radioFieldValues
                in
                Field.maybeUpdateStringValue (Just option2) field
                    |> Expect.equal
                        (Field.radio { radioFieldValues | value = option2 })
        ]
