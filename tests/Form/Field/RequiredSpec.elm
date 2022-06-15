module Form.Field.RequiredSpec exposing (suite)

import Expect
import Form.Field.Required as Required
import Test


suite : Test.Test
suite =
    Test.describe "Form.Field.Required round trip"
        ([ Required.Nullable, Required.Yes, Required.No ]
            |> List.map
                (\required ->
                    Test.test (Required.toString required) <|
                        \_ ->
                            Required.toString required
                                |> Required.fromString
                                |> Expect.equal (Just required)
                )
        )
