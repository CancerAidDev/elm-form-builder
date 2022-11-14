module Form.Lib.Pagination exposing (PaginationMsg(..), PaginationState)

{-| Helper functions for pagination functionality.


# Pagination

@docs PaginationMsg, PaginationState

-}


{-| -}
type PaginationMsg
    = UpPag
    | DownPag


{-| -}
type alias PaginationState =
    { page : Int, pageSize : Int }
