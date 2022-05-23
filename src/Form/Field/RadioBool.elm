module Form.Field.RadioBool exposing (fromString, toString)

{-| RadioBool helpers.


# RadioBool

@docs fromString, toString

-}


{-| -}
fromString : String -> Maybe Bool
fromString str =
    case str of
        "Yes" ->
            Just True

        "No" ->
            Just False

        _ ->
            Nothing


{-| -}
toString : Bool -> String
toString bool =
    if bool then
        "Yes"

    else
        "No"
