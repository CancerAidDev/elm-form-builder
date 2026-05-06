module Form.Validate.IntegerSpec exposing (suite)

import Form.Validate as Validate
import Form.Validate.HelperSpec as HelperSpec
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Integer"
        [ Test.describe "SimpleIntegerField"
            [ HelperSpec.integerFieldTest "no bounds"
                (HelperSpec.integerField Nothing Nothing)
                [ { value = Just 0, name = "zero" }
                , { value = Just -100, name = "negative" }
                , { value = Just 999, name = "large" }
                ]
                []
            , HelperSpec.integerFieldTest "min only"
                (HelperSpec.integerField (Just 18) Nothing)
                [ { value = Just 18, name = "at min" }
                , { value = Just 99, name = "above min" }
                ]
                [ { value = Just 17, error = Validate.LessThanMin 18, name = "below min" } ]
            , HelperSpec.integerFieldTest "max only"
                (HelperSpec.integerField Nothing (Just 99))
                [ { value = Just 99, name = "at max" }
                , { value = Just 0, name = "below max" }
                ]
                [ { value = Just 100, error = Validate.GreaterThanMax 99, name = "above max" } ]
            , HelperSpec.integerFieldTest "min and max"
                (HelperSpec.integerField (Just 18) (Just 99))
                [ { value = Just 18, name = "at min" }
                , { value = Just 99, name = "at max" }
                , { value = Just 50, name = "in range" }
                ]
                [ { value = Just 17, error = Validate.GreaterThanMaxOrLessThanMin 18 99, name = "below min" }
                , { value = Just 100, error = Validate.GreaterThanMaxOrLessThanMin 18 99, name = "above max" }
                ]
            ]
        , Test.describe "LinearScaleField"
            [ HelperSpec.integerFieldTest "default scale (1-5)"
                HelperSpec.linearScaleField
                [ { value = Just 1, name = "at min" }
                , { value = Just 5, name = "at max" }
                , { value = Just 3, name = "middle" }
                ]
                [ { value = Just 0, error = Validate.GreaterThanMaxOrLessThanMin 1 5, name = "below min" }
                , { value = Just 6, error = Validate.GreaterThanMaxOrLessThanMin 1 5, name = "above max" }
                ]
            ]
        ]
