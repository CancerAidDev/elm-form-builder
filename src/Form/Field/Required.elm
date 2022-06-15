module Form.Field.Required exposing
    ( IsRequired(..)
    , decoder
    , fromString, toString
    )

{-| Required type


# Type

@docs IsRequired


# Decoders

@docs decoder


# Helpers

@docs fromString, toString

-}

import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra


type IsRequired
    = Yes
    | Nullable
    | No


{-| -}
fromBool : Bool -> IsRequired
fromBool bool =
    case bool of
        True ->
            Yes

        False ->
            No


{-| -}
fromString : String -> Maybe IsRequired
fromString str =
    case String.toLower str of
        "nullable" ->
            Just Nullable

        "yes" ->
            Just Yes

        "no" ->
            Just No

        _ ->
            Nothing


{-| -}
toString : IsRequired -> String
toString nullable =
    case nullable of
        Nullable ->
            "nullable"

        Yes ->
            "yes"

        No ->
            "no"


{-| -}
decoder : Decode.Decoder IsRequired
decoder =
    let
        booleanDecoder =
            Decode.bool |> Decode.map fromBool

        stringDecoder =
            Decode.string |> Decode.andThen (fromString >> DecodeExtra.fromMaybe "Invalid required type")
    in
    Decode.oneOf [ booleanDecoder, stringDecoder ]
