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
                    field =
                        Field.text <|
                            Field.setWidth Width.HalfSize
                                >> Field.setValue initialString
                in
                Field.updateStringValue updateString field
                    |> Expect.equal
                        (Field.text <|
                            Field.setWidth Width.HalfSize
                                >> Field.setValue updateString
                        )
        , Test.fuzz2 Fuzz.string Fuzz.string "Update Radio " <|
            \option1 option2 ->
                let
                    field =
                        Field.radio
                            [ { label = Nothing, value = option1 }
                            , { label = Nothing, value = option2 }
                            ]
                        <|
                            Field.setValue option1
                                >> Field.setWidth Width.HalfSize
                                >> Field.setDirection Direction.Row
                in
                Field.updateStringValue option2 field
                    |> Expect.equal
                        (Field.radio
                            [ { label = Nothing, value = option1 }
                            , { label = Nothing, value = option2 }
                            ]
                         <|
                            Field.setValue option2
                                >> Field.setWidth Width.HalfSize
                                >> Field.setDirection Direction.Row
                        )
        , Test.fuzz2 Fuzz.string Fuzz.string "Maybe Update Radio " <|
            \option1 option2 ->
                let
                    field =
                        Field.radio
                            [ { label = Nothing, value = option1 }
                            , { label = Nothing, value = option2 }
                            ]
                        <|
                            Field.setWidth Width.HalfSize
                                >> Field.setValue option1
                                >> Field.setDirection Direction.Row
                in
                Field.maybeUpdateStringValue (Just option2) field
                    |> Expect.equal
                        (Field.radio
                            [ { label = Nothing, value = option1 }
                            , { label = Nothing, value = option2 }
                            ]
                         <|
                            Field.setWidth Width.HalfSize
                                >> Field.setValue option2
                                >> Field.setDirection Direction.Row
                        )
        ]
